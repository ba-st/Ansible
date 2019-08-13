Class {
	#name : #Amqp091BasicRecoverAsync,
	#superclass : #AmqpProtocolMethod,
	#instVars : [
		'requeue'
	],
	#category : #'Amqp-Protocol-091'
}

{ #category : #'AMQP codec' }
Amqp091BasicRecoverAsync >> acceptableResponseClasses [

	^ {}
]

{ #category : #'AMQP codec' }
Amqp091BasicRecoverAsync >> codecMethodId [

	^ 3932260
]

{ #category : #'AMQP codec' }
Amqp091BasicRecoverAsync >> decodeFrom: codec [

	| bitBuffer |

	bitBuffer := codec nextOctet.
	requeue := ( bitBuffer bitAnd: 1 ) ~= 0
]

{ #category : #'AMQP codec' }
Amqp091BasicRecoverAsync >> encodeOn: codec [

	| bitBuffer |

	bitBuffer := 0.
	( requeue ifNil: [ false ] )
		ifTrue: [ bitBuffer := bitBuffer bitOr: 1 ].
	codec nextOctetPut: bitBuffer
]

{ #category : #'AMQP codec' }
Amqp091BasicRecoverAsync >> hasContents [

	^ false
]

{ #category : #accessing }
Amqp091BasicRecoverAsync >> requeue [

	^ requeue
]

{ #category : #accessing }
Amqp091BasicRecoverAsync >> requeue: aValue [

	requeue := aValue
]
