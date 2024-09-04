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

{ #category : 'private - accessing' }
RabbitMQPublisher >> directExchange [

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

{ #category : 'publishing' }
RabbitMQPublisher >> publish: aMessage to: aQueueName [

  self publish: aMessage to: aQueueName through: self directExchange
]

{ #category : 'publishing' }
RabbitMQPublisher >> publish: aMessage to: aRoutingKey through: anExchangeName [

  self
    publish: aMessage
    to: aRoutingKey
    through: anExchangeName
    configuredWith: [ :properties | properties bePersistent ]
]

{ #category : 'publishing' }
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

{ #category : 'publishing' }
RabbitMQPublisher >> publishAll: aMessageCollection to: aQueueName [

	aMessageCollection do: [:message | self publish: message to: aQueueName]
]

{ #category : 'connecting' }
RabbitMQPublisher >> start [

	self ensureChannelOpen
]
