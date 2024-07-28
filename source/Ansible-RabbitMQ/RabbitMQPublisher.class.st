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
	#category : 'Ansible-RabbitMQ',
	#package : 'Ansible-RabbitMQ'
}

{ #category : 'instance creation' }
RabbitMQPublisher class >> configuredBy: aConfigurationAction [

	| options |

	options := Dictionary new.
	aConfigurationAction value: options.
	^ self new initializeConfiguredBy: options
]

{ #category : 'publishing' }
RabbitMQPublisher >> channel [

  ^ channel
]

{ #category : 'publishing' }
RabbitMQPublisher >> publish: aMessageCollection onQueueNamed: aQueueName [

	aMessageCollection do: [:message | self publishOnly: message onQueueNamed: aQueueName]
]

{ #category : 'publishing' }
RabbitMQPublisher >> publishOnly: aMessage onQueueNamed: aQueueName [

	self ensureChannelOpen.

	self shouldLogDebuggingInfo then: [
		LogRecord
			emitStructuredDebuggingInfo: 'RabbitMQ message published'
			with: [:data |
				data
					at: #messagePublished put: aMessage;
					at: #routingKey put: aQueueName;
					at: #connectionDescription put: connection connectionPairsDescription]].

	channel
		basicPublish: aMessage utf8Encoded
		exchange: ''
		routingKey: aQueueName
		properties: (connection protocolClass basicPropertiesClass new deliveryMode: 2)
]

{ #category : 'connecting' }
RabbitMQPublisher >> start [

	self ensureChannelOpen
]
