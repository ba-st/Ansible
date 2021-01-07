Class {
	#name : #Amqp091ConnectionCloseOk,
	#superclass : #AmqpProtocolMethod,
	#category : #'Ansible-Protocol-091'
}

{ #category : #'AMQP codec' }
Amqp091ConnectionCloseOk >> acceptableResponseClasses [

	^ #()
]

{ #category : #'AMQP codec' }
Amqp091ConnectionCloseOk >> codecMethodId [

	^ 655411
]

{ #category : #'AMQP codec' }
Amqp091ConnectionCloseOk >> decodeFrom: codec [

	
]

{ #category : #'AMQP codec' }
Amqp091ConnectionCloseOk >> encodeOn: codec [

	
]

{ #category : #'AMQP codec' }
Amqp091ConnectionCloseOk >> hasContents [

	^ false
]
