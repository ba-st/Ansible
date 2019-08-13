Class {
	#name : #Amqp08QueueDelete,
	#superclass : #AmqpProtocolMethod,
	#instVars : [
		'ticket',
		'queue',
		'ifUnused',
		'ifEmpty',
		'nowait'
	],
	#category : #'Amqp-Protocol-08'
}

{ #category : #'AMQP codec' }
Amqp08QueueDelete >> acceptableResponseClasses [

	^ {Amqp08QueueDeleteOk}
]

{ #category : #'AMQP codec' }
Amqp08QueueDelete >> codecMethodId [

	^ 3276840
]

{ #category : #'AMQP codec' }
Amqp08QueueDelete >> decodeFrom: codec [

	| bitBuffer |

	ticket := codec nextShort.
	queue := codec nextShortstr.
	bitBuffer := codec nextOctet.
	ifUnused := ( bitBuffer bitAnd: 1 ) ~= 0.
	ifEmpty := ( bitBuffer bitAnd: 2 ) ~= 0.
	nowait := ( bitBuffer bitAnd: 4 ) ~= 0
]

{ #category : #'AMQP codec' }
Amqp08QueueDelete >> encodeOn: codec [

	| bitBuffer |

	codec nextShortPut: ticket.
	codec nextShortstrPut: queue.
	bitBuffer := 0.
	( ifUnused ifNil: [ false ] )
		ifTrue: [ bitBuffer := bitBuffer bitOr: 1 ].
	( ifEmpty ifNil: [ false ] )
		ifTrue: [ bitBuffer := bitBuffer bitOr: 2 ].
	( nowait ifNil: [ false ] )
		ifTrue: [ bitBuffer := bitBuffer bitOr: 4 ].
	codec nextOctetPut: bitBuffer
]

{ #category : #'AMQP codec' }
Amqp08QueueDelete >> hasContents [

	^ false
]

{ #category : #accessing }
Amqp08QueueDelete >> ifEmpty [

	^ ifEmpty
]

{ #category : #accessing }
Amqp08QueueDelete >> ifEmpty: aValue [

	ifEmpty := aValue
]

{ #category : #accessing }
Amqp08QueueDelete >> ifUnused [

	^ ifUnused
]

{ #category : #accessing }
Amqp08QueueDelete >> ifUnused: aValue [

	ifUnused := aValue
]

{ #category : #accessing }
Amqp08QueueDelete >> nowait [

	^ nowait
]

{ #category : #accessing }
Amqp08QueueDelete >> nowait: aValue [

	nowait := aValue
]

{ #category : #accessing }
Amqp08QueueDelete >> queue [

	^ queue
]

{ #category : #accessing }
Amqp08QueueDelete >> queue: aValue [

	queue := aValue
]

{ #category : #accessing }
Amqp08QueueDelete >> ticket [

	^ ticket
]

{ #category : #accessing }
Amqp08QueueDelete >> ticket: aValue [

	ticket := aValue
]
