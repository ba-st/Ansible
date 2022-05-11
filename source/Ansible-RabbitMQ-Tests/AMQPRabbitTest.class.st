Class {
	#name : #AMQPRabbitTest,
	#superclass : #TestCase,
	#category : #'Ansible-RabbitMQ-Tests'
}

{ #category : #private }
AMQPRabbitTest >> publish: aMessageCollection onQueueNamed: aQueueName [

	self withLocalhostConnectionDo: [ :connection | 
		| channel queue confirmationWasReceived |

		confirmationWasReceived := false.

		channel := connection createChannel.
		channel queueDeclare: aQueueName.
		channel
			confirmMessagesPublicationWith: [ :command | confirmationWasReceived := true ]
			andThoseNotProcessedWith: [ :command | self fail ].
		aMessageCollection do: [ :message | 
			channel
				basicPublish: message utf8Encoded
				exchange: ''
				routingKey: aQueueName
				properties: ( connection protocolClass basicPropertiesClass new deliveryMode: 2 )
			].

		( Delay forMilliseconds: 100 ) wait.
		queue := channel queueDeclare: aQueueName.

		self
			assert: queue method messageCount equals: aMessageCollection size;
			assert: queue method consumerCount equals: 0;
			assert: confirmationWasReceived
		]
]

{ #category : #tests }
AMQPRabbitTest >> testBasicConsumeUsingPublisherConfirmation [

	| channel queue |

	self publish: #('Do it!') onQueueNamed: 'tasks'.

	self
		withLocalhostConnectionDo: [ :connection | 
			channel := connection createChannel.
			queue := channel queueDeclare: 'tasks'.

			channel prefetchCount: 1.

			channel
				consumeFrom: 'tasks'
				applying: [ :messageReceived | 
					self
						assert: messageReceived body asString equals: 'Do it!';
						assert: messageReceived method exchange equals: '';
						assert: messageReceived method routingKey equals: 'tasks';
						deny: messageReceived method redelivered.

					channel basicAck: messageReceived method deliveryTag
					].

			queue := channel queueDeclare: 'tasks'.

			self
				assert: queue method messageCount equals: 0;
				assert: queue method consumerCount equals: 1.

			channel queueDelete: 'tasks'
			]
]

{ #category : #private }
AMQPRabbitTest >> withLocalhostConnectionDo: block [

	| connection |

	connection := AmqpConnectionBuilder usingAMQP091Protocol build.
	connection open.
	connection
		whenConnected: [ 
			block value: connection.
			connection close
			]
		whenNot: [ :error | self fail: error messageText ]
]
