Extension { #name : 'RabbitMQPublisher' }

{ #category : '*Ansible-Deprecated-v3' }
RabbitMQPublisher >> confirmMessagesPublicationWith: anAckBlock andThoseNotProcessedWith: aNackBlock [

	self
		deprecated: 'Use confirmPublicationWith:otherwise:'
		transformWith:
			'`@receiver confirmMessagesPublicationWith: `@anAckBlock andThoseNotProcessedWith:  `@aNackBlock'
			-> '`@receiver confirmPublicationWith: `@anAckBlock otherwise: `@aNackBlock'.

	self confirmPublicationWith: anAckBlock otherwise: aNackBlock
]
