Class {
	#name : #Amqp091QueueBindOk,
	#superclass : #AmqpProtocolMethod,
	#category : #'Ansible-Protocol-091'
}

{ #category : #'AMQP codec' }
Amqp091QueueBindOk >> acceptableResponseClasses [

	^ #()
]

{ #category : #'AMQP codec' }
Amqp091QueueBindOk >> codecMethodId [

	^ 3276821
]

{ #category : #'AMQP codec' }
Amqp091QueueBindOk >> decodeFrom: codec [

	
]

{ #category : #'AMQP codec' }
Amqp091QueueBindOk >> encodeOn: codec [

	
]

{ #category : #'AMQP codec' }
Amqp091QueueBindOk >> hasContents [

	^ false
]
