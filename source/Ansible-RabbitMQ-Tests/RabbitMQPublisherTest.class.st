Class {
	#name : 'RabbitMQPublisherTest',
	#superclass : 'TestCase',
	#instVars : [
		'workerProcess',
		'publisher',
		'reversedTexts'
	],
	#category : 'Ansible-RabbitMQ-Tests',
	#package : 'Ansible-RabbitMQ-Tests'
}

{ #category : 'accessing' }
RabbitMQPublisherTest class >> defaultTimeLimit [

	^ ( Socket standardTimeout + 60 ) seconds
]

{ #category : 'private - accessing' }
RabbitMQPublisherTest >> configureConnection: aBuilder [

	aBuilder hostname: 'localhost'.
	aBuilder portNumber: 5672.
	aBuilder username: 'guest'.
	aBuilder password: 'guest'
]

{ #category : 'private - accessing' }
RabbitMQPublisherTest >> defaultRabbitMQPublisher [

	^ RabbitMQPublisher configuredBy: [ :options |
		  options
			  at: #hostname put: 'localhost';
			  at: #port put: 5672;
			  at: #username: put: 'guest';
			  at: #password put: 'guest'
		  ]
]

{ #category : 'running' }
RabbitMQPublisherTest >> initialize [

	super initialize.
	reversedTexts := OrderedCollection new
]

{ #category : 'private - accessing' }
RabbitMQPublisherTest >> publish: anObject onQueueNamed: aQueueName [

	publisher publish: anObject onQueueNamed: aQueueName
]

{ #category : 'private - accessing' }
RabbitMQPublisherTest >> queueName [

	^ 'tasks-for-' , testSelector
]

{ #category : 'private - accessing' }
RabbitMQPublisherTest >> rabbitMQPublisherWithDebuggingLogs [

	^ RabbitMQPublisher configuredBy: [ :options |
		  options
			  at: #hostname put: 'localhost';
			  at: #port put: 5672;
			  at: #username: put: 'guest';
			  at: #password put: 'guest';
			  at: #enableDebuggingLogs put: true
		  ]
]

{ #category : 'private - accessing' }
RabbitMQPublisherTest >> resumeWorkerDuring: aBlock [

	workerProcess resume.
	Processor yield.
	self wait.
	aBlock value.
	self wait
]

{ #category : 'running' }
RabbitMQPublisherTest >> setUp [

	super setUp.

	workerProcess :=
		[| worker |
			worker := RabbitMQTextReverser workingWith: self.
			[worker start] ensure: [worker stop]]
				newProcess.
				
	workerProcess
		name: 'Text reverser worker';
		priority: Processor userBackgroundPriority.

	publisher := self defaultRabbitMQPublisher.
	publisher start.
	publisher channel queueDeclare: self queueName durable: true
]

{ #category : 'private - accessing' }
RabbitMQPublisherTest >> storeText: aString [

	reversedTexts add: aString
]

{ #category : 'private - accessing' }
RabbitMQPublisherTest >> tearDown [

	publisher channel queueDelete: self queueName.
	publisher stop.
	workerProcess terminate.
	super tearDown
]

{ #category : 'running' }
RabbitMQPublisherTest >> testCannotStartBecauseNotFoundARabbitMQService [

	| anotherPublisher logger expectedErrorDescription |

	logger := MemoryLogger new.
	
	anotherPublisher :=
		RabbitMQPublisher configuredBy: [:options |
			options
				at: #hostname put: 'looney-tunes.com';
				at: #port put: 1234;
				at: #username put: 'bugs';
				at: #password put: 'bunny';
				at: #maximumConnectionAttemps put: 1;
				at: #timeSlotBetweenConnectionRetriesInMs put: 1].

	expectedErrorDescription := 'connection closed while sending data'.
	
	logger runDuring: [
		self
			should: [anotherPublisher start]
			raise: ConnectionClosed 
			description: expectedErrorDescription].

	self
		assert: logger recordings size equals: 3;
		assert: (
			logger recordings second printString endsWith:
				(#'Attempt #1/1 to connect to RabbitMQ failed: <1s>' expandMacrosWith: expectedErrorDescription))
]

{ #category : 'running' }
RabbitMQPublisherTest >> testDebuggingLogsEnabled [

	| anotherPublisher logger |

	logger := MemoryLogger new.
	anotherPublisher := self rabbitMQPublisherWithDebuggingLogs.

	logger runDuring: [
		anotherPublisher start.
		anotherPublisher publishOnly: 'Hola!' onQueueNamed: self queueName.
		anotherPublisher stop
		].

	self assert: logger recordings size equals: 3.

	self assert: ( '*[INFO] AMQP connection *->localhost:5672 established successfully' match:
			  ( logger recordings at: 1 ) printString ).

	self assert:
		( '* [DEBUG] RabbitMQ message published {"messagePublished":"Hola!","routingKey":"tasks-for-testDebuggingLogsEnabled","connectionDescription":"*->localhost:5672"}'
			  match: ( logger recordings at: 2 ) printString ).

	self assert: ( '* [INFO] AMQP connection *->localhost:5672 closed normally' match:
			  ( logger recordings at: 3 ) printString )
]

{ #category : 'running' }
RabbitMQPublisherTest >> testDebuggingLogsTurnedOff [

	| anotherPublisher logger |

	logger := MemoryLogger new.
	anotherPublisher := self defaultRabbitMQPublisher.

	logger runDuring: [
		anotherPublisher start.
		anotherPublisher publishOnly: 'Hola!' onQueueNamed: self queueName.
		anotherPublisher stop
		].

	self assert: logger recordings size equals: 2.

	self assert: ( '*[INFO] AMQP connection *->localhost:5672 established successfully' match:
			  ( logger recordings at: 1 ) printString ).

	self assert: ( '* [INFO] AMQP connection *->localhost:5672 closed normally' match:
			  ( logger recordings at: 2 ) printString )
]

{ #category : 'running' }
RabbitMQPublisherTest >> testPublishingMessageWhenChannelIsTemporallyLost [

	self resumeWorkerDuring: [
		publisher channel close.
		self publish: #( 'test channel restored' ) onQueueNamed: self queueName
		].

	self
		withTheOnlyOneIn: reversedTexts
		do: [ :reversedText | self assert: reversedText equals: 'derotser lennahc tset' ]
]

{ #category : 'running' }
RabbitMQPublisherTest >> testPublishingMessages [

	self resumeWorkerDuring: [
		self publish: #( 'first message' 'second message' ) onQueueNamed: self queueName ].

	self
		assert: reversedTexts size equals: 2;
		assert: reversedTexts first equals: 'egassem tsrif';
		assert: reversedTexts second equals: 'egassem dnoces'
]

{ #category : 'running' }
RabbitMQPublisherTest >> testPublishingOneMessage [

	self resumeWorkerDuring: [ publisher publishOnly: 'one message' onQueueNamed: self queueName ].

	self
		withTheOnlyOneIn: reversedTexts
		do: [ :reversedText | self assert: reversedText equals: 'egassem eno' ]
]

{ #category : 'private - accessing' }
RabbitMQPublisherTest >> wait [

	( Delay forMilliseconds: 200 ) wait
]
