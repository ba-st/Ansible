Class {
	#name : #AMQPTest,
	#superclass : #TestCase,
	#category : #'Ansible-Tests'
}

{ #category : #'tests - asserting' }
AMQPTest >> assert: aMessageCollection has: anAmount messagesAndAreEqualsTo: anOrderedCollection [

	self
		assert: aMessageCollection size equals: anAmount;
		assertCollection: (aMessageCollection collect: [ :message | message body asString ])
			hasSameElements: anOrderedCollection
]

{ #category : #'tests - asserting' }
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

{ #category : #'tests - accessing' }
AMQPTest >> messageAs: aLevelDescription from: aSourceIdentifier to: aTargetIdentifier [

	^ (WriteStream on: String new)
		nextPutAll: (self sourceIdentifiedBy: aSourceIdentifier and: aTargetIdentifier);
		space;
		nextPutAll: aLevelDescription;
		contents
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

{ #category : #'tests - support' }
AMQPTest >> publish: aMessageCollection to: aRoute onExchangeNamed: anExchangeName of: anExchangeType [ 

	self
		withLocalhostConnectionDo: [ :connection | 
			self
				publish: aMessageCollection 
				to: aRoute 
				onExchangeNamed: anExchangeName 
				of: anExchangeType 
				over: connection
				withProperties: connection protocolClass basicPropertiesClass new ]
]

{ #category : #'tests - support' }
AMQPTest >> publish: aMessageCollection 
	to: aRoute 
	onExchangeNamed: anExchangeName 
	of: anExchangeType 
	over: aConnection
	withProperties: anAmqpProtocolProperties [

	| channel queue |

	channel := aConnection createChannel.
	channel declareExchangeNamed: anExchangeName of: anExchangeType applying: [:exchange | ].
			
	aMessageCollection
		do: [ :message | 
			channel 
				basicPublish: message utf8Encoded 
				exchange: anExchangeName 
				routingKey: aRoute 
				properties: anAmqpProtocolProperties ].

	( Delay forMilliseconds: 100 ) wait.
	queue := channel declareQueueApplying: [ :builder | builder beExclusive ].

	channel queueBind: queue method queue exchange: anExchangeName routingKey: aRoute.
	self
		assert: queue method messageCount equals: 0;
		assert: queue method consumerCount equals: 0	"The Queue will always be empty as it does not maintain old messages."
]

{ #category : #'tests - support' }
AMQPTest >> publish: aMessageCollection with: aHeadersDictionary onHeadersExchangeNamed: anExchangeName [

	self
		withLocalhostConnectionDo: [ :connection | 
			self
				publish: aMessageCollection 
				to: ''
				onExchangeNamed: anExchangeName 
				of: 'headers' 
				over: connection
				withProperties: ( connection protocolClass basicPropertiesClass new headers: aHeadersDictionary )]
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

{ #category : #'tests - accessing' }
AMQPTest >> sourceIdentifiedBy: source and: target [

	^ (WriteStream on: String new)
		nextPut: source;
		nextPut: $-;
		nextPut: target;
		contents
]

{ #category : #'tests - support' }
AMQPTest >> spawnWorkerNamed: aProcessName 
	boundToHeadersExchangeNamed: anExchangeName 
	matchingToAllOf: aHeadersDictionary 
	applying: aBlock [

	^ self
		spawnWorkerNamed: aProcessName 
		consumingFromAll: #('') 
		boundToExchangeNamed: anExchangeName 
		of: 'headers'
		withArguments: (aHeadersDictionary add: 'x-match' -> 'all'; yourself)
		applying: aBlock
]

{ #category : #'tests - support' }
AMQPTest >> spawnWorkerNamed: aProcessName 
	boundToHeadersExchangeNamed: anExchangeName 
	matchingToAnyOf: aHeadersDictionary 
	applying: aBlock [

	^ self
		spawnWorkerNamed: aProcessName 
		consumingFromAll: #('') 
		boundToExchangeNamed: anExchangeName 
		of: 'headers'
		withArguments: (aHeadersDictionary add: 'x-match' -> 'any'; yourself)
		applying: aBlock
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
AMQPTest >> spawnWorkerNamed: aProcessName 
	consumingFromAll: aRouteSet 
	boundToExchangeNamed: anExchangeName 
	of: anExchangeType 
	applying: aBlock [

	^ self
		spawnWorkerNamed: aProcessName 
		consumingFromAll: aRouteSet
		boundToExchangeNamed: anExchangeName 
		of: anExchangeType
		withArguments: nil
		applying: aBlock
]

{ #category : #'tests - support' }
AMQPTest >> spawnWorkerNamed: aProcessName 
	consumingFromAll: aRouteSet 
	boundToExchangeNamed: anExchangeName 
	of: anExchangeType
	withArguments: anArgumentsDictionary
	applying: aBlock [

	self
		withLocalhostConnectionDo: [ :connection | 
			| process channel queue |

			channel := connection createChannel.
			channel declareExchangeNamed: anExchangeName of: anExchangeType applying: [:exchange | ].
			queue := channel declareQueueApplying: [ :builder | builder beExclusive ].
			
			aRouteSet
				do: [ :route | 
					channel 
						queueBind: queue method queue 
						exchange: anExchangeName 
						routingKey: route 
						arguments: anArgumentsDictionary ].

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

	^ self 
		spawnWorkerNamed: aWorkerName
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
AMQPTest >> testPublisherSubscriberUsingHeadersExchangeMatchingAllProperties [

	| exchangeName sourceAtarget1InfoMessages sourceBInfoMessages errorMessages loggers |
	
	exchangeName := 'headers_logs'.
	sourceAtarget1InfoMessages := OrderedCollection new.
	sourceBInfoMessages := OrderedCollection new.
	errorMessages := OrderedCollection new.
	loggers := OrderedCollection new.
	
	loggers 
		add: (self
			spawnWorkerNamed: 'source_A_target_1_info_logger'
			boundToHeadersExchangeNamed: exchangeName
			matchingToAllOf:
				(Dictionary new
					at: 'source' put: 'A';
					at: 'target' put: '1';
					at: 'level' put: 'info';
					yourself)
			applying: [ :message | sourceAtarget1InfoMessages add: message ]);
		add: (self
			spawnWorkerNamed: 'source_B_info_logger'
			boundToHeadersExchangeNamed: exchangeName
			matchingToAllOf:
				(Dictionary new
					at: 'source' put: 'B';
					at: 'level' put: 'info';
					yourself)
			applying: [ :message | sourceBInfoMessages add: message ]);
		add: (self
			spawnWorkerNamed: 'error_logger'
			boundToHeadersExchangeNamed: exchangeName
			matchingToAllOf:
				(Dictionary new
					at: 'level' put: 'error';
					yourself)
			applying: [ :message | errorMessages add: message ]).

	loggers do: #resume.
	(Delay forSeconds: 1) wait.

	#('info' 'warning' 'error') do: [ :level |
		#($A $B) do: [ :sourceIdentifier | 
			#($1 $2) do: [ :targetIdentifier | | fullIdentifier |
				fullIdentifier := self sourceIdentifiedBy: sourceIdentifier and: targetIdentifier.
				self
					publish: (Array with: (self messageAs: level from: sourceIdentifier to: targetIdentifier))
					with: (Dictionary 
						with: 'source' -> sourceIdentifier asString
						with: 'target' -> targetIdentifier asString
						with: 'level' -> level)
					onHeadersExchangeNamed: exchangeName ] ] ].
		
	(Delay forSeconds: 1) wait.
	loggers do: #terminate.
	
	self
		assert: sourceAtarget1InfoMessages 
			has: 1 
			messagesAndAreEqualsTo: (
				OrderedCollection 
					with: (self messageAs: 'info' from: $A to: $1));	
		assert: sourceBInfoMessages 
			has: 2 
			messagesAndAreEqualsTo: (
				OrderedCollection 
					with: (self messageAs: 'info' from: $B to: $1)
					with: (self messageAs: 'info' from: $B to: $2));
		assert: errorMessages 
			has: 4
			messagesAndAreEqualsTo: (
				OrderedCollection 
					with: (self messageAs: 'error' from: $A to: $1)
					with: (self messageAs: 'error' from: $A to: $2)
					with: (self messageAs: 'error' from: $B to: $1)
					with: (self messageAs: 'error' from: $B to: $2))
]

{ #category : #tests }
AMQPTest >> testPublisherSubscriberUsingHeadersExchangeMatchingAnyProperty [

	| exchangeName sourceAtarget1InfoMessages sourceAtarget1ErrorMessages sourceAtarget2AllMessages sourceBtarget1AllMessages loggers |
	
	exchangeName := 'headers_logs'.
	sourceAtarget1InfoMessages := OrderedCollection new.
	sourceAtarget1ErrorMessages := OrderedCollection new.
	sourceAtarget2AllMessages := OrderedCollection new.
	sourceBtarget1AllMessages := OrderedCollection new.
	loggers := OrderedCollection new.
	
	loggers 
		add: (self
			spawnWorkerNamed: 'source_A_target_1_info_logger'
			boundToHeadersExchangeNamed: exchangeName
			matchingToAnyOf:
				(Dictionary new
					at: 'info' put: 'A-1';
					yourself)
			applying: [ :message | sourceAtarget1InfoMessages add: message ]);
		add: (self
			spawnWorkerNamed: 'source_A_target_1_error_logger'
			boundToHeadersExchangeNamed: exchangeName
			matchingToAnyOf:
				(Dictionary new
					at: 'warning' put: 'A-1';
					at: 'error' put: 'A-1';
					yourself)
			applying: [ :message | sourceAtarget1ErrorMessages add: message ]);
		add: (self
			spawnWorkerNamed: 'source_A_target_2_all_logger'
			boundToHeadersExchangeNamed: exchangeName
			matchingToAnyOf:
				(Dictionary new
					at: 'info' put: 'A-2';
					at: 'warning' put: 'A-2';
					at: 'error' put: 'A-2';
					yourself)
			applying: [ :message | sourceAtarget2AllMessages add: message ]);
		add: (self
			spawnWorkerNamed: 'source_B_target_1_all_logger'
			boundToHeadersExchangeNamed: exchangeName
			matchingToAnyOf:
				(Dictionary new
					at: 'info' put: 'B-1';
					at: 'warning' put: 'B-1';
					at: 'error' put: 'B-1';
					yourself)
			applying: [ :message | sourceBtarget1AllMessages add: message ]).

	loggers do: #resume.
	(Delay forSeconds: 1) wait.

	#('info' 'warning' 'error') do: [ :level | 
		#($A $B) do: [ :sourceIdentifier | 
			#($1 $2) do: [ :targetIdentifier | | fullIdentifier |
				fullIdentifier := self sourceIdentifiedBy: sourceIdentifier and: targetIdentifier.
				self
					publish: (Array with: (self messageAs: level from: sourceIdentifier to: targetIdentifier))
					with: (Dictionary with: level -> fullIdentifier)
					onHeadersExchangeNamed: exchangeName ] ] ].
		
	(Delay forSeconds: 1) wait.
	loggers do: #terminate.
	
	self
		assert: sourceAtarget1InfoMessages 
			has: 1 
			messagesAndAreEqualsTo: (
				OrderedCollection 
					with: (self messageAs: 'info' from: $A to: $1));	
		assert: sourceAtarget1ErrorMessages 
			has: 2 
			messagesAndAreEqualsTo: (
				OrderedCollection 
					with: (self messageAs: 'warning' from: $A to: $1)
					with: (self messageAs: 'error' from: $A to: $1));
		assert: sourceAtarget2AllMessages 
			has: 3 
			messagesAndAreEqualsTo: (
				OrderedCollection 
					with: (self messageAs: 'info' from: $A to: $2)
					with: (self messageAs: 'warning' from: $A to: $2)
					with: (self messageAs: 'error' from: $A to: $2));
		assert: sourceBtarget1AllMessages 
			has: 3 
			messagesAndAreEqualsTo: (
				OrderedCollection 
					with: (self messageAs: 'info' from: $B to: $1)
					with: (self messageAs: 'warning' from: $B to: $1)
					with: (self messageAs: 'error' from: $B to: $1))
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

	| publicErrorLoggerMessages anonymousInfoLoggerMessages publicErrorLogger anonymousInfoLogger |

	publicErrorLoggerMessages := OrderedCollection new.
	anonymousInfoLoggerMessages := OrderedCollection new.

	publicErrorLogger := self
		spawnWorkerNamed: 'public_error_logger'
		consumingFromAll: #('public.#' '.error')
		boundToExchangeNamed: 'topic_logs'
		of: 'topic'
		applying: [ :message | publicErrorLoggerMessages add: message ].

	anonymousInfoLogger := self
		spawnWorkerNamed: 'anonymous_info_logger'
		consumingFromAll: #('anonymous.*' '*.info')
		boundToExchangeNamed: 'topic_logs'
		of: 'topic'
		applying: [ :message | anonymousInfoLoggerMessages add: message ].

	publicErrorLogger resume.
	anonymousInfoLogger resume.

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
	anonymousInfoLogger terminate.

	self
		assert: publicErrorLoggerMessages size equals: 5;
		assert: anonymousInfoLoggerMessages size equals: 6
]

{ #category : #'tests - support' }
AMQPTest >> withLocalhostConnectionDo: block [

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
