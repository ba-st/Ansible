Class {
	#name : #Amqp08FileConsume,
	#superclass : #AmqpProtocolMethod,
	#instVars : [
		'ticket',
		'queue',
		'consumerTag',
		'noLocal',
		'noAck',
		'exclusive',
		'nowait'
	],
	#category : #'Amqp-Protocol-08'
}

{ #category : #'AMQP codec' }
Amqp08FileConsume >> acceptableResponseClasses [

	^ {Amqp08FileConsumeOk}
]

{ #category : #'AMQP codec' }
Amqp08FileConsume >> codecMethodId [

	^ 4587540
]

{ #category : #accessing }
Amqp08FileConsume >> consumerTag [

	^ consumerTag
]

{ #category : #accessing }
Amqp08FileConsume >> consumerTag: aValue [

	consumerTag := aValue
]

{ #category : #'AMQP codec' }
Amqp08FileConsume >> decodeFrom: codec [

	| bitBuffer |

	ticket := codec nextShort.
	queue := codec nextShortstr.
	consumerTag := codec nextShortstr.
	bitBuffer := codec nextOctet.
	noLocal := ( bitBuffer bitAnd: 1 ) ~= 0.
	noAck := ( bitBuffer bitAnd: 2 ) ~= 0.
	exclusive := ( bitBuffer bitAnd: 4 ) ~= 0.
	nowait := ( bitBuffer bitAnd: 8 ) ~= 0
]

{ #category : #'AMQP codec' }
Amqp08FileConsume >> encodeOn: codec [

	| bitBuffer |

	codec nextShortPut: ticket.
	codec nextShortstrPut: queue.
	codec nextShortstrPut: consumerTag.
	bitBuffer := 0.
	( noLocal ifNil: [ false ] )
		ifTrue: [ bitBuffer := bitBuffer bitOr: 1 ].
	( noAck ifNil: [ false ] )
		ifTrue: [ bitBuffer := bitBuffer bitOr: 2 ].
	( exclusive ifNil: [ false ] )
		ifTrue: [ bitBuffer := bitBuffer bitOr: 4 ].
	( nowait ifNil: [ false ] )
		ifTrue: [ bitBuffer := bitBuffer bitOr: 8 ].
	codec nextOctetPut: bitBuffer
]

{ #category : #accessing }
Amqp08FileConsume >> exclusive [

	^ exclusive
]

{ #category : #accessing }
Amqp08FileConsume >> exclusive: aValue [

	exclusive := aValue
]

{ #category : #'AMQP codec' }
Amqp08FileConsume >> hasContents [

	^ false
]

{ #category : #accessing }
Amqp08FileConsume >> noAck [

	^ noAck
]

{ #category : #accessing }
Amqp08FileConsume >> noAck: aValue [

	noAck := aValue
]

{ #category : #accessing }
Amqp08FileConsume >> noLocal [

	^ noLocal
]

{ #category : #accessing }
Amqp08FileConsume >> noLocal: aValue [

	noLocal := aValue
]

{ #category : #accessing }
Amqp08FileConsume >> nowait [

	^ nowait
]

{ #category : #accessing }
Amqp08FileConsume >> nowait: aValue [

	nowait := aValue
]

{ #category : #accessing }
Amqp08FileConsume >> queue [

	^ queue
]

{ #category : #accessing }
Amqp08FileConsume >> queue: aValue [

	queue := aValue
]

{ #category : #accessing }
Amqp08FileConsume >> ticket [

	^ ticket
]

{ #category : #accessing }
Amqp08FileConsume >> ticket: aValue [

	ticket := aValue
]
