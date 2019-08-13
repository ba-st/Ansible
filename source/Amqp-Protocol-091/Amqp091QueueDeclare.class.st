Class {
	#name : #Amqp091QueueDeclare,
	#superclass : #AmqpProtocolMethod,
	#instVars : [
		'queue',
		'passive',
		'durable',
		'exclusive',
		'autoDelete',
		'noWait',
		'arguments'
	],
	#category : #'Amqp-Protocol-091'
}

{ #category : #'AMQP codec' }
Amqp091QueueDeclare >> acceptableResponseClasses [

	^ {Amqp091QueueDeclareOk}
]

{ #category : #accessing }
Amqp091QueueDeclare >> arguments [

	^ arguments
]

{ #category : #accessing }
Amqp091QueueDeclare >> arguments: aValue [

	arguments := aValue
]

{ #category : #accessing }
Amqp091QueueDeclare >> autoDelete [

	^ autoDelete
]

{ #category : #accessing }
Amqp091QueueDeclare >> autoDelete: aValue [

	autoDelete := aValue
]

{ #category : #'AMQP codec' }
Amqp091QueueDeclare >> codecMethodId [

	^ 3276810
]

{ #category : #'AMQP codec' }
Amqp091QueueDeclare >> decodeFrom: codec [

	| bitBuffer |

	codec nextShort.
	queue := codec nextShortstr.
	bitBuffer := codec nextOctet.
	passive := ( bitBuffer bitAnd: 1 ) ~= 0.
	durable := ( bitBuffer bitAnd: 2 ) ~= 0.
	exclusive := ( bitBuffer bitAnd: 4 ) ~= 0.
	autoDelete := ( bitBuffer bitAnd: 8 ) ~= 0.
	noWait := ( bitBuffer bitAnd: 16 ) ~= 0.
	arguments := codec nextTable
]

{ #category : #accessing }
Amqp091QueueDeclare >> durable [

	^ durable
]

{ #category : #accessing }
Amqp091QueueDeclare >> durable: aValue [

	durable := aValue
]

{ #category : #'AMQP codec' }
Amqp091QueueDeclare >> encodeOn: codec [

	| bitBuffer |

	codec nextShortPut: 0.
	codec nextShortstrPut: queue.
	bitBuffer := 0.
	( passive ifNil: [ false ] )
		ifTrue: [ bitBuffer := bitBuffer bitOr: 1 ].
	( durable ifNil: [ false ] )
		ifTrue: [ bitBuffer := bitBuffer bitOr: 2 ].
	( exclusive ifNil: [ false ] )
		ifTrue: [ bitBuffer := bitBuffer bitOr: 4 ].
	( autoDelete ifNil: [ false ] )
		ifTrue: [ bitBuffer := bitBuffer bitOr: 8 ].
	( noWait ifNil: [ false ] )
		ifTrue: [ bitBuffer := bitBuffer bitOr: 16 ].
	codec nextOctetPut: bitBuffer.
	codec nextTablePut: arguments
]

{ #category : #accessing }
Amqp091QueueDeclare >> exclusive [

	^ exclusive
]

{ #category : #accessing }
Amqp091QueueDeclare >> exclusive: aValue [

	exclusive := aValue
]

{ #category : #'AMQP codec' }
Amqp091QueueDeclare >> hasContents [

	^ false
]

{ #category : #accessing }
Amqp091QueueDeclare >> noWait [

	^ noWait
]

{ #category : #accessing }
Amqp091QueueDeclare >> noWait: aValue [

	noWait := aValue
]

{ #category : #accessing }
Amqp091QueueDeclare >> passive [

	^ passive
]

{ #category : #accessing }
Amqp091QueueDeclare >> passive: aValue [

	passive := aValue
]

{ #category : #accessing }
Amqp091QueueDeclare >> queue [

	^ queue
]

{ #category : #accessing }
Amqp091QueueDeclare >> queue: aValue [

	queue := aValue
]
