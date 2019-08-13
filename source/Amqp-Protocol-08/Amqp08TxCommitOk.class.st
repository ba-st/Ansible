Class {
	#name : #Amqp08TxCommitOk,
	#superclass : #AmqpProtocolMethod,
	#category : #'Amqp-Protocol-08'
}

{ #category : #'AMQP codec' }
Amqp08TxCommitOk >> acceptableResponseClasses [

	^ {}
]

{ #category : #'AMQP codec' }
Amqp08TxCommitOk >> codecMethodId [

	^ 5898261
]

{ #category : #'AMQP codec' }
Amqp08TxCommitOk >> decodeFrom: codec [

	| bitBuffer |

	
]

{ #category : #'AMQP codec' }
Amqp08TxCommitOk >> encodeOn: codec [

	| bitBuffer |

	
]

{ #category : #'AMQP codec' }
Amqp08TxCommitOk >> hasContents [

	^ false
]
