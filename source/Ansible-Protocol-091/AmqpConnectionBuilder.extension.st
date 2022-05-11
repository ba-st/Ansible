Extension { #name : #AmqpConnectionBuilder }

{ #category : #'*Ansible-Protocol-091' }
AmqpConnectionBuilder class >> usingAMQP091Protocol [

	^ self forProtocol: Amqp091
]
