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
                    at: #queueDurable put: false;
                    at: #enableDebuggingLogs put: true
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
    queue := worker channel declareQueueApplying: [ :builder | builder name: queueName ].
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
    onPublicationConfirmationDo: [ :command | messageWasPublished := true ]
    onRejectionDo: [ :command | self fail ].

  queue := publisher channel declareQueueApplying: [ :builder | builder name: queueName ].

  publisher publish: messagesToSend to: queueName.

  self wait.

  queue := publisher channel declareQueueApplying: [ :builder | builder name: queueName ].

  self
    assert: queue method messageCount equals: 1;
    assert: queue method consumerCount equals: 0;
    assert: messageWasPublished
]

{ #category : 'private - support' }
RabbitMQClientTest >> closeAllConnectionsFromTheBrokerSide [

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

{ #category : 'tests' }
RabbitMQClientTest >> closeAllConnectionsFromTheClientSide [

  Socket allInstances
    select: [ :socket | socket isConnected and: [ socket remotePort = 5672 ] ]
    thenDo: #closeAndDestroy
]

{ #category : 'private - support' }
RabbitMQClientTest >> closeAllConnectionsOf: aRabbitmqContainerId for: aUsername because: aCloseReason [

	^ OSPlatform current runCommand:
		  ( 'docker exec <1s> rabbitmqctl close_all_user_connections <2s> <3s>'
			    expandMacrosWith: aRabbitmqContainerId
			    with: aUsername
			    with: aCloseReason )
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
RabbitMQClientTest >> runWorkerNamed: aName consumingFrom: aQueueName bindedTo: anExchange routedBy: aRoutingKey doing: aProcessingBlock during: aBlock [

  | process |
  process := [
               | worker |
               worker := RabbitMQWorker
                           configuredBy: [ :options |
                               options
                                 at: #hostname put: 'localhost';
                                 at: #queueName put: aQueueName;
                                 at: #extraClientProperties put: ( Dictionary new
                                       at: 'process' put: aName;
                                       yourself )
                             ]
                           processingPayloadWith: aProcessingBlock.
               worker bindQueueTo: anExchange routedBy: aRoutingKey.
               [ worker start ] ensure: [
                   worker unbindQueueTo: anExchange routedBy: aRoutingKey.
                   worker stop
                 ]
             ] newProcess.
  process
    name: aName;
    priority: Processor userBackgroundPriority.

  [
    process resume.
    Processor yield.
    self wait.
    aBlock value.
    self wait
  ] ensure: [ process terminate ]
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
				anotherPublisher publish: 'Hello!' to: self queueName.
				anotherPublisher stop
			]
		assertingLogRecordsMatchRegexes:
			{ '\[INFO\] AMQP connection localhost\:(\d+)->localhost\:5672 established successfully' .
				'\[DEBUG\] RabbitMQ message published \{"messagePublished"\:"Hello!","routingKey"\:"tasks-for-testDebuggingLogsEnabled","connectionDescription"\:"localhost\:(\d+)->localhost\:5672"\}' .
				'\[INFO\] AMQP connection localhost\:(\d+)->localhost\:5672 closed due to Normal shutdown' }
]

{ #category : 'tests' }
RabbitMQClientTest >> testDebuggingLogsEnabledInWorker [

  | queueName messagesToSend |
  queueName := self queueName.
  messagesToSend := 'Do it!'.

  self assertQueueStatusAfterPublishing: messagesToSend on: queueName.

  self
    runMemoryLoggerDuring: [ self assertQueueStatusAfterConsuming: messagesToSend from: queueName ]
    assertingLogRecordsMatchRegexes:
      { '\[INFO\] AMQP connection localhost\:(\d+)->localhost\:5672 established successfully' .
        '\[DEBUG\] RabbitMQ message consumed \{"deliveryTag"\:1,"messageConsumed"\:"Do it!","routingKey"\:"tasks-for-testDebuggingLogsEnabledInWorker","connectionDescription"\:"localhost\:(\d+)->localhost\:5672"\}' .
        '\[INFO\] AMQP connection localhost\:(\d+)->localhost\:5672 closed due to Normal shutdown' }
]

{ #category : 'tests' }
RabbitMQClientTest >> testDebuggingLogsTurnedOff [

	| anotherPublisher |

	anotherPublisher := self defaultRabbitMQPublisher.

	self
		runMemoryLoggerDuring: [
				anotherPublisher start.
				anotherPublisher publish: 'Hello!' to: self queueName.
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
RabbitMQClientTest >> testPublishingMessageWhenClientUnexpectedlyClosesConnection [

  self resumeWorkerDuring: [
      publisher
        publish: 'Hello' to: self queueName;
        publish: 'World' to: self queueName.

      self wait.

      self
        assert: reversedTexts size equals: 2;
        assert: reversedTexts first equals: 'olleH';
        assert: reversedTexts last equals: 'dlroW'.

      self
        runMemoryLoggerDuring: [
            self
              closeAllConnectionsFromTheClientSide;
              waitUntilAllRabbitMQConnectionsClose.
            publisher publish: 'Test connection restored' to: self queueName
          ]
        assertingLogRecordsMatchRegexes:
          { '\[INFO\] AMQP connection localhost\:(\d+)->localhost\:5672 closed due to (Connection close while waiting for data.|primitive #primSocketSendDone\: in Socket failed|primitive #primSocketReceiveDataAvailable\: in Socket failed)' .
            '\[INFO\] AMQP connection localhost\:(\d+)->localhost\:5672 established successfully' .
            '\[ERROR\] AMQP Heartbeat failed unexpectedly \((connection closed while sending data|Socket destroyed, cannot retrieve error message|primitive #primSocketSendDone\: in Socket failed)\).' .
            '\[INFO\] AMQP connection localhost\:(\d+)->localhost\:5672 closed due to (connection closed while sending data|Socket destroyed, cannot retrieve error message|primitive #primSocketSendDone\: in Socket failed)' .
            '\[INFO\] AMQP connection localhost\:(\d+)->localhost\:5672 established successfully' }
    ].

  self
    assert: reversedTexts size equals: 3;
    assert: reversedTexts last equals: 'derotser noitcennoc tseT'
]

{ #category : 'tests' }
RabbitMQClientTest >> testPublishingMessageWhenConnectionIsTemporallyLost [

  self resumeWorkerDuring: [
      publisher
        publish: 'Hello' to: self queueName;
        publish: 'World' to: self queueName.

      self wait.

      self
        assert: reversedTexts size equals: 2;
        assert: reversedTexts first equals: 'olleH';
        assert: reversedTexts last equals: 'dlroW'.

      self
        runMemoryLoggerDuring: [
            self
              closeAllConnectionsFromTheBrokerSide;
              waitUntilAllRabbitMQConnectionsClose.
            publisher publish: 'Test connection restored' to: self queueName
          ]
        assertingLogRecordsMatchRegexes:
          { '\[INFO\] AMQP connection localhost\:(\d+)->localhost\:5672 closed due to CONNECTION_FORCED - CloseConnectionsTest' .
            '\[INFO\] AMQP connection localhost\:(\d+)->localhost\:5672 established successfully' .
            '\[INFO\] AMQP connection localhost\:(\d+)->localhost\:5672 closed due to (connection closed while sending data|send data timeout; data not sent)' .
			'\[ERROR\] Attempt #1\/3 to connect to RabbitMQ failed\: (connection closed while sending data|send data timeout; data not sent)' .
            '\[INFO\] AMQP connection localhost\:(\d+)->localhost\:5672 established successfully' }
    ].


  self
    assert: reversedTexts size equals: 3;
    assert: reversedTexts last equals: 'derotser noitcennoc tseT'
]

{ #category : 'tests' }
RabbitMQClientTest >> testPublishingMessages [

	self resumeWorkerDuring: [ publisher publishAll: #( 'Hello' 'World' ) to: self queueName ].

	self
		assert: reversedTexts size equals: 2;
		assert: reversedTexts first equals: 'olleH';
		assert: reversedTexts second equals: 'dlroW'
]

{ #category : 'tests' }
RabbitMQClientTest >> testPublishingToDefaultExchange [

	self resumeWorkerDuring: [ publisher publish: 'Hello' to: self queueName ].

	self
		withTheOnlyOneIn: reversedTexts
		do: [ :reversedText | self assert: reversedText equals: 'olleH' ]
]

{ #category : 'tests' }
RabbitMQClientTest >> testPublishingToDirectExchangeWithTwoQueuesBindedWithDifferentRoutingKey [

  |  firstWorkerMessages secondWorkerMessages |

  firstWorkerMessages := OrderedCollection new.
  secondWorkerMessages := OrderedCollection new.

  self
    runWorkerNamed: 'Reverser'
    consumingFrom: 'reverser-queue'
    bindedTo: 'amq.direct'
    routedBy: 'the-reverse-key'
    doing: [ :message | firstWorkerMessages add: message utf8Decoded reversed ]
    during: [
        self
          runWorkerNamed: 'Appender'
          consumingFrom: 'appender-queue'
          bindedTo: 'amq.direct'
          routedBy: 'the-appender-key'
          doing: [ :message | secondWorkerMessages add: message utf8Decoded ]
          during: [ publisher publish: 'Hello' to: 'the-reverse-key' through: 'amq.direct' ]
      ].

  self
    withTheOnlyOneIn: firstWorkerMessages do: [ :text | self assert: text equals: 'olleH' ]; 
	 assert: secondWorkerMessages isEmpty
]

{ #category : 'tests' }
RabbitMQClientTest >> testPublishingToDirectExchangeWithTwoQueuesBindedWithSameRoutingKey [

  | route firstWorkerMessages secondWorkerMessages |
  route := self queueName.
  firstWorkerMessages := OrderedCollection new.
  secondWorkerMessages := OrderedCollection new.

  self
    runWorkerNamed: 'Reverser'
    consumingFrom: 'reverser-queue'
    bindedTo: 'amq.direct'
    routedBy: route
    doing: [ :message | firstWorkerMessages add: message utf8Decoded reversed ]
    during: [
        self
          runWorkerNamed: 'Appender'
          consumingFrom: 'appender-queue'
          bindedTo: 'amq.direct'
          routedBy: route
          doing: [ :message | secondWorkerMessages add: message utf8Decoded ]
          during: [ publisher publish: 'Hello' to: route through: 'amq.direct' ]
      ].

  self
    withTheOnlyOneIn: firstWorkerMessages do: [ :text | self assert: text equals: 'olleH' ];
    withTheOnlyOneIn: secondWorkerMessages do: [ :text | self assert: text equals: 'Hello' ]
]

{ #category : 'tests' }
RabbitMQClientTest >> testPublishingToFanoutExchange [

  | firstWorkerMessages secondWorkerMessages |

  firstWorkerMessages := OrderedCollection new.
  secondWorkerMessages := OrderedCollection new.

  self
    runWorkerNamed: 'Reverser'
    consumingFrom: 'reverser-queue'
    bindedTo: 'amq.fanout'
    routedBy: ('queue-<1p>' expandMacrosWith: Random new next)
    doing: [ :message | firstWorkerMessages add: message utf8Decoded reversed ]
    during: [
        self
          runWorkerNamed: 'Appender'
          consumingFrom: 'appender-queue'
          bindedTo: 'amq.fanout'
          routedBy: ('queue-<1p>' expandMacrosWith: Random new next)
          doing: [ :message | secondWorkerMessages add: message utf8Decoded ]
          during: [ publisher broadcast: 'Hello' toAllQueuesBindedTo: 'amq.fanout' ]
      ].

  self
    withTheOnlyOneIn: firstWorkerMessages do: [ :text | self assert: text equals: 'olleH' ];
    withTheOnlyOneIn: secondWorkerMessages do: [ :text | self assert: text equals: 'Hello' ]
]

{ #category : 'tests' }
RabbitMQClientTest >> testPublishingToTopicExchange [

  | firstWorkerMessages secondWorkerMessages |

  firstWorkerMessages := OrderedCollection new.
  secondWorkerMessages := OrderedCollection new.

  self
    runWorkerNamed: 'Reverser'
    consumingFrom: 'reverser-queue'
    bindedTo: 'amq.topic'
    routedBy: '*.reverser'
    doing: [ :message | firstWorkerMessages add: message utf8Decoded reversed ]
    during: [
        self
          runWorkerNamed: 'Appender'
          consumingFrom: 'appender-queue'
          bindedTo: 'amq.topic'
          routedBy: 'textprocessing.*'
          doing: [ :message | secondWorkerMessages add: message utf8Decoded ]
          during: [ publisher publish: 'Hello' to: 'textprocessing.reverser' through: 'amq.topic' ]
      ].

  self
    withTheOnlyOneIn: firstWorkerMessages do: [ :text | self assert: text equals: 'olleH' ];
    withTheOnlyOneIn: secondWorkerMessages do: [ :text | self assert: text equals: 'Hello' ]
]

{ #category : 'private - support' }
RabbitMQClientTest >> wait [

	( Delay forMilliseconds: 200 ) wait
]

{ #category : 'private - support' }
RabbitMQClientTest >> waitUntilAllRabbitMQConnectionsClose [
	
	"This delay aims to replicate the time required to successfully close all the RabbitMQ connections."

	( Delay forSeconds: 120 ) wait
]
