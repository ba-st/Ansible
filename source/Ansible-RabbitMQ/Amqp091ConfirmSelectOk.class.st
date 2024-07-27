Class {
	#name : 'Amqp091ConfirmSelectOk',
	#superclass : 'AmqpProtocolMethod',
	#category : 'Ansible-RabbitMQ',
	#package : 'Ansible-RabbitMQ'
}

{ #category : 'accessing' }
Amqp091ConfirmSelectOk >> acceptableResponseClasses [

	^ #()
]

{ #category : 'accessing' }
Amqp091ConfirmSelectOk >> codecMethodId [

	^ 5570571
]

{ #category : 'decoding' }
Amqp091ConfirmSelectOk >> decodeFrom: codec [
]

{ #category : 'encoding' }
Amqp091ConfirmSelectOk >> encodeOn: codec [
]

{ #category : 'testing' }
Amqp091ConfirmSelectOk >> hasContents [

	^false
]
