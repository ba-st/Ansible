Class {
	#name : #AMQPTest,
	#superclass : #TestCase,
	#category : #'Ansible-Tests'
}

{ #category : #tests }
AMQPTest >> assertContentsFor: messageReceived [

	self
		assert: messageReceived body asString equals: 'Hello world!';
		assert: messageReceived method exchange equals: '';
		assert: messageReceived method routingKey equals: 'hello';
		deny: messageReceived method redelivered;
		assert: messageReceived method messageCount equals: 0
]

{ #category : #'tests - support' }
AMQPTest >> assertQueueNamed: queueName IsEmtpyOn: channel [

	| queue |

	queue := channel queueDeclare: queueName.

	self
		assert: queue method messageCount equals: 0;
		assert: queue method consumerCount equals: 0.
	^ queue
]

{ #category : #'tests - support' }
AMQPTest >> publish: aMessageCollection onExchangeNamed: anExchangeName of: anExchangeType [

	self
		publish: aMessageCollection
		to: ''
		onExchangeNamed: anExchangeName
		of: anExchangeType
]

{ #category : #'tests - support' }
AMQPTest >> publish: aMessageCollection onQueueNamed: aQueueName [

	self
		withLocalhostConnectionDo: [ :connection | 
			| channel queue |

			channel := connection createChannel.
			channel queueDeclare: aQueueName.

			aMessageCollection
				do: [ :message | 
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
				assert: queue method consumerCount equals: 0
			]
]

{ #category : #'tests - support' }
AMQPTest >> publish: aMessageCollection to: aRoute onExchangeNamed: anExchangeName of: anExchangeType [ 

	self
		withLocalhostConnectionDo: [ :connection | 
			| channel queue |

			channel := connection createChannel.
			channel declareExchangeNamed: anExchangeName of: anExchangeType applying: [:exchange | ].
			
			aMessageCollection
				do: [ :message | channel basicPublish: message utf8Encoded exchange: anExchangeName routingKey: aRoute ].

			( Delay forMilliseconds: 100 ) wait.
			queue := channel declareQueueApplying: [ :builder | builder beExclusive ].

			channel queueBind: queue method queue exchange: anExchangeName routingKey: aRoute.
			self
				assert: queue method messageCount equals: 0;
				assert: queue method consumerCount equals: 0	"The Queue will always be empty as it does not maintain old messages."
			]
]

{ #category : #'tests - support' }
AMQPTest >> setUp [

	"Clean up the queues in case any of the previous tests failed."

	super setUp.
	self
		withLocalhostConnectionDo: [ :connection | 
			connection createChannel
				queueDelete: 'tasks';
				queueDelete: 'hello'
			]
]

{ #category : #'tests - support' }
AMQPTest >> spawnWorkerNamed: aProcessName consumingFrom: aQueueName applying: aBlock [

	self
		withLocalhostConnectionDo: [ :connection | 
			| process channel |

			channel := connection createChannel.
			channel
				queueDeclare: aQueueName;
				prefetchCount: 1;
				consumeFrom: 'tasks'
					applying: [ :messageReceived | 
					self
						assert: messageReceived method exchange equals: '';
						assert: messageReceived method routingKey equals: aQueueName;
						deny: messageReceived method redelivered.

					aBlock value: messageReceived.

					channel basicAck: messageReceived method deliveryTag
					].
			process := Process
				forContext:
					[ [ [ connection waitForEvent ] repeat ]
						ensure: [ connection close ]
					] asContext
				priority: Processor activePriority.
			process name: aProcessName.

			^ process
			]
]

{ #category : #'tests - support' }
AMQPTest >> spawnWorkerNamed: aProcessName consumingFromAll: aRouteSet boundToExchangeNamed: anExchangeName of: anExchangeType applying: aBlock [

	self
		withLocalhostConnectionDo: [ :connection | 
			| process channel queue |

			channel := connection createChannel.
			channel declareExchangeNamed: anExchangeName of: anExchangeType applying: [:exchange | ].
			queue := channel declareQueueApplying: [ :builder | builder beExclusive ].
			
			aRouteSet
				do: [ :route | channel queueBind: queue method queue exchange: anExchangeName routingKey: route ].

			channel
				consumeFrom: queue method queue
				applying: [ :messageReceived | 
					self
						assert: messageReceived method exchange equals: anExchangeName;
						deny: messageReceived method redelivered.

					aBlock value: messageReceived.

					channel basicAck: messageReceived method deliveryTag
					].
			process := Process
				forContext:
					[ [ [ connection waitForEvent ] repeat ]
						ensure: [ connection close ]
					] asContext
				priority: Processor activePriority.
			process name: aProcessName.

			^ process
			]
]

{ #category : #'tests - support' }
AMQPTest >> spawnWorkerNamed: aWorkerName consumingFromExchangeNamed: anExchangeName of: anExchangeType applying: aBlock [

	^ self spawnWorkerNamed: aWorkerName
		  consumingFromAll: #( '' )
		  boundToExchangeNamed: anExchangeName
		  of: anExchangeType
		  applying: aBlock
]

{ #category : #tests }
AMQPTest >> testBasicConsume [

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

{ #category : #tests }
AMQPTest >> testBasicConsumeWithMultipleWorkers [

	| firstWorkerMessages secondWorkerMessages firstWorker secondWorker |

	firstWorkerMessages := OrderedCollection new.
	secondWorkerMessages := OrderedCollection new.

	self
		publish: #('Do it!' 'Do it.!' 'Do it..!' 'Do it...!' 'Do it....!' 'Do it.....!')
		onQueueNamed: 'tasks'.

	firstWorker := self
		spawnWorkerNamed: 'first_worker'
		consumingFrom: 'tasks'
		applying: [ :message | 
			( Delay forMilliseconds: ( message body count: [ :char | char = $. ] ) * 500 ) wait.
			firstWorkerMessages add: message
			].
		
	secondWorker := self
		spawnWorkerNamed: 'second_worker'
		consumingFrom: 'tasks'
		applying: [ :message | 
			( Delay forMilliseconds: ( message body count: [ :char | char = $. ] ) * 500 ) wait.
			secondWorkerMessages add: message
			].

	firstWorker resume.
	secondWorker resume.

	( Delay forSeconds: 5 ) wait.

	firstWorker terminate.
	secondWorker terminate.

	self
		assert: firstWorkerMessages size equals: 3;
		assert: secondWorkerMessages size equals: 3
]

{ #category : #tests }
AMQPTest >> testBasicGet [

	self
		withQueueNamed: 'hello'
		declaredOnChannelDo: [ :queue :channel | 
			channel basicPublish: 'Hello world!' utf8Encoded exchange: '' routingKey: queue method queue.

			self assertContentsFor: ( channel basicGet: queue method queue )
			]
]

{ #category : #tests }
AMQPTest >> testBasicGetWithExplicitAcknowledge [

	self
		withQueueNamed: 'hello'
		declaredOnChannelDo: [ :queue :channel | 
			| messageReceived |

			channel basicPublish: 'Hello world!' utf8Encoded exchange: '' routingKey: queue method queue.

			messageReceived := channel basicGet: queue method queue.

			self assertContentsFor: messageReceived.

			channel basicAck: messageReceived method deliveryTag.

			self assert: ( channel basicGet: queue method queue ) body isNil
			]
]

{ #category : #tests }
AMQPTest >> testBasicGetWithImplicitAcknowledge [

	self
		withQueueNamed: 'hello'
		declaredOnChannelDo: [ :queue :channel | 
			| messageReceived |

			channel basicPublish: 'Hello world!' utf8Encoded exchange: '' routingKey: queue method queue.

			messageReceived := channel basicGet: queue method queue noAck: true.

			self assertContentsFor: messageReceived.

			self assert: ( channel basicGet: queue method queue ) body isNil
			]
]

{ #category : #tests }
AMQPTest >> testPublisherSubscriberUsingFanoutExchange [

	| firstWorkerMessages secondWorkerMessages firstWorker secondWorker |

	firstWorkerMessages := OrderedCollection new.
	secondWorkerMessages := OrderedCollection new.

	firstWorker := self
		spawnWorkerNamed: 'first_worker'
		consumingFromExchangeNamed: 'logs'
		of: 'fanout'
		applying: [ :message | firstWorkerMessages add: message ].

	secondWorker := self
		spawnWorkerNamed: 'second_worker'
		consumingFromExchangeNamed: 'logs'
		of: 'fanout'
		applying: [ :message | secondWorkerMessages add: message ].

	firstWorker resume.
	secondWorker resume.

	self publish: #('Log' 'Log' 'Log' 'Log' 'Log') onExchangeNamed: 'logs' of: 'fanout'.

	( Delay forSeconds: 1 ) wait.

	firstWorker terminate.
	secondWorker terminate.

	self
		assert: firstWorkerMessages size equals: 5;
		assert: secondWorkerMessages size equals: 5
]

{ #category : #tests }
AMQPTest >> testPublisherSubscriberUsingRoutesBoundToDirectExchange [

	| errorLoggerMessages loggerMessages errorLogger logger |

	errorLoggerMessages := OrderedCollection new.
	loggerMessages := OrderedCollection new.

	errorLogger := self
		spawnWorkerNamed: 'error_logger'
		consumingFromAll: #('error')
		boundToExchangeNamed: 'direct_logs'
		of: 'direct'
		applying: [ :message | errorLoggerMessages add: message ].

	logger := self
		spawnWorkerNamed: 'logger'
		consumingFromAll: #('info' 'warning' 'error')
		boundToExchangeNamed: 'direct_logs'
		of: 'direct'
		applying: [ :message | loggerMessages add: message ].

	errorLogger resume.
	logger resume.

	self
		publish: #('Log' 'Log' 'Log')
		to: 'info'
		onExchangeNamed: 'direct_logs'
		of: 'direct'.
	self
		publish: #('Log')
		to: 'error'
		onExchangeNamed: 'direct_logs'
		of: 'direct'.
	self
		publish: #('Log' 'Log')
		to: 'warning'
		onExchangeNamed: 'direct_logs'
		of: 'direct'.
	self
		publish: #('Log' 'Log' 'Log')
		to: 'info'
		onExchangeNamed: 'direct_logs'
		of: 'direct'.

	( Delay forSeconds: 1 ) wait.

	errorLogger terminate.
	logger terminate.

	self
		assert: errorLoggerMessages size equals: 1;
		assert: loggerMessages size equals: 9
]

{ #category : #tests }
AMQPTest >> testPublisherSubscriberUsingTopicsExchange [

	| publicErrorLoggerMessages anonymousInfoLoggerMessages publicErrorLogger anonymousInfoLoffer |

	publicErrorLoggerMessages := OrderedCollection new.
	anonymousInfoLoggerMessages := OrderedCollection new.

	publicErrorLogger := self
		spawnWorkerNamed: 'public_error_logger'
		consumingFromAll: #('public.#' '.error')
		boundToExchangeNamed: 'topic_logs'
		of: 'topic'
		applying: [ :message | publicErrorLoggerMessages add: message ].

	anonymousInfoLoffer := self
		spawnWorkerNamed: 'anonymous_info_logger'
		consumingFromAll: #('anonymous.*' '*.info')
		boundToExchangeNamed: 'topic_logs'
		of: 'topic'
		applying: [ :message | anonymousInfoLoggerMessages add: message ].

	publicErrorLogger resume.
	anonymousInfoLoffer resume.

	( Delay forSeconds: 1 ) wait.

	self
		publish: #('Log' 'Log' 'Log')
		to: 'anonymous.info'
		onExchangeNamed: 'topic_logs'
		of: 'topic'.
	self
		publish: #('Log')
		to: 'anonymous.error'
		onExchangeNamed: 'topic_logs'
		of: 'topic'.
	self
		publish: #('Log' 'Log')
		to: 'public.info'
		onExchangeNamed: 'topic_logs'
		of: 'topic'.
	self
		publish: #('Log' 'Log' 'Log')
		to: 'public.error'
		onExchangeNamed: 'topic_logs'
		of: 'topic'.

	( Delay forSeconds: 1 ) wait.

	publicErrorLogger terminate.
	anonymousInfoLoffer terminate.

	self
		assert: publicErrorLoggerMessages size equals: 5;
		assert: anonymousInfoLoggerMessages size equals: 6
]

{ #category : #'tests - support' }
AMQPTest >> withLocalhostConnectionDo: block [

	| connection |

	connection := AmqpConnectionBuilder new
		hostname: 'localhost';
		build.
	connection open.

	block value: connection.

	connection close
]

{ #category : #'tests - support' }
AMQPTest >> withQueueNamed: aQueueName declaredOnChannelDo: aBlock [

	self withQueueNamed: aQueueName declaredOnChannelDo: aBlock deleteQueueOnReturn: true
]

{ #category : #'tests - support' }
AMQPTest >> withQueueNamed: aQueueName declaredOnChannelDo: aBlock deleteQueueOnReturn: aBoolean [

	self
		withLocalhostConnectionDo: [ :connection | 
			| channel |

			channel := connection createChannel.
			aBlock value: ( channel queueDeclare: aQueueName ) value: channel.
			aBoolean
				ifTrue: [ channel queueDelete: aQueueName ]
			]
]
