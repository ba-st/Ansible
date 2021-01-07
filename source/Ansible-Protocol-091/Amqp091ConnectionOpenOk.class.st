Class {
	#name : #Amqp091ConnectionOpenOk,
	#superclass : #AmqpProtocolMethod,
	#category : #'Ansible-Protocol-091'
}

{ #category : #'AMQP codec' }
Amqp091ConnectionOpenOk >> acceptableResponseClasses [

	^ #()
]

{ #category : #'AMQP codec' }
Amqp091ConnectionOpenOk >> codecMethodId [

	^ 655401
]

{ #category : #'AMQP codec' }
Amqp091ConnectionOpenOk >> decodeFrom: codec [

	codec nextShortstr
]

{ #category : #'AMQP codec' }
Amqp091ConnectionOpenOk >> encodeOn: codec [

	codec nextShortstrPut: nil
]

{ #category : #'AMQP codec' }
Amqp091ConnectionOpenOk >> hasContents [

	^ false
]
