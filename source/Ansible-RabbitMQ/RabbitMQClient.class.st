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

{ #category : #private }
RabbitMQClient >> configureConnection: builder [

	self subclassResponsibility
]

{ #category : #initialization }
RabbitMQClient >> initializeConnection [

	| builder |

	builder := AmqpConnectionBuilder usingAMQP091Protocol.
	self configureConnection: builder.
	connection := builder build
]

{ #category : #private }
RabbitMQClient >> openConnection [

	connection
		whenConnected: [ 
		LaunchpadLogRecord emitInfo: 'Connecting to RabbitMQ' during: [ connection open ] ]
		whenNot: [ :error | error signal ]
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
