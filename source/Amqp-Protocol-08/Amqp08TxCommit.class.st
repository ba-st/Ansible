Class {
	#name : #Amqp08TxCommit,
	#superclass : #AmqpProtocolMethod,
	#category : #'Amqp-Protocol-08'
}

{ #category : #'AMQP codec' }
Amqp08TxCommit >> acceptableResponseClasses [

	^ {Amqp08TxCommitOk}
]

{ #category : #'AMQP codec' }
Amqp08TxCommit >> codecMethodId [

	^ 5898260
]

{ #category : #'AMQP codec' }
Amqp08TxCommit >> decodeFrom: codec [

	| bitBuffer |

	
]

{ #category : #'AMQP codec' }
Amqp08TxCommit >> encodeOn: codec [

	| bitBuffer |

	
]

{ #category : #'AMQP codec' }
Amqp08TxCommit >> hasContents [

	^ false
]
