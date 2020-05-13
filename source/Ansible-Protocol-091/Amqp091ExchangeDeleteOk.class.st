Class {
	#name : #Amqp091ExchangeDeleteOk,
	#superclass : #AmqpProtocolMethod,
	#category : #'Ansible-Protocol-091'
}

{ #category : #'AMQP codec' }
Amqp091ExchangeDeleteOk >> acceptableResponseClasses [

	^ #()
]

{ #category : #'AMQP codec' }
Amqp091ExchangeDeleteOk >> codecMethodId [

	^ 2621461
]

{ #category : #'AMQP codec' }
Amqp091ExchangeDeleteOk >> decodeFrom: codec [

	
]

{ #category : #'AMQP codec' }
Amqp091ExchangeDeleteOk >> encodeOn: codec [

	
]

{ #category : #'AMQP codec' }
Amqp091ExchangeDeleteOk >> hasContents [

	^ false
]
