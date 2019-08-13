Class {
	#name : #Amqp08DtxStart,
	#superclass : #AmqpProtocolMethod,
	#instVars : [
		'dtxIdentifier'
	],
	#category : #'Amqp-Protocol-08'
}

{ #category : #'AMQP codec' }
Amqp08DtxStart >> acceptableResponseClasses [

	^ {Amqp08DtxStartOk}
]

{ #category : #'AMQP codec' }
Amqp08DtxStart >> codecMethodId [

	^ 6553620
]

{ #category : #'AMQP codec' }
Amqp08DtxStart >> decodeFrom: codec [

	| bitBuffer |

	dtxIdentifier := codec nextShortstr
]

{ #category : #accessing }
Amqp08DtxStart >> dtxIdentifier [

	^ dtxIdentifier
]

{ #category : #accessing }
Amqp08DtxStart >> dtxIdentifier: aValue [

	dtxIdentifier := aValue
]

{ #category : #'AMQP codec' }
Amqp08DtxStart >> encodeOn: codec [

	| bitBuffer |

	codec nextShortstrPut: dtxIdentifier
]

{ #category : #'AMQP codec' }
Amqp08DtxStart >> hasContents [

	^ false
]
