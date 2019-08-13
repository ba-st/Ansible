Class {
	#name : #Amqp08ExchangeDelete,
	#superclass : #AmqpProtocolMethod,
	#instVars : [
		'ticket',
		'exchange',
		'ifUnused',
		'nowait'
	],
	#category : #'Amqp-Protocol-08'
}

{ #category : #'AMQP codec' }
Amqp08ExchangeDelete >> acceptableResponseClasses [

	^ {Amqp08ExchangeDeleteOk}
]

{ #category : #'AMQP codec' }
Amqp08ExchangeDelete >> codecMethodId [

	^ 2621460
]

{ #category : #'AMQP codec' }
Amqp08ExchangeDelete >> decodeFrom: codec [

	| bitBuffer |

	ticket := codec nextShort.
	exchange := codec nextShortstr.
	bitBuffer := codec nextOctet.
	ifUnused := ( bitBuffer bitAnd: 1 ) ~= 0.
	nowait := ( bitBuffer bitAnd: 2 ) ~= 0
]

{ #category : #'AMQP codec' }
Amqp08ExchangeDelete >> encodeOn: codec [

	| bitBuffer |

	codec nextShortPut: ticket.
	codec nextShortstrPut: exchange.
	bitBuffer := 0.
	( ifUnused ifNil: [ false ] )
		ifTrue: [ bitBuffer := bitBuffer bitOr: 1 ].
	( nowait ifNil: [ false ] )
		ifTrue: [ bitBuffer := bitBuffer bitOr: 2 ].
	codec nextOctetPut: bitBuffer
]

{ #category : #accessing }
Amqp08ExchangeDelete >> exchange [

	^ exchange
]

{ #category : #accessing }
Amqp08ExchangeDelete >> exchange: aValue [

	exchange := aValue
]

{ #category : #'AMQP codec' }
Amqp08ExchangeDelete >> hasContents [

	^ false
]

{ #category : #accessing }
Amqp08ExchangeDelete >> ifUnused [

	^ ifUnused
]

{ #category : #accessing }
Amqp08ExchangeDelete >> ifUnused: aValue [

	ifUnused := aValue
]

{ #category : #accessing }
Amqp08ExchangeDelete >> nowait [

	^ nowait
]

{ #category : #accessing }
Amqp08ExchangeDelete >> nowait: aValue [

	nowait := aValue
]

{ #category : #accessing }
Amqp08ExchangeDelete >> ticket [

	^ ticket
]

{ #category : #accessing }
Amqp08ExchangeDelete >> ticket: aValue [

	ticket := aValue
]
