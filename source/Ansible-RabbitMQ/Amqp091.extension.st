Extension { #name : 'Amqp091' }

{ #category : '*Ansible-RabbitMQ' }
Amqp091 class >> basicNackMethod [

	^methodIds at: 3932280 ifAbsentPut: [Amqp091BasicNack]
]

{ #category : '*Ansible-RabbitMQ' }
Amqp091 class >> confirmSelectMethod [

	^methodIds
		at: 5570570
		ifAbsentPut: [
			methodIds at: 5570571 put: Amqp091ConfirmSelectOk.
			Amqp091ConfirmSelect]
]
