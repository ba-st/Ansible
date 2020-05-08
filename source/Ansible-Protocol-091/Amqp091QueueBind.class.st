Class {
	#name : #Amqp091QueueBind,
	#superclass : #AmqpProtocolMethod,
	#instVars : [
		'queue',
		'exchange',
		'routingKey',
		'noWait',
		'arguments'
	],
	#category : #'Ansible-Protocol-091'
}

{ #category : #'AMQP codec' }
Amqp091QueueBind >> acceptableResponseClasses [

	^ {Amqp091QueueBindOk}
]

{ #category : #accessing }
Amqp091QueueBind >> arguments [

	^ arguments
]

{ #category : #accessing }
Amqp091QueueBind >> arguments: aValue [

	arguments := aValue
]

{ #category : #'AMQP codec' }
Amqp091QueueBind >> codecMethodId [

	^ 3276820
]

{ #category : #'AMQP codec' }
Amqp091QueueBind >> decodeFrom: codec [

	| bitBuffer |

	codec nextShort.
	queue := codec nextShortstr.
	exchange := codec nextShortstr.
	routingKey := codec nextShortstr.
	bitBuffer := codec nextOctet.
	noWait := ( bitBuffer bitAnd: 1 ) ~= 0.
	arguments := codec nextTable
]

{ #category : #'AMQP codec' }
Amqp091QueueBind >> encodeOn: codec [

	| bitBuffer |

	codec nextShortPut: 0.
	codec nextShortstrPut: queue.
	codec nextShortstrPut: exchange.
	codec nextShortstrPut: routingKey.
	bitBuffer := 0.
	( noWait ifNil: [ false ] )
		ifTrue: [ bitBuffer := bitBuffer bitOr: 1 ].
	codec nextOctetPut: bitBuffer.
	codec nextTablePut: arguments
]

{ #category : #accessing }
Amqp091QueueBind >> exchange [

	^ exchange
]

{ #category : #accessing }
Amqp091QueueBind >> exchange: aValue [

	exchange := aValue
]

{ #category : #'AMQP codec' }
Amqp091QueueBind >> hasContents [

	^ false
]

{ #category : #accessing }
Amqp091QueueBind >> noWait [

	^ noWait
]

{ #category : #accessing }
Amqp091QueueBind >> noWait: aValue [

	noWait := aValue
]

{ #category : #accessing }
Amqp091QueueBind >> queue [

	^ queue
]

{ #category : #accessing }
Amqp091QueueBind >> queue: aValue [

	queue := aValue
]

{ #category : #accessing }
Amqp091QueueBind >> routingKey [

	^ routingKey
]

{ #category : #accessing }
Amqp091QueueBind >> routingKey: aValue [

	routingKey := aValue
]
