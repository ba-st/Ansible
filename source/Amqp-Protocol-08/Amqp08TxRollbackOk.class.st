Class {
	#name : #Amqp08TxRollbackOk,
	#superclass : #AmqpProtocolMethod,
	#category : #'Amqp-Protocol-08'
}

{ #category : #'AMQP codec' }
Amqp08TxRollbackOk >> acceptableResponseClasses [

	^ {}
]

{ #category : #'AMQP codec' }
Amqp08TxRollbackOk >> codecMethodId [

	^ 5898271
]

{ #category : #'AMQP codec' }
Amqp08TxRollbackOk >> decodeFrom: codec [

	| bitBuffer |

	
]

{ #category : #'AMQP codec' }
Amqp08TxRollbackOk >> encodeOn: codec [

	| bitBuffer |

	
]

{ #category : #'AMQP codec' }
Amqp08TxRollbackOk >> hasContents [

	^ false
]
