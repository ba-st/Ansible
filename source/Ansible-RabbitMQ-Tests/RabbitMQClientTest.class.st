Class {
	#name : 'RabbitMQClientTest',
	#superclass : 'TestCase',
	#instVars : [
		'reversedTexts',
		'workerProcess',
		'loggingAsserter',
		'publisher'
	],
	#category : 'Ansible-RabbitMQ-Tests',
	#package : 'Ansible-RabbitMQ-Tests'
}

{ #category : 'accessing' }
RabbitMQClientTest class >> defaultTimeLimit [

	^ ( Socket standardTimeout + 120 ) seconds
]

{ #category : 'private - support' }
RabbitMQClientTest >> addTimestampRegexTo: aLogEntryCollection [ 

  ^ aLogEntryCollection collect: [ :regexExpression |
        '\d{4}-\d{2}-\d{2}T\d{2}\:\d{2}\:\d{2}(\.\d+)?(\+|-)(\d+\:\d+) <1s>' expandMacrosWith:
          regexExpression
      ]
]

{ #category : 'private - accessing' }
RabbitMQClientTest >> anotherRabbitMQPublisher [

	^ RabbitMQPublisher configuredBy: [ :options |
			  options
				  at: #hostname put: 'localhost';
				  at: #port put: 1234;
				  at: #username put: 'bugs';
				  at: #password put: 'bunny';
				  at: #maximumConnectionAttemps put: 1;
				  at: #timeSlotBetweenConnectionRetriesInMs put: 1
		  ]
]

{ #category : 'tests' }
RabbitMQClientTest >> assertQueueStatusAfterConsuming: messagesToSend from: queueName [

  | worker queue messageWasConsumed |
  messageWasConsumed := false.
  worker := RabbitMQWorker
              configuredBy: [ :options |
                  options
                    at: #queueName put: queueName;
                    at: #queueDurable put: false
                ]
              processingMessagesWith: [ :messageReceived |
                  messageWasConsumed := true.
                  self
                    assert: messageReceived body asString equals: messagesToSend;
                    assert: messageReceived method exchange equals: '';
                    assert: messageReceived method routingKey equals: queueName;
                    deny: messageReceived method redelivered
                ].
  worker startConsumingFromQueue.
  [
    queue := worker channel queueDeclare: queueName.
    self
      assert: messageWasConsumed;
      assert: queue method messageCount equals: 0;
      assert: queue method consumerCount equals: 1
  ] ensure: [ worker stop ]
]

{ #category : 'tests' }
RabbitMQClientTest >> assertQueueStatusAfterPublishing: messagesToSend on: queueName [

  | queue messageWasPublished |
  messageWasPublished := false.

  publisher
    confirmPublicationWith: [ :command | messageWasPublished := true ]
    otherwise: [ :command | self fail ].

  queue := publisher channel queueDeclare: queueName.

  publisher publishOnly: messagesToSend onQueueNamed: queueName.

  self wait.

  queue := publisher channel queueDeclare: queueName.

  self
    assert: queue method messageCount equals: 1;
    assert: queue method consumerCount equals: 0;
    assert: messageWasPublished
]

{ #category : 'private - support' }
RabbitMQClientTest >> closeAllConnectionsOf: aRabbitmqContainerId for: aUsername because: aCloseReason [

	^ OSPlatform current runCommand:
		  ( 'docker exec <1s> rabbitmqctl close_all_user_connections <2s> <3s>'
			    expandMacrosWith: aRabbitmqContainerId
			    with: aUsername
			    with: aCloseReason )
]

{ #category : 'private - support' }
RabbitMQClientTest >> closeAllUserConnections [

	| rabbitmqContainerId closeReason |

	rabbitmqContainerId := self rabbitMQContainerID.

	closeReason := 'CloseConnectionsTest'.

	rabbitmqContainerId isEmpty
		then: [ Error signal: 'Could not find a running RabbitMQ container.' ]
		otherwise: [
			self
				closeAllConnectionsOf: rabbitmqContainerId
				for: self defaultRabbitMQWorkerUsername
				because: closeReason
			]
]

{ #category : 'private - accessing' }
RabbitMQClientTest >> defaultRabbitMQPublisher [

	^ RabbitMQPublisher configuredBy: [ :options |
			  options
				  at: #hostname put: 'localhost';
				  at: #port put: 5672;
				  at: #username: put: 'guest';
				  at: #password put: 'guest';
				  at: #extraClientProperties put: ( Dictionary new
						    at: 'process' put: 'RabbitMQClientTest Publisher';
						    yourself )
		  ]
]

{ #category : 'private - accessing' }
RabbitMQClientTest >> defaultRabbitMQWorkerUsername [

	^ AmqpConnectionBuilder usingAMQP091Protocol credentials username
]

{ #category : 'private - support' }
RabbitMQClientTest >> largerWait [
	
	"This delay aims to replicate the time required to successfully close all the RabbitMQ connections."

	( Delay forSeconds: 120 ) wait
]

{ #category : 'private - accessing' }
RabbitMQClientTest >> queueName [

	^ 'tasks-for-' , testSelector
]

{ #category : 'private - accessing' }
RabbitMQClientTest >> rabbitMQContainerID [

	^ ( OSPlatform current resultOfCommand: 'docker ps -q --filter "name=rabbitmq"' ) trim
]

{ #category : 'private - accessing' }
RabbitMQClientTest >> rabbitMQPublisherWithDebuggingLogs [

	^ RabbitMQPublisher configuredBy: [ :options |
			  options
				  at: #hostname put: 'localhost';
				  at: #port put: 5672;
				  at: #username: put: 'guest';
				  at: #password put: 'guest';
				  at: #enableDebuggingLogs put: true
		  ]
]

{ #category : 'private - support' }
RabbitMQClientTest >> resumeWorkerDuring: aBlock [

	workerProcess resume.
	Processor yield.
	self wait.
	aBlock value.
	self wait
]

{ #category : 'private - support' }
RabbitMQClientTest >> runMemoryLoggerDuring: aBlock assertingLogRecordsMatchRegexes: expectedLogEntries [ 

  | expectedLogEntriesWithTimestamp |

  expectedLogEntriesWithTimestamp := self addTimestampRegexTo: expectedLogEntries.

  loggingAsserter
    runMemoryLoggerDuring: aBlock;
    assertLogRecordsMatchUsing: expectedLogEntriesWithTimestamp
]

{ #category : 'running' }
RabbitMQClientTest >> setUp [

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
RabbitMQClientTest >> storeText: aString [

	reversedTexts add: aString
]

{ #category : 'running' }
RabbitMQClientTest >> tearDown [

	[ publisher channel queueDelete: self queueName ]
		on: AmqpDisconnectedError, NetworkError
		do: [ :signal | " Handle when tests fail and the channel was never opened" signal return ].
	publisher stop.
	workerProcess terminate.
	super tearDown
]

{ #category : 'tests' }
RabbitMQClientTest >> testCannotStartBecauseNotFoundARabbitMQService [

	self
		runMemoryLoggerDuring: [ self should: [ self anotherRabbitMQPublisher start ] raise: NetworkError ]
		assertingLogRecordsMatchRegexes:
			{ '\[INFO\] AMQP connection to localhost\:1234 failed to establish because (ConnectionClosed\: Connection aborted|ConnectionTimedOut\: Cannot connect) to 127.0.0.1\:1234' .
				'\[ERROR\] Attempt #1/1 to connect to RabbitMQ failed\: (Connection aborted|Cannot connect) to 127.0.0.1\:1234' .
				'\[INFO\] AMQP connection to localhost\:1234 failed to establish because (ConnectionClosed\: Connection aborted|ConnectionTimedOut\: Cannot connect) to 127.0.0.1\:1234' }
]

{ #category : 'tests' }
RabbitMQClientTest >> testDebuggingLogsEnabled [

	| anotherPublisher |

	anotherPublisher := self rabbitMQPublisherWithDebuggingLogs.

	self
		runMemoryLoggerDuring: [
				anotherPublisher start.
				anotherPublisher publishOnly: 'Hello!' onQueueNamed: self queueName.
				anotherPublisher stop
			]
		assertingLogRecordsMatchRegexes:
			{ '\[INFO\] AMQP connection localhost\:(\d+)->localhost\:5672 established successfully' .
				'\[DEBUG\] RabbitMQ message published \{"messagePublished"\:"Hello!","routingKey"\:"tasks-for-testDebuggingLogsEnabled","connectionDescription"\:"localhost\:(\d+)->localhost\:5672"\}' .
				'\[INFO\] AMQP connection localhost\:(\d+)->localhost\:5672 closed due to Normal shutdown' }
]

{ #category : 'tests' }
RabbitMQClientTest >> testDebuggingLogsTurnedOff [

	| anotherPublisher |

	anotherPublisher := self defaultRabbitMQPublisher.

	self
		runMemoryLoggerDuring: [
				anotherPublisher start.
				anotherPublisher publishOnly: 'Hello!' onQueueNamed: self queueName.
				anotherPublisher stop
			]
		assertingLogRecordsMatchRegexes:
			{ '\[INFO\] AMQP connection localhost\:(\d+)->localhost\:5672 established successfully' .
				'\[INFO\] AMQP connection localhost\:(\d+)->localhost\:5672 closed due to Normal shutdown' }
]

{ #category : 'tests' }
RabbitMQClientTest >> testPublisherConfirmationWhenMessageProcessed [

  | queueName messagesToSend |

  queueName := self queueName.
  messagesToSend := 'Do it!'.

  self
    assertQueueStatusAfterPublishing: messagesToSend on: queueName;
    assertQueueStatusAfterConsuming: messagesToSend from: queueName
]

{ #category : 'tests' }
RabbitMQClientTest >> testPublishingMessageWhenConnectionIsTemporallyLost [

	self resumeWorkerDuring: [
			publisher
				publishOnly: 'Hello' onQueueNamed: self queueName;
				publishOnly: 'World' onQueueNamed: self queueName.

			self wait.

			self
				assert: reversedTexts size equals: 2;
				assert: reversedTexts first equals: 'olleH';
				assert: reversedTexts last equals: 'dlroW'.

			self
				runMemoryLoggerDuring: [
						self
							closeAllUserConnections;
							largerWait.
						publisher publishOnly: 'Test connection restored' onQueueNamed: self queueName
					]
				assertingLogRecordsMatchRegexes:
					{
						'\[INFO\] AMQP connection localhost\:(\d+)->localhost\:5672 closed due to CONNECTION_FORCED - CloseConnectionsTest' .
						'\[ERROR\] RabbitMQClient disconnected due to Connection closed' .
						'\[INFO\] AMQP connection localhost\:(\d+)->localhost\:5672 established successfully' .
						'\[INFO\] AMQP connection localhost\:(\d+)->localhost\:5672 closed due to connection closed while sending data' .
						'\[INFO\] AMQP connection localhost\:(\d+)->localhost\:5672 established successfully' }
		].


	self
		assert: reversedTexts size equals: 3;
		assert: reversedTexts last equals: 'derotser noitcennoc tseT'
]

{ #category : 'tests' }
RabbitMQClientTest >> testPublishingMessages [

	self resumeWorkerDuring: [ publisher publish: #( 'Hello' 'World' ) onQueueNamed: self queueName ].

	self
		assert: reversedTexts size equals: 2;
		assert: reversedTexts first equals: 'olleH';
		assert: reversedTexts second equals: 'dlroW'
]

{ #category : 'tests' }
RabbitMQClientTest >> testPublishingOneMessage [

	self resumeWorkerDuring: [ publisher publishOnly: 'Hello' onQueueNamed: self queueName ].

	self
		withTheOnlyOneIn: reversedTexts
		do: [ :reversedText | self assert: reversedText equals: 'olleH' ]
]

{ #category : 'private - support' }
RabbitMQClientTest >> wait [

	( Delay forMilliseconds: 200 ) wait
]
