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
	#name : 'RabbitMQWorker',
	#superclass : 'RabbitMQClient',
	#instVars : [
		'channel'
	],
	#category : 'Ansible-RabbitMQ',
	#package : 'Ansible-RabbitMQ'
}

{ #category : 'testing' }
RabbitMQWorker class >> isAbstract [

	<ignoreForCoverage>
	^ self = RabbitMQWorker
]

{ #category : 'private' }
RabbitMQWorker >> configureChannel [

	channel queueDeclare: self queueName durable: true.
	channel prefetchCount: 1.
	channel consumeFrom: self queueName applying: [ :message |
		self process: message body.
		channel basicAck: message method deliveryTag
		]
]

{ #category : 'private' }
RabbitMQWorker >> ensureChannelOpen [

	| reconnect |

	reconnect := [
	             self ensureConnectedAndOpen.
	             LogRecord emitInfo: 'Pase el ensureConnected para crear el channel'.
	             channel := connection createChannel
	             ].


	channel ifNil: reconnect ifNotNil: [
		LogRecord emitInfo: channel printString.
		channel whenOpenDo: [  ] whenClosedDo: reconnect
		].

	self configureChannel
]

{ #category : 'private' }
RabbitMQWorker >> logDisconnectionDueTo: anError [

	LaunchpadLogRecord emitError:
		( 'RabbitMQClient disconnected: <1s>' expandMacrosWith: anError messageText )
]

{ #category : 'private' }
RabbitMQWorker >> process: payload [

	"A message was received including the bytes in `payload`"

	self subclassResponsibility
]

{ #category : 'accessing' }
RabbitMQWorker >> queueName [

	^ self subclassResponsibility
]

{ #category : 'private' }
RabbitMQWorker >> startProcessing [

	self ensureChannelOpen.

	[[ connection waitForEvent ]
		on: AmqpDisconnectedError,ConnectionClosed 
		do: [ :error |
			self
				logDisconnectionDueTo: error;
				ensureChannelOpen]] repeat
]
