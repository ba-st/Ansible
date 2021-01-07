Class {
	#name : #Amqp091TxRollback,
	#superclass : #AmqpProtocolMethod,
	#category : #'Ansible-Protocol-091'
}

{ #category : #'AMQP codec' }
Amqp091TxRollback >> acceptableResponseClasses [

	^ Array with: Amqp091TxRollbackOk
]

{ #category : #'AMQP codec' }
Amqp091TxRollback >> codecMethodId [

	^ 5898270
]

{ #category : #'AMQP codec' }
Amqp091TxRollback >> decodeFrom: codec [

	
]

{ #category : #'AMQP codec' }
Amqp091TxRollback >> encodeOn: codec [

	
]

{ #category : #'AMQP codec' }
Amqp091TxRollback >> hasContents [

	^ false
]
