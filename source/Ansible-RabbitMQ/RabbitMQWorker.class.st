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
		'messageProcessor'
	],
	#category : 'Ansible-RabbitMQ',
	#package : 'Ansible-RabbitMQ'
}

{ #category : 'testing' }
RabbitMQWorker class >> configuredBy: aConfigurationAction processingMessagesWith: aMessageProcessor [

  | options |
  options := Dictionary new.
  aConfigurationAction cull: options.
  options
    at: #queueName
    ifAbsent: [ InstanceCreationFailed signal: 'Missing name of the queue to consume from' ].
  ^ self new initializeConfiguredBy: options processingMessagesWith: aMessageProcessor
]

{ #category : 'testing' }
RabbitMQWorker class >> configuredBy: aConfigurationAction processingPayloadWith: aPayloadProcessor [

  ^ self
      configuredBy: aConfigurationAction
      processingMessagesWith: [ :message | aPayloadProcessor value: message body ]
]

{ #category : 'private' }
RabbitMQWorker >> declareQueueInChannel [

  channel queueDeclare: self queueName durable: ( options at: #queueDurable ifAbsent: [ true ] )
]

{ #category : 'private' }
RabbitMQWorker >> ensureChannelOpen [

  super ensureChannelOpen.
  self declareQueueInChannel
]

{ #category : 'private' }
RabbitMQWorker >> initializeConfiguredBy: anOptionsDictionary processingMessagesWith: aMessageProcessor [

  super initialize.
  options := anOptionsDictionary.
  messageProcessor := aMessageProcessor
]

{ #category : 'private' }
RabbitMQWorker >> logDisconnectionDueTo: anError [

	LogRecord emitError:
		( 'RabbitMQClient disconnected due to <1s>' expandMacrosWith: anError messageText )
]

{ #category : 'accessing' }
RabbitMQWorker >> queueName [

	^ options at: #queueName
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
      messageProcessor value: message.
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
