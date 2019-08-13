Class {
	#name : #Amqp091TxCommitOk,
	#superclass : #AmqpProtocolMethod,
	#category : #'Amqp-Protocol-091'
}

{ #category : #'AMQP codec' }
Amqp091TxCommitOk >> acceptableResponseClasses [

	^ {}
]

{ #category : #'AMQP codec' }
Amqp091TxCommitOk >> codecMethodId [

	^ 5898261
]

{ #category : #'AMQP codec' }
Amqp091TxCommitOk >> decodeFrom: codec [

	| bitBuffer |

	
]

{ #category : #'AMQP codec' }
Amqp091TxCommitOk >> encodeOn: codec [

	| bitBuffer |

	
]

{ #category : #'AMQP codec' }
Amqp091TxCommitOk >> hasContents [

	^ false
]
