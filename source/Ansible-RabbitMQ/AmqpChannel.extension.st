Extension { #name : 'AmqpChannel' }

{ #category : '*Ansible-RabbitMQ' }
AmqpChannel >> beInConfirmMode [

  self rpc: protocolVersion confirmSelectMethod new
]

{ #category : '*Ansible-RabbitMQ' }
AmqpChannel >> onPublicationConfirmationDo: anAckBlock [

  handler mapEvent: protocolVersion basicAckMethod to: anAckBlock selector: #value:
]

{ #category : '*Ansible-RabbitMQ' }
AmqpChannel >> onPublicationConfirmationDo: anAckBlock onRejectionDo: aNackBlock [

  self
    beInConfirmMode;
    onPublicationConfirmationDo: anAckBlock;
    onPublicationRejectionDo: aNackBlock
]

{ #category : '*Ansible-RabbitMQ' }
AmqpChannel >> onPublicationRejectionDo: aNackBlock [

  handler mapEvent: protocolVersion basicNackMethod to: aNackBlock selector: #value:
]
