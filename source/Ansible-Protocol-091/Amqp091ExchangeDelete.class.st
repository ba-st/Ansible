Class {
	#name : #Amqp091ExchangeDelete,
	#superclass : #AmqpProtocolMethod,
	#instVars : [
		'exchange',
		'ifUnused',
		'noWait'
	],
	#category : #'Ansible-Protocol-091'
}

{ #category : #'AMQP codec' }
Amqp091ExchangeDelete >> acceptableResponseClasses [

	^ Array with: Amqp091ExchangeDeleteOk
]

{ #category : #'AMQP codec' }
Amqp091ExchangeDelete >> codecMethodId [

	^ 2621460
]

{ #category : #'AMQP codec' }
Amqp091ExchangeDelete >> decodeFrom: codec [

	| bitBuffer |

	codec nextShort.
	exchange := codec nextShortstr.
	bitBuffer := codec nextOctet.
	ifUnused := ( bitBuffer bitAnd: 1 ) ~= 0.
	noWait := ( bitBuffer bitAnd: 2 ) ~= 0
]

{ #category : #'AMQP codec' }
Amqp091ExchangeDelete >> encodeOn: codec [

	| bitBuffer |

	codec nextShortPut: 0.
	codec nextShortstrPut: exchange.
	bitBuffer := 0.
	( ifUnused ifNil: [ false ] )
		ifTrue: [ bitBuffer := bitBuffer bitOr: 1 ].
	( noWait ifNil: [ false ] )
		ifTrue: [ bitBuffer := bitBuffer bitOr: 2 ].
	codec nextOctetPut: bitBuffer
]

{ #category : #accessing }
Amqp091ExchangeDelete >> exchange [

	^ exchange
]

{ #category : #accessing }
Amqp091ExchangeDelete >> exchange: aValue [

	exchange := aValue
]

{ #category : #'AMQP codec' }
Amqp091ExchangeDelete >> hasContents [

	^ false
]

{ #category : #accessing }
Amqp091ExchangeDelete >> ifUnused [

	^ ifUnused
]

{ #category : #accessing }
Amqp091ExchangeDelete >> ifUnused: aValue [

	ifUnused := aValue
]

{ #category : #accessing }
Amqp091ExchangeDelete >> noWait [

	^ noWait
]

{ #category : #accessing }
Amqp091ExchangeDelete >> noWait: aValue [

	noWait := aValue
]
