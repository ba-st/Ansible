Class {
	#name : #Amqp091TxRollback,
	#superclass : #AmqpProtocolMethod,
	#category : #'Amqp-Protocol-091'
}

{ #category : #'AMQP codec' }
Amqp091TxRollback >> acceptableResponseClasses [

	^ {Amqp091TxRollbackOk}
]

{ #category : #'AMQP codec' }
Amqp091TxRollback >> codecMethodId [

	^ 5898270
]

{ #category : #'AMQP codec' }
Amqp091TxRollback >> decodeFrom: codec [

	| bitBuffer |

	
]

{ #category : #'AMQP codec' }
Amqp091TxRollback >> encodeOn: codec [

	| bitBuffer |

	
]

{ #category : #'AMQP codec' }
Amqp091TxRollback >> hasContents [

	^ false
]
