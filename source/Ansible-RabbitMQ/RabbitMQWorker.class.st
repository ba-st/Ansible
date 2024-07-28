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
	#category : 'Ansible-RabbitMQ',
	#package : 'Ansible-RabbitMQ'
}

{ #category : 'testing' }
RabbitMQWorker class >> isAbstract [

	<ignoreForCoverage>
	^ self = RabbitMQWorker
]

{ #category : 'private' }
RabbitMQWorker >> declareQueueInChannel [

  channel queueDeclare: self queueName durable: true
]

{ #category : 'private' }
RabbitMQWorker >> ensureChannelOpen [

  super ensureChannelOpen.
  self declareQueueInChannel
]

{ #category : 'private' }
RabbitMQWorker >> logDisconnectionDueTo: anError [

	LogRecord emitError:
		( 'RabbitMQClient disconnected due to <1s>' expandMacrosWith: anError messageText )
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

{ #category : 'controlling' }
RabbitMQWorker >> start [

  super start.
  self startProcessing
]

{ #category : 'private' }
RabbitMQWorker >> startConsumingFromQueue [

  self ensureChannelOpen.

  channel prefetchCount: 1.
  channel consumeFrom: self queueName applying: [ :message |
      self process: message body.
      channel basicAck: message method deliveryTag
    ]
]

{ #category : 'private' }
RabbitMQWorker >> startProcessing [

  self startConsumingFromQueue.

  [
    [ connection waitForEvent ]
      on: self connectivityErrors
      do: [ :error |
          self
            logDisconnectionDueTo: error;
            startConsumingFromQueue
        ]
  ] repeat
]
