Extension { #name : 'AmqpChannel' }

{ #category : '*Ansible-RabbitMQ' }
AmqpChannel >> confirmPublicationWith: anAckBlock otherwise: aNackBlock [

	self rpc: protocolVersion confirmSelectMethod new.

	handler
		mapEvent: protocolVersion basicAckMethod to: anAckBlock selector: #value:;
		mapEvent: protocolVersion basicNackMethod to: aNackBlock selector: #value:
]
