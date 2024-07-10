"
I'm a publisher connected to a RabbitMQ queue.
I will send messages to the specified queue for further processing.

The main idea behind publishing messages to a queue is to decouple the task of generating
messages from the task of processing them. This allows for more flexibility and scalability
as the producers and consumers can operate independently. 
"
Class {
	#name : 'RabbitMQPublisher',
	#superclass : 'Object',
	#instVars : [
		'options',
		'builder',
		'channel',
		'connection'
	],
	#category : 'Ansible-RabbitMQ',
	#package : 'Ansible-RabbitMQ'
}

{ #category : 'instance creation' }
RabbitMQPublisher class >> configuredBy: aConfigurationAction [

	| options |

	options := Dictionary new.
	aConfigurationAction value: options.
	^ self new initializeConfiguredBy: options
]

{ #category : 'accessing' }
RabbitMQPublisher >> channel [

	^channel
]

{ #category : 'private - accessing' }
RabbitMQPublisher >> connectivityErrors [

	^ AmqpDisconnectedError , NetworkError
]

{ #category : 'private - connecting' }
RabbitMQPublisher >> ensureChannelOpen [

	| reconnect |

	reconnect := [
		self ensureConnectedAndOpen.
		channel := connection createChannel].
	channel ifNil: reconnect ifNotNil: [channel whenOpenDo: [] whenClosedDo: reconnect]
]

{ #category : 'private - connecting' }
RabbitMQPublisher >> ensureConnectedAndOpen [

	| createConnection |

	createConnection := [
		self
			try: [
				connection := builder build.
				connection open]
			onConnectivityErrorDo: [:attemptNumber :error |
				self logFailedConnectionAttempt: attemptNumber dueTo: error]].

	connection
		ifNil: createConnection
		ifNotNil: [connection whenConnected: [] whenNot: createConnection].
		
	connection
		whenOpen: []
		whenNot: [connection closeReason ifNil: [connection open] ifNotNil: createConnection]
]

{ #category : 'initialization' }
RabbitMQPublisher >> initializeConfiguredBy: anOptionsDictionary [

	options := anOptionsDictionary.
	builder := AmqpConnectionBuilder usingAMQP091Protocol.
	builder hostname: (options at: #hostname).
	builder portNumber: (options at: #port ifAbsent: [5672]).
	builder username: (options at: #username ifAbsent: ['guest']).
	builder password: (options at: #password ifAbsent: ['guest'])
]

{ #category : 'private - logging' }
RabbitMQPublisher >> logFailedConnectionAttempt: anAttemptNumber dueTo: anError [

	LogRecord emitError: ( 'Attempt #<1p>/<2p> to connect to RabbitMQ failed: <3s>'
			  expandMacrosWith: anAttemptNumber
			  with: self retryCount
			  with: anError messageText )
]

{ #category : 'publishing' }
RabbitMQPublisher >> publish: aMessageCollection onQueueNamed: aQueueName [

	aMessageCollection do: [:message | self publishOnly: message onQueueNamed: aQueueName]
]

{ #category : 'publishing' }
RabbitMQPublisher >> publishOnly: aMessage onQueueNamed: aQueueName [

	self ensureChannelOpen.

	self shouldLogDebuggingInfo then: [
		LogRecord
			emitStructuredDebuggingInfo: 'RabbitMQ message published'
			with: [:data |
				data
					at: #messagePublished put: aMessage;
					at: #routingKey put: aQueueName;
					at: #connectionDescription put: connection connectionPairsDescription]].

	channel
		basicPublish: aMessage utf8Encoded
		exchange: ''
		routingKey: aQueueName
		properties: (connection protocolClass basicPropertiesClass new deliveryMode: 2)
]

{ #category : 'private - accessing' }
RabbitMQPublisher >> retryCount [

	^options at: #maximumConnectionAttemps ifAbsent: [3]
]

{ #category : 'private - testing' }
RabbitMQPublisher >> shouldLogDebuggingInfo [

	^options at: #enableDebuggingLogs ifAbsent: [false]
]

{ #category : 'connecting' }
RabbitMQPublisher >> start [

	self ensureChannelOpen
]

{ #category : 'connecting' }
RabbitMQPublisher >> stop [

	connection
		ifNil: []
		ifNotNil: [
			connection
				whenConnected: [connection close]
				whenNot: [LogRecord emitWarning: 'RabbitMQ connection was already closed.']]
]

{ #category : 'private - accessing' }
RabbitMQPublisher >> timeframeBetweenAttempts [

	^Duration milliSeconds: (options at: #timeSlotBetweenConnectionRetriesInMs ifAbsent: [300])
]

{ #category : 'private - connecting' }
RabbitMQPublisher >> try: aBlock onConnectivityErrorDo: failBlock [

	Retry
		value: aBlock
		configuredBy: [:retry |
			retry
				upTo: self retryCount;
				backoffExponentiallyWithTimeSlot: self timeframeBetweenAttempts;
				on: self connectivityErrors evaluating: failBlock]
]
