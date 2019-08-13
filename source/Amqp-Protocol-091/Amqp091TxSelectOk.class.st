Class {
	#name : #Amqp091TxSelectOk,
	#superclass : #AmqpProtocolMethod,
	#category : #'Amqp-Protocol-091'
}

{ #category : #'AMQP codec' }
Amqp091TxSelectOk >> acceptableResponseClasses [

	^ {}
]

{ #category : #'AMQP codec' }
Amqp091TxSelectOk >> codecMethodId [

	^ 5898251
]

{ #category : #'AMQP codec' }
Amqp091TxSelectOk >> decodeFrom: codec [

	| bitBuffer |

	
]

{ #category : #'AMQP codec' }
Amqp091TxSelectOk >> encodeOn: codec [

	| bitBuffer |

	
]

{ #category : #'AMQP codec' }
Amqp091TxSelectOk >> hasContents [

	^ false
]
