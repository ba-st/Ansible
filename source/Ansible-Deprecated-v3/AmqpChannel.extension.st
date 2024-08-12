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
