Class {
	#name : #Amqp091TxRollbackOk,
	#superclass : #AmqpProtocolMethod,
	#category : #'Ansible-Protocol-091'
}

{ #category : #'AMQP codec' }
Amqp091TxRollbackOk >> acceptableResponseClasses [

	^ #()
]

{ #category : #'AMQP codec' }
Amqp091TxRollbackOk >> codecMethodId [

	^ 5898271
]

{ #category : #'AMQP codec' }
Amqp091TxRollbackOk >> decodeFrom: codec [

	
]

{ #category : #'AMQP codec' }
Amqp091TxRollbackOk >> encodeOn: codec [

	
]

{ #category : #'AMQP codec' }
Amqp091TxRollbackOk >> hasContents [

	^ false
]
