"
A RabbitMQTextReverserTest is a test class for testing the behavior of RabbitMQTextReverser
"
Class {
	#name : 'RabbitMQTextReverserTest',
	#superclass : 'TestCase',
	#instVars : [
		'reversedTexts',
		'workerProcess',
		'worker',
		'loggingAsserter'
	],
	#category : 'Ansible-RabbitMQ-Tests',
	#package : 'Ansible-RabbitMQ-Tests'
}

{ #category : 'adding' }
RabbitMQTextReverserTest >> addTimestampRegexTo: aLogEntryCollection [ 

  ^ aLogEntryCollection collect: [ :regexExpression |
        '\d{4}-\d{2}-\d{2}T\d{2}\:\d{2}\:\d{2}(\.\d+)?(\+|-)(\d+\:\d+) <1s>' expandMacrosWith:
          regexExpression
      ]
]

{ #category : 'private' }
RabbitMQTextReverserTest >> closeAllConnectionsOf: aRabbitmqContainerId for: aUsername because: aCloseReason [

	^ OSPlatform current runCommand:
		  ( 'docker exec <1s> rabbitmqctl close_all_user_connections <2s> <3s>'
			    expandMacrosWith: aRabbitmqContainerId
			    with: aUsername
			    with: aCloseReason )
]

{ #category : 'private' }
RabbitMQTextReverserTest >> closeAllUserConnections [

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

{ #category : 'private' }
RabbitMQTextReverserTest >> defaultRabbitMQWorkerUsername [

	^ AmqpConnectionBuilder usingAMQP091Protocol credentials username
]

{ #category : 'private' }
RabbitMQTextReverserTest >> publish: aText onQueueNamed: aQueueName [

  | publisher |
  publisher := RabbitMQPublisher configuredBy: [  ].

  publisher publishOnly: aText onQueueNamed: aQueueName
]

{ #category : 'accessing' }
RabbitMQTextReverserTest >> queueName [

	^ 'tasks-for-' , testSelector
]

{ #category : 'private' }
RabbitMQTextReverserTest >> rabbitMQContainerID [

	^ ( OSPlatform current resultOfCommand: 'docker ps -q --filter "name=rabbitmq"' ) trim
]

{ #category : 'private' }
RabbitMQTextReverserTest >> resumeWorkerDuring: aBlock [

	workerProcess resume.
	Processor yield.
	self wait.
	aBlock value.
	self wait
]

{ #category : 'private - support' }
RabbitMQTextReverserTest >> runMemoryLoggerDuring: aBlock assertingLogRecordsMatchRegexes: expectedLogEntries [ 

  | expectedLogEntriesWithTimestamp |

  expectedLogEntriesWithTimestamp := self addTimestampRegexTo: expectedLogEntries.

  loggingAsserter
    runMemoryLoggerDuring: aBlock;
    assertLogRecordsMatchUsing: expectedLogEntriesWithTimestamp
]

{ #category : 'running' }
RabbitMQTextReverserTest >> setUp [

	super setUp.
	
	loggingAsserter := LoggingAsserter on: self.
	
	reversedTexts := OrderedCollection new.

	worker := RabbitMQTextReverser workingWith: self.

	workerProcess := [ [ worker start ] ensure: [ worker stop ] ] newProcess.
	workerProcess
		name: 'Text reverser worker';
		priority: Processor userBackgroundPriority
]

{ #category : 'accessing' }
RabbitMQTextReverserTest >> storeText: aString [

	reversedTexts add: aString
]

{ #category : 'running' }
RabbitMQTextReverserTest >> tearDown [

	workerProcess terminate.
	super tearDown
]

{ #category : 'tests' }
RabbitMQTextReverserTest >> testProcessingMessageWhenConnectionIsTemporallyLost [

  self resumeWorkerDuring: [
      self
        publish: 'Hello' onQueueNamed: self queueName;
        publish: 'World' onQueueNamed: self queueName.

      self wait.

      self
        assert: reversedTexts size equals: 2;
        assert: reversedTexts first equals: 'olleH';
        assert: reversedTexts last equals: 'dlroW'.

      self
        runMemoryLoggerDuring: [
            self
              closeAllUserConnections;
              wait
          ]
        assertingLogRecordsMatchRegexes:
          { '\[ERROR\] RabbitMQClient disconnected due to Connection closed' .
            '\[INFO\] AMQP connection localhost\:(\d+)->localhost\:5672 established successfully' }.

      self publish: 'Test connection restored' onQueueNamed: self queueName
    ].


  self
    assert: reversedTexts size equals: 3;
    assert: reversedTexts last equals: 'derotser noitcennoc tseT'
]

{ #category : 'tests' }
RabbitMQTextReverserTest >> testProcessingMessages [

	self resumeWorkerDuring: [
		self
			publish: 'Hello' onQueueNamed: self queueName;
			publish: 'World' onQueueNamed: self queueName
		].

	self
		assert: reversedTexts size equals: 2;
		assert: reversedTexts first equals: 'olleH';
		assert: reversedTexts last equals: 'dlroW'
]

{ #category : 'tests' }
RabbitMQTextReverserTest >> testProcessingOneMessage [

	self resumeWorkerDuring: [ self publish: 'Hello' onQueueNamed: self queueName ].

	self withTheOnlyOneIn: reversedTexts do: [ :text | self assert: text equals: 'olleH' ]
]

{ #category : 'private' }
RabbitMQTextReverserTest >> wait [

	( Delay forMilliseconds: 200 ) wait
]
