Class {
	#name : #Amqp08TxSelectOk,
	#superclass : #AmqpProtocolMethod,
	#category : #'Amqp-Protocol-08'
}

{ #category : #'AMQP codec' }
Amqp08TxSelectOk >> acceptableResponseClasses [

	^ {}
]

{ #category : #'AMQP codec' }
Amqp08TxSelectOk >> codecMethodId [

	^ 5898251
]

{ #category : #'AMQP codec' }
Amqp08TxSelectOk >> decodeFrom: codec [

	| bitBuffer |

	
]

{ #category : #'AMQP codec' }
Amqp08TxSelectOk >> encodeOn: codec [

	| bitBuffer |

	
]

{ #category : #'AMQP codec' }
Amqp08TxSelectOk >> hasContents [

	^ false
]
