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

  channel declareQueueApplying: [ :builder |
      builder name: self queueName.
      self makeQueueDurable then: [ builder beDurable ]
    ]
]

{ #category : 'private' }
RabbitMQWorker >> initializeConfiguredBy: anOptionsDictionary processingMessagesWith: aMessageProcessor [

  super initialize.
  options := anOptionsDictionary.
  messageProcessor := aMessageProcessor
]

{ #category : 'private - logging' }
RabbitMQWorker >> logDebuggingInfoFor: aMessage [

  self shouldLogDebuggingInfo then: [
      LogRecord emitStructuredDebuggingInfo: 'RabbitMQ message consumed' with: [ :data |
          data
            at: #deliveryTag put: aMessage method deliveryTag;
            at: #messageConsumed put: aMessage body utf8Decoded;
            at: #routingKey put: self queueName;
            at: #connectionDescription put: connection connectionPairsDescription
        ]
    ]
]

{ #category : 'private' }
RabbitMQWorker >> makeQueueDurable [

  ^ options at: #queueDurable ifAbsent: [ true ]
]

{ #category : 'accessing' }
RabbitMQWorker >> queueName [

	^ options at: #queueName
]

{ #category : 'private' }
RabbitMQWorker >> restartConsumingFromQueue [

  self
    ensureChannelOpen;
    setUpChannelConsumingCallback
]

{ #category : 'private' }
RabbitMQWorker >> setUpChannelConsumingCallback [

  channel prefetchCount: 1.
  channel consumeFrom: self queueName applying: [ :message |
      self logDebuggingInfoFor: message.
      messageProcessor value: message.
      channel basicAck: message method deliveryTag
    ]
]

{ #category : 'controlling' }
RabbitMQWorker >> start [

  super start.
  self startProcessing
]

{ #category : 'private' }
RabbitMQWorker >> startConsumingFromQueue [

  self
    ensureChannelOpen;
    declareQueueInChannel;
    setUpChannelConsumingCallback
]

{ #category : 'private' }
RabbitMQWorker >> startProcessing [

  self startConsumingFromQueue.

  [
    [ connection waitForEvent ]
      on: self connectivityErrors
      do: [ :error |
          connection hardCloseDescribedWith: error messageText.
          self restartConsumingFromQueue.
          error return
        ]
  ] repeat
]
