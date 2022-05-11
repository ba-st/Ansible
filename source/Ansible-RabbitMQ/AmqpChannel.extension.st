Extension { #name : #AmqpChannel }

{ #category : #'*Ansible-RabbitMQ' }
AmqpChannel >> confirmMessagesPublicationWith: anAckBlock andThoseNotProcessedWith: aNackBlock [

	self rpc: protocolVersion confirmSelectMethod new.

	handler
		mapEvent: protocolVersion basicAckMethod to: anAckBlock selector: #value:;
		mapEvent: protocolVersion basicNackMethod to: aNackBlock selector: #value:
]
