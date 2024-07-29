Class {
	#name : 'RabbitMQPublisherTest',
	#superclass : 'TestCase',
	#instVars : [
		'workerProcess',
		'publisher',
		'reversedTexts',
		'loggingAsserter'
	],
	#category : 'Ansible-RabbitMQ-Tests',
	#package : 'Ansible-RabbitMQ-Tests'
}

{ #category : 'accessing' }
RabbitMQPublisherTest class >> defaultTimeLimit [

	^ ( Socket standardTimeout + 60 ) seconds
]

{ #category : 'private - accessing' }
RabbitMQPublisherTest >> addTimestampRegexTo: aLogEntryCollection [ 

  ^ aLogEntryCollection collect: [ :regexExpression |
        '\d{4}-\d{2}-\d{2}T\d{2}\:\d{2}\:\d{2}(\.\d+)?(\+|-)(\d+\:\d+) <1s>' expandMacrosWith:
          regexExpression
      ]
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

{ #category : 'private - support' }
RabbitMQPublisherTest >> runMemoryLoggerDuring: aBlock assertingLogRecordsMatchRegexes: expectedLogEntries [ 

  | expectedLogEntriesWithTimestamp |

  expectedLogEntriesWithTimestamp := self addTimestampRegexTo: expectedLogEntries.

  loggingAsserter
    runMemoryLoggerDuring: aBlock;
    assertLogRecordsMatchUsing: expectedLogEntriesWithTimestamp
]

{ #category : 'running' }
RabbitMQPublisherTest >> setUp [

	super setUp.
	
	loggingAsserter := LoggingAsserter on: self.
	reversedTexts := OrderedCollection new.

	workerProcess :=
		[| worker |
			worker := RabbitMQTextReverser workingWith: self.
			[worker start] ensure: [worker stop]]
				newProcess.
				
	workerProcess
		name: 'Text reverser worker';
		priority: Processor userBackgroundPriority.

	publisher := self defaultRabbitMQPublisher.
	publisher start
]

{ #category : 'private - accessing' }
RabbitMQPublisherTest >> storeText: aString [

	reversedTexts add: aString
]

{ #category : 'private - support' }
RabbitMQPublisherTest >> tearDown [

	publisher channel queueDelete: self queueName.
	publisher stop.
	workerProcess terminate.
	super tearDown
]

{ #category : 'running' }
RabbitMQPublisherTest >> testCannotStartBecauseNotFoundARabbitMQService [

  | anotherPublisher |
  anotherPublisher := RabbitMQPublisher configuredBy: [ :options |
                          options
                            at: #hostname put: 'localhost';
                            at: #port put: 1234;
                            at: #username put: 'bugs';
                            at: #password put: 'bunny';
                            at: #maximumConnectionAttemps put: 1;
                            at: #timeSlotBetweenConnectionRetriesInMs put: 1
                        ].

  self
    runMemoryLoggerDuring: [
      self should: [ anotherPublisher start ] raise: NetworkError ]
    assertingLogRecordsMatchRegexes:
      { '\[INFO\] AMQP connection to localhost\:1234 failed to establish because (ConnectionClosed\: Connection aborted|ConnectionTimedOut\: Cannot connect) to 127.0.0.1\:1234' .
        '\[ERROR\] Attempt #1/1 to connect to RabbitMQ failed\: (Connection aborted|Cannot connect) to 127.0.0.1\:1234' .
        '\[INFO\] AMQP connection to localhost\:1234 failed to establish because (ConnectionClosed\: Connection aborted|ConnectionTimedOut\: Cannot connect) to 127.0.0.1\:1234' }
]

{ #category : 'running' }
RabbitMQPublisherTest >> testDebuggingLogsEnabled [

  | anotherPublisher  |
  anotherPublisher := self rabbitMQPublisherWithDebuggingLogs.

  self
    runMemoryLoggerDuring: [
        anotherPublisher start.
        anotherPublisher publishOnly: 'Hola!' onQueueNamed: self queueName.
        anotherPublisher stop
      ]
    assertingLogRecordsMatchRegexes:
      { '\[INFO\] AMQP connection localhost\:(\d+)->localhost\:5672 established successfully' .
        '\[DEBUG\] RabbitMQ message published \{"messagePublished"\:"Hola!","routingKey"\:"tasks-for-testDebuggingLogsEnabled","connectionDescription"\:"localhost\:(\d+)->localhost\:5672"\}' .
        '\[INFO\] AMQP connection localhost\:(\d+)->localhost\:5672 closed normally' }
]

{ #category : 'running' }
RabbitMQPublisherTest >> testDebuggingLogsTurnedOff [

	| anotherPublisher |

	anotherPublisher := self defaultRabbitMQPublisher.

  self
    runMemoryLoggerDuring: [
        anotherPublisher start.
        anotherPublisher publishOnly: 'Hola!' onQueueNamed: self queueName.
        anotherPublisher stop
      ]
    assertingLogRecordsMatchRegexes:
      { '\[INFO\] AMQP connection localhost\:(\d+)->localhost\:5672 established successfully' .
        '\[INFO\] AMQP connection localhost\:(\d+)->localhost\:5672 closed normally' }
]

{ #category : 'running' }
RabbitMQPublisherTest >> testPublishingMessageWhenChannelIsTemporallyLost [

  self resumeWorkerDuring: [
      self
        runMemoryLoggerDuring: [
            publisher start.
            publisher channel close.
            self publish: #( 'test channel restored' ) onQueueNamed: self queueName
          ]
        assertingLogRecordsMatchRegexes: {  }
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
