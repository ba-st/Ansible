Class {
	#name : #Amqp08BasicGet,
	#superclass : #AmqpProtocolMethod,
	#instVars : [
		'ticket',
		'queue',
		'noAck'
	],
	#category : #'Amqp-Protocol-08'
}

{ #category : #'AMQP codec' }
Amqp08BasicGet >> acceptableResponseClasses [

	^ {Amqp08BasicGetEmpty.
	Amqp08BasicGetOk}
]

{ #category : #'AMQP codec' }
Amqp08BasicGet >> codecMethodId [

	^ 3932230
]

{ #category : #'AMQP codec' }
Amqp08BasicGet >> decodeFrom: codec [

	| bitBuffer |

	ticket := codec nextShort.
	queue := codec nextShortstr.
	bitBuffer := codec nextOctet.
	noAck := ( bitBuffer bitAnd: 1 ) ~= 0
]

{ #category : #'AMQP codec' }
Amqp08BasicGet >> encodeOn: codec [

	| bitBuffer |

	codec nextShortPut: ticket.
	codec nextShortstrPut: queue.
	bitBuffer := 0.
	( noAck ifNil: [ false ] )
		ifTrue: [ bitBuffer := bitBuffer bitOr: 1 ].
	codec nextOctetPut: bitBuffer
]

{ #category : #'AMQP codec' }
Amqp08BasicGet >> hasContents [

	^ false
]

{ #category : #accessing }
Amqp08BasicGet >> noAck [

	^ noAck
]

{ #category : #accessing }
Amqp08BasicGet >> noAck: aValue [

	noAck := aValue
]

{ #category : #accessing }
Amqp08BasicGet >> queue [

	^ queue
]

{ #category : #accessing }
Amqp08BasicGet >> queue: aValue [

	queue := aValue
]

{ #category : #accessing }
Amqp08BasicGet >> ticket [

	^ ticket
]

{ #category : #accessing }
Amqp08BasicGet >> ticket: aValue [

	ticket := aValue
]
