Class {
	#name : #Amqp091TxSelect,
	#superclass : #AmqpProtocolMethod,
	#category : #'Ansible-Protocol-091'
}

{ #category : #'AMQP codec' }
Amqp091TxSelect >> acceptableResponseClasses [

	^ Array with: Amqp091TxSelectOk
]

{ #category : #'AMQP codec' }
Amqp091TxSelect >> codecMethodId [

	^ 5898250
]

{ #category : #'AMQP codec' }
Amqp091TxSelect >> decodeFrom: codec [

	
]

{ #category : #'AMQP codec' }
Amqp091TxSelect >> encodeOn: codec [

	
]

{ #category : #'AMQP codec' }
Amqp091TxSelect >> hasContents [

	^ false
]
