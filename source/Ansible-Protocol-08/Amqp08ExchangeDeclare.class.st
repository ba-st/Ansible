Class {
	#name : #Amqp08ExchangeDeclare,
	#superclass : #AmqpProtocolMethod,
	#instVars : [
		'ticket',
		'exchange',
		'type',
		'passive',
		'durable',
		'autoDelete',
		'internal',
		'nowait',
		'arguments'
	],
	#category : #'Ansible-Protocol-08'
}

{ #category : #'AMQP codec' }
Amqp08ExchangeDeclare >> acceptableResponseClasses [

	^ {Amqp08ExchangeDeclareOk}
]

{ #category : #accessing }
Amqp08ExchangeDeclare >> arguments [

	^ arguments
]

{ #category : #accessing }
Amqp08ExchangeDeclare >> arguments: aValue [

	arguments := aValue
]

{ #category : #accessing }
Amqp08ExchangeDeclare >> autoDelete [

	^ autoDelete
]

{ #category : #accessing }
Amqp08ExchangeDeclare >> autoDelete: aValue [

	autoDelete := aValue
]

{ #category : #'AMQP codec' }
Amqp08ExchangeDeclare >> codecMethodId [

	^ 2621450
]

{ #category : #'AMQP codec' }
Amqp08ExchangeDeclare >> decodeFrom: codec [

	| bitBuffer |

	ticket := codec nextShort.
	exchange := codec nextShortstr.
	type := codec nextShortstr.
	bitBuffer := codec nextOctet.
	passive := ( bitBuffer bitAnd: 1 ) ~= 0.
	durable := ( bitBuffer bitAnd: 2 ) ~= 0.
	autoDelete := ( bitBuffer bitAnd: 4 ) ~= 0.
	internal := ( bitBuffer bitAnd: 8 ) ~= 0.
	nowait := ( bitBuffer bitAnd: 16 ) ~= 0.
	arguments := codec nextTable
]

{ #category : #accessing }
Amqp08ExchangeDeclare >> durable [

	^ durable
]

{ #category : #accessing }
Amqp08ExchangeDeclare >> durable: aValue [

	durable := aValue
]

{ #category : #'AMQP codec' }
Amqp08ExchangeDeclare >> encodeOn: codec [

	| bitBuffer |

	codec nextShortPut: ticket.
	codec nextShortstrPut: exchange.
	codec nextShortstrPut: type.
	bitBuffer := 0.
	( passive ifNil: [ false ] )
		ifTrue: [ bitBuffer := bitBuffer bitOr: 1 ].
	( durable ifNil: [ false ] )
		ifTrue: [ bitBuffer := bitBuffer bitOr: 2 ].
	( autoDelete ifNil: [ false ] )
		ifTrue: [ bitBuffer := bitBuffer bitOr: 4 ].
	( internal ifNil: [ false ] )
		ifTrue: [ bitBuffer := bitBuffer bitOr: 8 ].
	( nowait ifNil: [ false ] )
		ifTrue: [ bitBuffer := bitBuffer bitOr: 16 ].
	codec nextOctetPut: bitBuffer.
	codec nextTablePut: arguments
]

{ #category : #accessing }
Amqp08ExchangeDeclare >> exchange [

	^ exchange
]

{ #category : #accessing }
Amqp08ExchangeDeclare >> exchange: aValue [

	exchange := aValue
]

{ #category : #'AMQP codec' }
Amqp08ExchangeDeclare >> hasContents [

	^ false
]

{ #category : #accessing }
Amqp08ExchangeDeclare >> internal [

	^ internal
]

{ #category : #accessing }
Amqp08ExchangeDeclare >> internal: aValue [

	internal := aValue
]

{ #category : #accessing }
Amqp08ExchangeDeclare >> nowait [

	^ nowait
]

{ #category : #accessing }
Amqp08ExchangeDeclare >> nowait: aValue [

	nowait := aValue
]

{ #category : #accessing }
Amqp08ExchangeDeclare >> passive [

	^ passive
]

{ #category : #accessing }
Amqp08ExchangeDeclare >> passive: aValue [

	passive := aValue
]

{ #category : #accessing }
Amqp08ExchangeDeclare >> ticket [

	^ ticket
]

{ #category : #accessing }
Amqp08ExchangeDeclare >> ticket: aValue [

	ticket := aValue
]

{ #category : #accessing }
Amqp08ExchangeDeclare >> type [

	^ type
]

{ #category : #accessing }
Amqp08ExchangeDeclare >> type: aValue [

	type := aValue
]
