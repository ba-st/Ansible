Class {
	#name : #AMQPTest,
	#superclass : #TestCase,
	#category : #'Amqp-Tests'
}

{ #category : #tests }
AMQPTest >> assertQueueNamed: queueName IsEmtpyOn: channel [

	| queue |

	queue := channel queueDeclare: queueName.

	self
		assert: queue method messageCount equals: 0;
		assert: queue method consumerCount equals: 0.
	^ queue
]

{ #category : #'tests - support' }
AMQPTest >> publish: aMessageCollection onQueueNamed: aQueueName [

	| connection channel queue |

	connection := AmqpConnectionBuilder new
		hostname: 'localhost';
		build.
	connection open.

	channel := connection createChannel.
	channel queueDeclare: aQueueName.

	aMessageCollection
		do: [ :message | channel basicPublish: message utf8Encoded exchange: '' routingKey: aQueueName ].


	( Delay forMilliseconds: 100 ) wait.
	queue := channel queueDeclare: aQueueName.

	self
		assert: queue method messageCount equals: aMessageCollection size;
		assert: queue method consumerCount equals: 0.

	connection close
]

{ #category : #'tests - support' }
AMQPTest >> spawnWorkerNamed: aProcessName consumeFrom: aQueueName applying: aBlock [ 
	
	| connection channel process |
	
	connection := AmqpConnectionBuilder new
		hostname: 'localhost';
		build.
	connection open.

	channel := connection createChannel.
	channel queueDeclare: aQueueName.

	channel prefetchCount: 1.

	channel
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
			[ [ [ connection waitForEvent ] repeat ] ensure: [ connection close ] ] asContext
		priority: Processor activePriority.
	process name: aProcessName.
	
	^process
]

{ #category : #tests }
AMQPTest >> testBasicConsume [

	| connection channel queue |
	
	self publish: #('Do it!') onQueueNamed: 'tasks'.
	
	connection := AmqpConnectionBuilder new
		hostname: 'localhost';
		build.
	connection open.

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

	channel queueDelete: 'tasks'.
	connection close
]

{ #category : #tests }
AMQPTest >> testBasicConsumeWithMultipleWorkers [

	| firstWorkerMessages secondWorkerMessages firstWorker secondWorker |

	firstWorkerMessages := OrderedCollection new.
	secondWorkerMessages := OrderedCollection new.

	self
		publish: #('Do it!' 'Do it.!' 'Do it...!' 'Do it....!' 'Do it.....!' 'Do it......!')
		onQueueNamed: 'tasks'.

	firstWorker := self
		spawnWorkerNamed: 'first_worker'
		consumeFrom: 'tasks'
		applying: [ :message | 
			| delay |

			delay := message body count: [ :char | char = $. ].
			( Delay forMilliseconds: delay * 10) wait.
			firstWorkerMessages add: message
			].

	secondWorker := self
		spawnWorkerNamed: 'second_worker'
		consumeFrom: 'tasks'
		applying: [ :message | 
			| delay |

			delay := message body count: [ :char | char = $. ].
			( Delay forMilliseconds: delay * 10) wait.
			secondWorkerMessages add: message
			].
		
	firstWorker resume.
	secondWorker resume.

	( Delay forSeconds: 3 ) wait.

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
		declaredOnChannelDo: [ :queue :channel | | messageReceived |			

			channel
				basicPublish: 'Hello world!' utf8Encoded
				exchange: ''
				routingKey: queue method queue.

			messageReceived := channel basicGet: queue method queue.

			self
				assert: messageReceived body asString equals: 'Hello world!';
				assert: messageReceived method exchange equals: '';
				assert: messageReceived method routingKey equals: queue method queue;
				deny: messageReceived method redelivered;
				assert: messageReceived method messageCount equals: 0 ]
]

{ #category : #tests }
AMQPTest >> testBasicGetWithExplicitAcknowledge [

	self
		withQueueNamed: 'hello'
		declaredOnChannelDo: [ :queue :channel | | messageReceived |

			channel
				basicPublish: 'Hello world!' utf8Encoded
				exchange: ''
				routingKey: queue method queue.

			messageReceived := channel basicGet: queue method queue.

			self
				assert: messageReceived body asString equals: 'Hello world!';
				assert: messageReceived method exchange equals: '';
				assert: messageReceived method routingKey equals: 'hello';
				deny: messageReceived method redelivered;
				assert: messageReceived method messageCount equals: 0.

			channel basicAck: messageReceived method deliveryTag.
			
"						queue := channel queueDeclare: 'hello'.
			
			self assert: queue method messageCount equals: 0;
			assert: queue method consumerCount equals: 0.
"
			messageReceived := channel basicGet: queue method queue.
			self assert: messageReceived body isNil.

]
]

{ #category : #tests }
AMQPTest >> testBasicGetWithImplicitAcknowledge [

	self
		withQueueNamed: 'hello'
		declaredOnChannelDo: [ :queue :channel | | messageReceived |

			channel
				basicPublish: 'Hello world!' utf8Encoded
				exchange: ''
				routingKey: queue method queue.

			messageReceived := channel basicGet: queue method queue noAck: true.

			self
				assert: messageReceived body asString equals: 'Hello world!';
				assert: messageReceived method exchange equals: '';
				assert: messageReceived method routingKey
					equals: queue method queue;
				deny: messageReceived method redelivered;
				assert: messageReceived method messageCount equals: 0.

			"Cannot store into ->queue := channel queueDeclare: 'hello'.
			
			self assert: queue method messageCount equals: 0;
			assert: queue method consumerCount equals: 0.				"

			self assert: (channel basicGet: queue method queue) body isNil.
			channel queueDelete: queue method queue ]
]

{ #category : #'as yet unclassified' }
AMQPTest >> withQueueNamed: aQueueName declaredOnChannelDo: aBlock [

	| connection channel |

	connection := AmqpConnectionBuilder new
		hostname: 'localhost';
		build.
	connection open.

	channel := connection createChannel.
	aBlock value: (channel queueDeclare: aQueueName) value: channel.
	channel queueDelete: aQueueName.
	
	connection close
]
