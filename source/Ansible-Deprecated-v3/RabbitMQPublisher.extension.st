Extension { #name : 'RabbitMQPublisher' }

{ #category : '*Ansible-Deprecated-v3' }
RabbitMQPublisher >> publish: aMessageCollection onQueueNamed: aQueueName [

  self
    deprecated: 'Use confirmPublicationWith:otherwise:'
    transformWith:
      '`@receiver publish: `@aMessageCollection onQueueNamed:  `@aQueueName'
      -> '`@receiver publishAll: `@aMessageCollection to: `@aQueueName'.

  self publishAll: aMessageCollection to: aQueueName
]

{ #category : '*Ansible-Deprecated-v3' }
RabbitMQPublisher >> publishOnly: aMessage onQueueNamed: aQueueName [

  self
    deprecated: 'Use confirmPublicationWith:otherwise:'
    transformWith:
      '`@receiver publishOnly: `@aMessage onQueueNamed:  `@aQueueName'
      -> '`@receiver publish: `@aMessage to: `@aQueueName'.

  self publish: aMessage to: aQueueName
]
