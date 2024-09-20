"
I'm a publisher connected to a RabbitMQ queue.
I will send messages to the specified queue for further processing.

The main idea behind publishing messages to a queue is to decouple the task of generating
messages from the task of processing them. This allows for more flexibility and scalability
as the producers and consumers can operate independently. 
"
Class {
	#name : 'RabbitMQPublisher',
	#superclass : 'RabbitMQClient',
	#instVars : [
		'channelConfigurationCommands'
	],
	#category : 'Ansible-RabbitMQ',
	#package : 'Ansible-RabbitMQ'
}

{ #category : 'instance creation' }
RabbitMQPublisher class >> configuredBy: aConfigurationAction [

	| options |

	options := Dictionary new.
	aConfigurationAction cull: options.
	^ self new initializeConfiguredBy: options
]

{ #category : 'publish - exchange fanout' }
RabbitMQPublisher >> broadcast: aMessage toAllQueuesBindedTo: aFanoutExchange [
	
	" Ref: https://www.rabbitmq.com/tutorials/amqp-concepts#exchange-topic.  
	A fanout exchange routes messages to all of the queues that are bound to it and the routing key is ignored. "
	self publish: aMessage to: '' through: aFanoutExchange
]

{ #category : 'private - accessing' }
RabbitMQPublisher >> directExchange [
	
	"Ref: https://www.rabbitmq.com/tutorials/amqp-concepts#exchange-default 
	The default exchange is a direct exchange with no name (empty string) pre-declared by the broker. 
	It has one special property that makes it very useful for simple applications: 
	every queue that is created is automatically bound to it with a routing key which is the same as the queue name. "
	
  ^ ''
]

{ #category : 'initialization' }
RabbitMQPublisher >> ensureChannelOpen [

  super ensureChannelOpen.
  channelConfigurationCommands do: [ :command | command value: channel ]
]

{ #category : 'initialization' }
RabbitMQPublisher >> initializeConfiguredBy: anOptionsDictionary [

  super initialize.
  options := anOptionsDictionary.
  channelConfigurationCommands := OrderedCollection new
]

{ #category : 'private - logging' }
RabbitMQPublisher >> logDebuggingInfoFor: aMessage publishedTo: anExchange using: aRoutingKey [

  self shouldLogDebuggingInfo then: [
      LogRecord emitStructuredDebuggingInfo: 'RabbitMQ message published' with: [ :data |
          data at: #messagePublished put: aMessage.
          anExchange = self directExchange ifFalse: [ data at: #exchange put: anExchange ].
          data
            at: #routingKey put: aRoutingKey;
            at: #connectionDescription put: connection connectionPairsDescription
        ]
    ]
]

{ #category : 'configuring' }
RabbitMQPublisher >> onPublicationConfirmationDo: anAckBlock onRejectionDo: aNackBlock [

  channelConfigurationCommands add: [ :theChannel |
      theChannel onPublicationConfirmationDo: anAckBlock onRejectionDo: aNackBlock ]
]

{ #category : 'publish - exchange default' }
RabbitMQPublisher >> publish: aMessage to: aQueueName [

  self publish: aMessage to: aQueueName through: self directExchange
]

{ #category : 'publish - exchange topic/direct' }
RabbitMQPublisher >> publish: aMessage to: aRoutingKey through: anExchangeName [

  self
    publish: aMessage
    to: aRoutingKey
    through: anExchangeName
    configuredWith: [ :properties | properties bePersistent ]
]

{ #category : 'publish - exchange topic/direct' }
RabbitMQPublisher >> publish: aMessage to: aRoutingKey through: anExchangeName configuredWith: aConfigurationBlock [

  | properties tryToPublishMessage |
  properties := connection protocolClass basicPropertiesClass new.
  aConfigurationBlock value: properties.

  tryToPublishMessage := [
                           self ensureChannelOpen.
                           channel
                             basicPublish: aMessage utf8Encoded
                             exchange: anExchangeName
                             routingKey: aRoutingKey
                             properties: properties.
                           self
                             logDebuggingInfoFor: aMessage
                             publishedTo: anExchangeName
                             using: aRoutingKey
                         ].

  self try: tryToPublishMessage onConnectivityErrorDo: [ :attemptNumber :error |
      connection hardCloseDescribedWith: error messageText.
      self logFailedConnectionAttempt: attemptNumber dueTo: error
    ]
]

{ #category : 'publish - exchange default' }
RabbitMQPublisher >> publishAll: aMessageCollection to: aQueueName [

	aMessageCollection do: [:message | self publish: message to: aQueueName]
]

{ #category : 'connecting' }
RabbitMQPublisher >> start [

	self ensureChannelOpen
]
