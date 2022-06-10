"
I'm a RabbitMQ Client.

I know how to connect to Rabbit MQ.
My subclasses will act as different roles depending on the system needs.
"
Class {
	#name : #RabbitMQClient,
	#superclass : #Object,
	#instVars : [
		'connection'
	],
	#category : #'Ansible-RabbitMQ'
}

{ #category : #testing }
RabbitMQClient class >> isAbstract [

	<ignoreForCoverage>
	^ self = RabbitMQClient
]

{ #category : #'private - configuring' }
RabbitMQClient >> configureConnection: builder [

	self subclassResponsibility
]

{ #category : #'private - configuring' }
RabbitMQClient >> connectivityErrors [

	^ NetworkError
]

{ #category : #initialization }
RabbitMQClient >> initializeConnection [

	| builder |

	builder := AmqpConnectionBuilder usingAMQP091Protocol.
	self configureConnection: builder.
	connection := builder build
]

{ #category : #'private - connecting' }
RabbitMQClient >> logFailedConnectionAttempt: attemptNumber dueTo: error [

	LaunchpadLogRecord emitError: ( 'Attempt #<1p>/<2p> to connect to RabbitMQ failed: <3s>'
			  expandMacrosWith: attemptNumber
			  with: self retryCount + 1
			  with: error messageText )
]

{ #category : #'private - connecting' }
RabbitMQClient >> openConnection [

	self withSuccessfulConnectionDo: [ :succesfulConnection | 
		LaunchpadLogRecord emitInfo: 'Connecting to RabbitMQ' during: [ 
			self
				try: [ succesfulConnection open ]
				onConnectivityErrorDo: [ :attemptNumber :error | 
				self logFailedConnectionAttempt: attemptNumber dueTo: error ]
			]
		]
]

{ #category : #'private - configuring' }
RabbitMQClient >> options [

	^ Dictionary new
]

{ #category : #'private - configuring' }
RabbitMQClient >> retryCount [

	^ self options at: #retryCount ifAbsent: [ 2 ]
]

{ #category : #controlling }
RabbitMQClient >> start [

	self openConnection.
	connection
		whenConnected: [ 
			LaunchpadLogRecord emitInfo: 'Connected to RabbitMQ'.
			self startProcessing
			]
		whenNot: [ :error | 
			LaunchpadLogRecord emitError:
				( 'Cannot connect to RabbitMQ, <1s>' expandMacrosWith: error messageText ).
			AmqpDisconnectedError signal: error messageText
			]
]

{ #category : #private }
RabbitMQClient >> startProcessing [

	self subclassResponsibility
]

{ #category : #controlling }
RabbitMQClient >> stop [

	connection
		whenConnected: [ connection close ]
		whenNot: [ LaunchpadLogRecord emitWarning: 'RabbitMQ connection was already closed.' ]
]

{ #category : #'private - connecting' }
RabbitMQClient >> try: aBlock onConnectivityErrorDo: failBlock [

	Retry value: aBlock configuredBy: [ :retry | 
		retry
			upTo: self retryCount;
			on: self connectivityErrors evaluating: failBlock.
		self options at: #retry ifPresent: [ :action | action value: retry ]
		]
]

{ #category : #'private - connecting' }
RabbitMQClient >> withSuccessfulConnectionDo: aBlock [

	self
		try: [ connection whenConnected: [ aBlock value: connection ] whenNot: [ :error | error signal ] ]
		onConnectivityErrorDo: [ :attemptNumber :error | 
			self logFailedConnectionAttempt: attemptNumber dueTo: error.
			LaunchpadLogRecord emitWarning: 'Reconnecting socket to RabbitMQ'.
			connection initializeSocketConnection
			]
]
