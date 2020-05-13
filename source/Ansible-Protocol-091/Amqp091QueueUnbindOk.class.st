Class {
	#name : #Amqp091QueueUnbindOk,
	#superclass : #AmqpProtocolMethod,
	#category : #'Ansible-Protocol-091'
}

{ #category : #'AMQP codec' }
Amqp091QueueUnbindOk >> acceptableResponseClasses [

	^ #()
]

{ #category : #'AMQP codec' }
Amqp091QueueUnbindOk >> codecMethodId [

	^ 3276851
]

{ #category : #'AMQP codec' }
Amqp091QueueUnbindOk >> decodeFrom: codec [

	
]

{ #category : #'AMQP codec' }
Amqp091QueueUnbindOk >> encodeOn: codec [

	
]

{ #category : #'AMQP codec' }
Amqp091QueueUnbindOk >> hasContents [

	^ false
]
