"
I'm a worker connected to a Rabbit MQ queue.
I will wait for messages on the queue and upon reception act on them.

The main idea behind Work Queues (aka: Task Queues) is to avoid doing a resource-intensive task
immediately and having to wait for it to complete. Instead we schedule the task to be done later.
We encapsulate a task as a message and send it to a queue. A worker process running in the
background will pop the tasks and eventually execute the job. When you run many workers the tasks
will be shared between them.

This concept is especially useful in web applications where it's impossible to handle a complex
task during a short HTTP request window.
"
Class {
	#name : #RabbitMQWorker,
	#superclass : #Object,
	#instVars : [
		'connection'
	],
	#category : #'Ansible-RabbitMQ'
}

{ #category : #testing }
RabbitMQWorker class >> isAbstract [

	<ignoreForCoverage>
	^ self = RabbitMQWorker
]

{ #category : #private }
RabbitMQWorker >> configureConnection: builder [

	self subclassResponsibility
]

{ #category : #initialization }
RabbitMQWorker >> initializeConnection [

	| builder |

	builder := AmqpConnectionBuilder usingAMQP091Protocol.
	self configureConnection: builder.
	connection := builder build
]

{ #category : #private }
RabbitMQWorker >> openConnection [

	LaunchpadLogRecord emitInfo: 'Connecting to RabbitMQ' during: [ connection open ]
]

{ #category : #private }
RabbitMQWorker >> process: payload [

	"A message was received including the bytes in `payload`"

	self subclassResponsibility
]

{ #category : #accessing }
RabbitMQWorker >> queueName [

	^ self subclassResponsibility
]

{ #category : #controlling }
RabbitMQWorker >> start [

	self openConnection.
	connection
		whenConnected: [ 
			LaunchpadLogRecord emitInfo: 'Connected to RabbitMQ'.
			self startReceivingMessages
			]
		whenNot: [ :error | 
			LaunchpadLogRecord emitError:
				( 'Cannot connect to RabbitMQ, <1s>' expandMacrosWith: error messageText ).
			AmqpDisconnectedError signal: error messageText
			]
]

{ #category : #private }
RabbitMQWorker >> startReceivingMessages [

	| channel |

	channel := connection createChannel.
	channel queueDeclare: self queueName durable: true.
	channel prefetchCount: 1.
	channel consumeFrom: self queueName applying: [ :message | 
		self process: message body.
		channel basicAck: message method deliveryTag
		].
	[ connection waitForEvent ] repeat
]

{ #category : #controlling }
RabbitMQWorker >> stop [

	connection
		whenConnected: [ connection close ]
		whenNot: [ LaunchpadLogRecord emitWarning: 'RabbitMQ connection was already closed.' ]
]
