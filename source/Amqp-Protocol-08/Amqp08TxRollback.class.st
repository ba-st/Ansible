Class {
	#name : #Amqp08TxRollback,
	#superclass : #AmqpProtocolMethod,
	#category : #'Amqp-Protocol-08'
}

{ #category : #'AMQP codec' }
Amqp08TxRollback >> acceptableResponseClasses [

	^ {Amqp08TxRollbackOk}
]

{ #category : #'AMQP codec' }
Amqp08TxRollback >> codecMethodId [

	^ 5898270
]

{ #category : #'AMQP codec' }
Amqp08TxRollback >> decodeFrom: codec [

	| bitBuffer |

	
]

{ #category : #'AMQP codec' }
Amqp08TxRollback >> encodeOn: codec [

	| bitBuffer |

	
]

{ #category : #'AMQP codec' }
Amqp08TxRollback >> hasContents [

	^ false
]
