Class {
	#name : #Amqp08QueueDeclare,
	#superclass : #AmqpProtocolMethod,
	#instVars : [
		'ticket',
		'queue',
		'passive',
		'durable',
		'exclusive',
		'autoDelete',
		'nowait',
		'arguments'
	],
	#category : #'Ansible-Protocol-08'
}

{ #category : #'AMQP codec' }
Amqp08QueueDeclare >> acceptableResponseClasses [

	^ {Amqp08QueueDeclareOk}
]

{ #category : #accessing }
Amqp08QueueDeclare >> arguments [

	^ arguments
]

{ #category : #accessing }
Amqp08QueueDeclare >> arguments: aValue [

	arguments := aValue
]

{ #category : #accessing }
Amqp08QueueDeclare >> autoDelete [

	^ autoDelete
]

{ #category : #accessing }
Amqp08QueueDeclare >> autoDelete: aValue [

	autoDelete := aValue
]

{ #category : #'AMQP codec' }
Amqp08QueueDeclare >> codecMethodId [

	^ 3276810
]

{ #category : #'AMQP codec' }
Amqp08QueueDeclare >> decodeFrom: codec [

	| bitBuffer |

	ticket := codec nextShort.
	queue := codec nextShortstr.
	bitBuffer := codec nextOctet.
	passive := ( bitBuffer bitAnd: 1 ) ~= 0.
	durable := ( bitBuffer bitAnd: 2 ) ~= 0.
	exclusive := ( bitBuffer bitAnd: 4 ) ~= 0.
	autoDelete := ( bitBuffer bitAnd: 8 ) ~= 0.
	nowait := ( bitBuffer bitAnd: 16 ) ~= 0.
	arguments := codec nextTable
]

{ #category : #accessing }
Amqp08QueueDeclare >> durable [

	^ durable
]

{ #category : #accessing }
Amqp08QueueDeclare >> durable: aValue [

	durable := aValue
]

{ #category : #'AMQP codec' }
Amqp08QueueDeclare >> encodeOn: codec [

	| bitBuffer |

	codec nextShortPut: ticket.
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
	( nowait ifNil: [ false ] )
		ifTrue: [ bitBuffer := bitBuffer bitOr: 16 ].
	codec nextOctetPut: bitBuffer.
	codec nextTablePut: arguments
]

{ #category : #accessing }
Amqp08QueueDeclare >> exclusive [

	^ exclusive
]

{ #category : #accessing }
Amqp08QueueDeclare >> exclusive: aValue [

	exclusive := aValue
]

{ #category : #'AMQP codec' }
Amqp08QueueDeclare >> hasContents [

	^ false
]

{ #category : #accessing }
Amqp08QueueDeclare >> nowait [

	^ nowait
]

{ #category : #accessing }
Amqp08QueueDeclare >> nowait: aValue [

	nowait := aValue
]

{ #category : #accessing }
Amqp08QueueDeclare >> passive [

	^ passive
]

{ #category : #accessing }
Amqp08QueueDeclare >> passive: aValue [

	passive := aValue
]

{ #category : #accessing }
Amqp08QueueDeclare >> queue [

	^ queue
]

{ #category : #accessing }
Amqp08QueueDeclare >> queue: aValue [

	queue := aValue
]

{ #category : #accessing }
Amqp08QueueDeclare >> ticket [

	^ ticket
]

{ #category : #accessing }
Amqp08QueueDeclare >> ticket: aValue [

	ticket := aValue
]
