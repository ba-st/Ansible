Class {
	#name : #Amqp091TxSelectOk,
	#superclass : #AmqpProtocolMethod,
	#category : #'Ansible-Protocol-091'
}

{ #category : #'AMQP codec' }
Amqp091TxSelectOk >> acceptableResponseClasses [

	^ #()
]

{ #category : #'AMQP codec' }
Amqp091TxSelectOk >> codecMethodId [

	^ 5898251
]

{ #category : #'AMQP codec' }
Amqp091TxSelectOk >> decodeFrom: codec [

	
]

{ #category : #'AMQP codec' }
Amqp091TxSelectOk >> encodeOn: codec [

	
]

{ #category : #'AMQP codec' }
Amqp091TxSelectOk >> hasContents [

	^ false
]
