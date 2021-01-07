Class {
	#name : #Amqp091TxCommit,
	#superclass : #AmqpProtocolMethod,
	#category : #'Ansible-Protocol-091'
}

{ #category : #'AMQP codec' }
Amqp091TxCommit >> acceptableResponseClasses [

	^ Array with: Amqp091TxCommitOk
]

{ #category : #'AMQP codec' }
Amqp091TxCommit >> codecMethodId [

	^ 5898260
]

{ #category : #'AMQP codec' }
Amqp091TxCommit >> decodeFrom: codec [

	
]

{ #category : #'AMQP codec' }
Amqp091TxCommit >> encodeOn: codec [

	
]

{ #category : #'AMQP codec' }
Amqp091TxCommit >> hasContents [

	^ false
]
