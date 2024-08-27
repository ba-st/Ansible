Extension { #name : 'AmqpChannel' }

{ #category : '*Ansible-Deprecated-v3' }
AmqpChannel >> confirmMessagesPublicationWith: anAckBlock andThoseNotProcessedWith: aNackBlock [

  self
    deprecated: 'Use confirmPublicationWith:otherwise:'
    transformWith:
      '`@receiver confirmMessagesPublicationWith: `@anAckBlock andThoseNotProcessedWith:  `@aNackBlock'
      -> '`@receiver onPublicationConfirmationDo: `@anAckBlock onRejectionDo: `@aNackBlock'.

  self onPublicationConfirmationDo: anAckBlock onRejectionDo: aNackBlock
]

{ #category : '*Ansible-Deprecated-v3' }
AmqpChannel >> exchangeDeclare: exchangeName type: typeString [

  self deprecated: 'Use #declareExchangeNamed:of:applying: directly'.

  ^ self
      exchangeDeclare: exchangeName
      type: typeString
      durable: false
      autoDelete: false
      passive: false
      arguments: nil
]

{ #category : '*Ansible-Deprecated-v3' }
AmqpChannel >> exchangeDeclare: exchangeName type: typeString durable: durable [

  self deprecated: 'Use #declareExchangeNamed:of:applying: directly'.

  ^ self
      exchangeDeclare: exchangeName
      type: typeString
      durable: durable
      autoDelete: false
      passive: false
      arguments: nil
]

{ #category : '*Ansible-Deprecated-v3' }
AmqpChannel >> exchangeDeclare: exchangeName type: typeString durable: durable autoDelete: autoDelete passive: passive [

  self deprecated: 'Use #declareExchangeNamed:of:applying: directly'.

  ^ self
      exchangeDeclare: exchangeName
      type: typeString
      durable: durable
      autoDelete: autoDelete
      passive: passive
      arguments: nil
]

{ #category : '*Ansible-Deprecated-v3' }
AmqpChannel >> exchangeDeclare: exchangeName type: typeString durable: durable autoDelete: autoDelete passive: passive arguments: aDictionary [

  self deprecated: 'Use #declareExchangeNamed:of:applying: directly'.

  ^ self declareExchangeNamed: exchangeName of: typeString applying: [ :builder |
        passive then: [ builder bePassive ].
        durable then: [ builder beDurable ].
        autoDelete then: [ builder autoDelete ].
        builder useAsArguments: aDictionary
      ]
]

{ #category : '*Ansible-Deprecated-v3' }
AmqpChannel >> queueDeclare: queueName [

  self deprecated: 'Use #declareQueueApplying: directly'.
  ^ self
      queueDeclare: queueName
      durable: false
      exclusive: false
      autoDelete: false
      passive: false
      arguments: nil
]

{ #category : '*Ansible-Deprecated-v3' }
AmqpChannel >> queueDeclare: queueName durable: durable [

  self deprecated: 'Use #declareQueueApplying: directly'.
  ^ self
      queueDeclare: queueName
      durable: durable
      exclusive: false
      autoDelete: false
      passive: false
      arguments: nil
]

{ #category : '*Ansible-Deprecated-v3' }
AmqpChannel >> queueDeclare: queueName durable: durable exclusive: exclusive autoDelete: autoDelete passive: passive arguments: aDictionary [

  self deprecated: 'Use #declareQueueApplying: directly'.

  ^ self declareQueueApplying: [ :builder |
        builder
          name: queueName;
          useAsArguments: aDictionary.
        passive then: [ builder bePassive ].
        durable then: [ builder beDurable ].
        exclusive then: [ builder beExclusive ].
        autoDelete then: [ builder autoDelete ]
      ]
]
