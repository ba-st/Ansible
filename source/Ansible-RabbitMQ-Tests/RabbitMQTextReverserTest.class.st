"
A RabbitMQTextReverserTest is a test class for testing the behavior of RabbitMQTextReverser
"
Class {
	#name : 'RabbitMQTextReverserTest',
	#superclass : 'TestCase',
	#instVars : [
		'reversedTexts',
		'workerProcess',
		'worker'
	],
	#category : 'Ansible-RabbitMQ-Tests',
	#package : 'Ansible-RabbitMQ-Tests'
}

{ #category : 'accessing' }
RabbitMQTextReverserTest class >> defaultTimeLimit [

	^ 60 seconds
]

{ #category : 'private' }
RabbitMQTextReverserTest >> publish: aText onQueueNamed: aQueueName [

	self withLocalhostConnectionDo: [ :connection |
		| channel |

		channel := connection createChannel.
		channel queueDeclare: aQueueName durable: true.
		channel
			basicPublish: aText utf8Encoded
			exchange: ''
			routingKey: aQueueName
			properties: ( connection protocolClass basicPropertiesClass new deliveryMode: 2 )
		]
]

{ #category : 'accessing' }
RabbitMQTextReverserTest >> queueName [

	^ 'tasks-for-' , testSelector
]

{ #category : 'private' }
RabbitMQTextReverserTest >> resumeWorkerDuring: aBlock [

	workerProcess resume.
	Processor yield.
	self wait.
	aBlock value.
	self wait
]

{ #category : 'running' }
RabbitMQTextReverserTest >> setUp [

	super setUp.
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
RabbitMQTextReverserTest >> testProcessingMessageWhenChannelIsTemporallyLost [

	| logger |

	logger := MemoryLogger new.

	self resumeWorkerDuring: [ "self
			publish: 'Hello' onQueueNamed: self queueName;
			publish: 'World' onQueueNamed: self queueName.

		self wait.

		self
			assert: reversedTexts size equals: 2;
			assert: reversedTexts first equals: 'olleH';
			assert: reversedTexts last equals: 'dlroW'."
		logger runDuring: [ worker stop].

		self publish: 'Test channel restored' onQueueNamed: self queueName
		].

	self
		assert: reversedTexts size equals: 3;
		assert: reversedTexts last equals: 'derotser lennahc tseT'
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

{ #category : 'private' }
RabbitMQTextReverserTest >> withLocalhostConnectionDo: aBlock [

	| connection |

	connection := AmqpConnectionBuilder usingAMQP091Protocol build.

	connection open.

	connection
		whenConnected: [
			aBlock value: connection.
			connection close
			]
		whenNot: [ :error | self fail: error messageText ]
]
