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

{ #category : 'configuring' }
RabbitMQPublisher >> confirmPublicationWith: anAckBlock otherwise: aNackBlock [

  channelConfigurationCommands add: [ :theChannel |
      theChannel confirmPublicationWith: anAckBlock otherwise: aNackBlock ]
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

{ #category : 'publishing' }
RabbitMQPublisher >> publish: aMessageCollection onQueueNamed: aQueueName [

	aMessageCollection do: [:message | self publishOnly: message onQueueNamed: aQueueName]
]

{ #category : 'publishing' }
RabbitMQPublisher >> publishOnly: aMessage onQueueNamed: aQueueName [

	self ensureChannelOpen.

	channel
		basicPublish: aMessage utf8Encoded
		exchange: ''
		routingKey: aQueueName
		properties: ( connection protocolClass basicPropertiesClass new deliveryMode: 2 ).

	self shouldLogDebuggingInfo then: [
			LogRecord emitStructuredDebuggingInfo: 'RabbitMQ message published' with: [ :data |
					data
						at: #messagePublished put: aMessage;
						at: #routingKey put: aQueueName;
						at: #connectionDescription put: connection connectionPairsDescription
				]
		]
]

{ #category : 'connecting' }
RabbitMQPublisher >> start [

	self ensureChannelOpen
]
