Class {
	#name : #Amqp091ExchangeDeclare,
	#superclass : #AmqpProtocolMethod,
	#instVars : [
		'exchange',
		'type',
		'passive',
		'durable',
		'noWait',
		'arguments'
	],
	#category : #'Ansible-Protocol-091'
}

{ #category : #'AMQP codec' }
Amqp091ExchangeDeclare >> acceptableResponseClasses [

	^ Array with: Amqp091ExchangeDeclareOk
]

{ #category : #accessing }
Amqp091ExchangeDeclare >> arguments [

	^ arguments
]

{ #category : #accessing }
Amqp091ExchangeDeclare >> arguments: aValue [

	arguments := aValue
]

{ #category : #accessing }
Amqp091ExchangeDeclare >> autoDelete: aBoolean [
]

{ #category : #'AMQP codec' }
Amqp091ExchangeDeclare >> codecMethodId [

	^ 2621450
]

{ #category : #'AMQP codec' }
Amqp091ExchangeDeclare >> decodeFrom: codec [

	| bitBuffer |

	codec nextShort.
	exchange := codec nextShortstr.
	type := codec nextShortstr.
	bitBuffer := codec nextOctet.
	passive := ( bitBuffer bitAnd: 1 ) ~= 0.
	durable := ( bitBuffer bitAnd: 2 ) ~= 0.
	noWait := ( bitBuffer bitAnd: 16 ) ~= 0.
	arguments := codec nextTable
]

{ #category : #accessing }
Amqp091ExchangeDeclare >> durable [

	^ durable
]

{ #category : #accessing }
Amqp091ExchangeDeclare >> durable: aValue [

	durable := aValue
]

{ #category : #'AMQP codec' }
Amqp091ExchangeDeclare >> encodeOn: codec [

	| bitBuffer |

	codec nextShortPut: 0.
	codec nextShortstrPut: exchange.
	codec nextShortstrPut: type.
	bitBuffer := 0.
	( passive ifNil: [ false ] )
		ifTrue: [ bitBuffer := bitBuffer bitOr: 1 ].
	( durable ifNil: [ false ] )
		ifTrue: [ bitBuffer := bitBuffer bitOr: 2 ].
	( noWait ifNil: [ false ] )
		ifTrue: [ bitBuffer := bitBuffer bitOr: 16 ].
	codec nextOctetPut: bitBuffer.
	codec nextTablePut: arguments
]

{ #category : #accessing }
Amqp091ExchangeDeclare >> exchange [

	^ exchange
]

{ #category : #accessing }
Amqp091ExchangeDeclare >> exchange: aValue [

	exchange := aValue
]

{ #category : #'AMQP codec' }
Amqp091ExchangeDeclare >> hasContents [

	^ false
]

{ #category : #accessing }
Amqp091ExchangeDeclare >> noWait [

	^ noWait
]

{ #category : #accessing }
Amqp091ExchangeDeclare >> noWait: aValue [

	noWait := aValue
]

{ #category : #accessing }
Amqp091ExchangeDeclare >> passive [

	^ passive
]

{ #category : #accessing }
Amqp091ExchangeDeclare >> passive: aValue [

	passive := aValue
]

{ #category : #accessing }
Amqp091ExchangeDeclare >> type [

	^ type
]

{ #category : #accessing }
Amqp091ExchangeDeclare >> type: aValue [

	type := aValue
]
