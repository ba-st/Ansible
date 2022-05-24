"
A RabbitMQTextReverserTest is a test class for testing the behavior of RabbitMQTextReverser
"
Class {
	#name : #RabbitMQTextReverserTest,
	#superclass : #TestCase,
	#instVars : [
		'reversedTexts',
		'workerProcess'
	],
	#category : #'Ansible-RabbitMQ-Tests'
}

{ #category : #private }
RabbitMQTextReverserTest >> publish: text onQueueNamed: aQueueName [

	self withLocalhostConnectionDo: [ :connection | 
		| channel |

		channel := connection createChannel.
		channel queueDeclare: aQueueName durable: true.
		channel
			basicPublish: text utf8Encoded
			exchange: ''
			routingKey: aQueueName
			properties: ( connection protocolClass basicPropertiesClass new deliveryMode: 2 )
		]
]

{ #category : #accessing }
RabbitMQTextReverserTest >> queueName [

	^ 'tasks-for-' , testSelector
]

{ #category : #running }
RabbitMQTextReverserTest >> setUp [

	super setUp.
	reversedTexts := OrderedCollection new.
	workerProcess := [ ( RabbitMQTextReverser workingWith: self ) start ] newProcess.
	workerProcess
		name: 'Text reverser worker';
		priority: Processor userBackgroundPriority
]

{ #category : #accessing }
RabbitMQTextReverserTest >> storeText: string [

	reversedTexts add: string
]

{ #category : #running }
RabbitMQTextReverserTest >> tearDown [

	workerProcess terminate.
	super tearDown
]

{ #category : #tests }
RabbitMQTextReverserTest >> testProcessingMessages [

	workerProcess resume.

	Processor yield.
	self wait.

	self
		publish: 'Hello' onQueueNamed: self queueName;
		publish: 'World' onQueueNamed: self queueName.

	self wait.

	self
		assert: reversedTexts size equals: 2;
		assert: reversedTexts first equals: 'olleH';
		assert: reversedTexts last equals: 'dlroW'
]

{ #category : #tests }
RabbitMQTextReverserTest >> testProcessingOneMessage [

	workerProcess resume.

	Processor yield.
	self wait.

	self publish: 'Hello' onQueueNamed: self queueName.

	self wait.
	self withTheOnlyOneIn: reversedTexts do: [ :text | self assert: text equals: 'olleH' ]
]

{ #category : #private }
RabbitMQTextReverserTest >> wait [

	( Delay forMilliseconds: 200 ) wait
]

{ #category : #private }
RabbitMQTextReverserTest >> withLocalhostConnectionDo: block [

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
