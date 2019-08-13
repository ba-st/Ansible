Class {
	#name : #Amqp08QueueBind,
	#superclass : #AmqpProtocolMethod,
	#instVars : [
		'ticket',
		'queue',
		'exchange',
		'routingKey',
		'nowait',
		'arguments'
	],
	#category : #'Amqp-Protocol-08'
}

{ #category : #'AMQP codec' }
Amqp08QueueBind >> acceptableResponseClasses [

	^ {Amqp08QueueBindOk}
]

{ #category : #accessing }
Amqp08QueueBind >> arguments [

	^ arguments
]

{ #category : #accessing }
Amqp08QueueBind >> arguments: aValue [

	arguments := aValue
]

{ #category : #'AMQP codec' }
Amqp08QueueBind >> codecMethodId [

	^ 3276820
]

{ #category : #'AMQP codec' }
Amqp08QueueBind >> decodeFrom: codec [

	| bitBuffer |

	ticket := codec nextShort.
	queue := codec nextShortstr.
	exchange := codec nextShortstr.
	routingKey := codec nextShortstr.
	bitBuffer := codec nextOctet.
	nowait := ( bitBuffer bitAnd: 1 ) ~= 0.
	arguments := codec nextTable
]

{ #category : #'AMQP codec' }
Amqp08QueueBind >> encodeOn: codec [

	| bitBuffer |

	codec nextShortPut: ticket.
	codec nextShortstrPut: queue.
	codec nextShortstrPut: exchange.
	codec nextShortstrPut: routingKey.
	bitBuffer := 0.
	( nowait ifNil: [ false ] )
		ifTrue: [ bitBuffer := bitBuffer bitOr: 1 ].
	codec nextOctetPut: bitBuffer.
	codec nextTablePut: arguments
]

{ #category : #accessing }
Amqp08QueueBind >> exchange [

	^ exchange
]

{ #category : #accessing }
Amqp08QueueBind >> exchange: aValue [

	exchange := aValue
]

{ #category : #'AMQP codec' }
Amqp08QueueBind >> hasContents [

	^ false
]

{ #category : #accessing }
Amqp08QueueBind >> nowait [

	^ nowait
]

{ #category : #accessing }
Amqp08QueueBind >> nowait: aValue [

	nowait := aValue
]

{ #category : #accessing }
Amqp08QueueBind >> queue [

	^ queue
]

{ #category : #accessing }
Amqp08QueueBind >> queue: aValue [

	queue := aValue
]

{ #category : #accessing }
Amqp08QueueBind >> routingKey [

	^ routingKey
]

{ #category : #accessing }
Amqp08QueueBind >> routingKey: aValue [

	routingKey := aValue
]

{ #category : #accessing }
Amqp08QueueBind >> ticket [

	^ ticket
]

{ #category : #accessing }
Amqp08QueueBind >> ticket: aValue [

	ticket := aValue
]
