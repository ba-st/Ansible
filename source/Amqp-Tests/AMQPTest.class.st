Class {
	#name : #AMQPTest,
	#superclass : #TestCase,
	#category : #'Amqp-Tests'
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
AMQPTest >> publish: aMessageCollection onExchangeNamed: anExchangeName withType: anExchangeType [

	self
		withLocalhostConnectionDo: [ :connection | 
			| channel queue |

			channel := connection createChannel.
			channel exchangeDeclare: anExchangeName type: anExchangeType.

			aMessageCollection
				do: [ :message | channel basicPublish: message utf8Encoded exchange: anExchangeName routingKey: '' ].

			( Delay forMilliseconds: 100 ) wait.
			queue := channel
				queueDeclare: ''
				durable: false
				exclusive: true
				autoDelete: false
				passive: false
				arguments: nil.

			channel queueBind: queue method queue exchange: anExchangeName routingKey: ''.
			self
				assert: queue method messageCount equals: 0;
				assert: queue method consumerCount equals: 0	"The Queue will always be empty as it does not maintain old messages."
			]
]

{ #category : #'tests - support' }
AMQPTest >> publish: aMessageCollection onExchangeNamed: anExchangeName withType: anExchangeType to: aRoute [ 

self
		withLocalhostConnectionDo: [ :connection | 
			| channel queue |

			channel := connection createChannel.
			channel exchangeDeclare: anExchangeName type: anExchangeType.

			aMessageCollection
				do: [ :message | channel basicPublish: message utf8Encoded exchange: anExchangeName routingKey: aRoute ].

			( Delay forMilliseconds: 100 ) wait.
			queue := channel
				queueDeclare: ''
				durable: false
				exclusive: true
				autoDelete: false
				passive: false
				arguments: nil.

			channel queueBind: queue method queue exchange: anExchangeName routingKey: aRoute.
			self
				assert: queue method messageCount equals: 0;
				assert: queue method consumerCount equals: 0	"The Queue will always be empty as it does not maintain old messages."
			]
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
AMQPTest >> spawnWorkerNamed: aProcessName consumeFrom: aQueueName applying: aBlock [

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
AMQPTest >> spawnWorkerNamed: aProcessName consumeFromExchange: anExchangeName withType: anExchangeType applying: aBlock [

	self
		withLocalhostConnectionDo: [ :connection | 
			| process channel queue |

			channel := connection createChannel.
			channel exchangeDeclare: anExchangeName type: anExchangeType.
			queue := channel
				queueDeclare: ''
				durable: false
				exclusive: true
				autoDelete: false
				passive: false
				arguments: nil.

			channel queueBind: queue method queue exchange: anExchangeName routingKey: ''.
			channel
				consumeFrom: queue method queue
				applying: [ :messageReceived | 
					self
						assert: messageReceived method exchange equals: anExchangeName;
						assert: messageReceived method routingKey equals: '';
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
AMQPTest >> spawnWorkerNamed: aProcessName consumingFrom: aRouteSet boundToExchange: anExchangeName withType: anExchangeType applying: aBlock [

	self
		withLocalhostConnectionDo: [ :connection | 
			| process channel queue |

			channel := connection createChannel.
			channel exchangeDeclare: anExchangeName type: anExchangeType.
			queue := channel
				queueDeclare: ''
				durable: false
				exclusive: true
				autoDelete: false
				passive: false
				arguments: nil.

			aRouteSet
				do: [ :route | channel queueBind: queue method queue exchange: anExchangeName routingKey: route ].

			channel
				consumeFrom: queue method queue
				applying: [ :messageReceived | 
					self
						assert: messageReceived method exchange equals: anExchangeName;
						assert: ( aRouteSet includes: messageReceived method routingKey );
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
		consumeFrom: 'tasks'
		applying: [ :message | 
			( Delay forMilliseconds: ( message body count: [ :char | char = $. ] ) * 500 ) wait.
			firstWorkerMessages add: message
			].
		
	secondWorker := self
		spawnWorkerNamed: 'second_worker'
		consumeFrom: 'tasks'
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
AMQPTest >> testBasicPublishSubscribe [

	| firstWorkerMessages secondWorkerMessages firstWorker secondWorker |

	firstWorkerMessages := OrderedCollection new.
	secondWorkerMessages := OrderedCollection new.

	firstWorker := self
		spawnWorkerNamed: 'first_worker'
		consumeFromExchange: 'logs'
		withType: 'fanout'
		applying: [ :message | firstWorkerMessages add: message ].

	secondWorker := self
		spawnWorkerNamed: 'second_worker'
		consumeFromExchange: 'logs'
		withType: 'fanout'
		applying: [ :message | secondWorkerMessages add: message ].

	firstWorker resume.
	secondWorker resume.

	self publish: #('Log' 'Log' 'Log' 'Log' 'Log') onExchangeNamed: 'logs' withType: 'fanout'.

	( Delay forSeconds: 1 ) wait.

	firstWorker terminate.
	secondWorker terminate.

	self
		assert: firstWorkerMessages size equals: 5;
		assert: secondWorkerMessages size equals: 5
]

{ #category : #tests }
AMQPTest >> testRouting [

	| errorLoggerMessages loggerMessages errorLogger secondWorker |

	errorLoggerMessages := OrderedCollection new.
	loggerMessages := OrderedCollection new.

	errorLogger := self
		spawnWorkerNamed: 'error_logger'
		consumingFrom: #('error')
		boundToExchange: 'direct_logs'
		withType: 'direct'
		applying: [ :message | errorLoggerMessages add: message ].

	secondWorker := self
		spawnWorkerNamed: 'logger'
		consumingFrom: #('info' 'warning' 'error')
		boundToExchange: 'direct_logs'
		withType: 'direct'
		applying: [ :message | loggerMessages add: message ].

	errorLogger resume.
	secondWorker resume.

	self
		publish: #('Log' 'Log' 'Log')
		onExchangeNamed: 'direct_logs'
		withType: 'direct'
		to: 'info'.
	self
		publish: #('Log')
		onExchangeNamed: 'direct_logs'
		withType: 'direct'
		to: 'error'.
	self
		publish: #('Log' 'Log')
		onExchangeNamed: 'direct_logs'
		withType: 'direct'
		to: 'warning'.
	self
		publish: #('Log' 'Log' 'Log')
		onExchangeNamed: 'direct_logs'
		withType: 'direct'
		to: 'info'.

	( Delay forSeconds: 1 ) wait.

	errorLogger terminate.
	secondWorker terminate.

	self
		assert: errorLoggerMessages size equals: 1;
		assert: loggerMessages size equals: 9
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
