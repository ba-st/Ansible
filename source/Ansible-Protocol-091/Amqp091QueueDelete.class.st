Class {
	#name : #Amqp091QueueDelete,
	#superclass : #AmqpProtocolMethod,
	#instVars : [
		'queue',
		'ifUnused',
		'ifEmpty',
		'noWait'
	],
	#category : #'Ansible-Protocol-091'
}

{ #category : #'AMQP codec' }
Amqp091QueueDelete >> acceptableResponseClasses [

	^ {Amqp091QueueDeleteOk}
]

{ #category : #'AMQP codec' }
Amqp091QueueDelete >> codecMethodId [

	^ 3276840
]

{ #category : #'AMQP codec' }
Amqp091QueueDelete >> decodeFrom: codec [

	| bitBuffer |

	codec nextShort.
	queue := codec nextShortstr.
	bitBuffer := codec nextOctet.
	ifUnused := ( bitBuffer bitAnd: 1 ) ~= 0.
	ifEmpty := ( bitBuffer bitAnd: 2 ) ~= 0.
	noWait := ( bitBuffer bitAnd: 4 ) ~= 0
]

{ #category : #'AMQP codec' }
Amqp091QueueDelete >> encodeOn: codec [

	| bitBuffer |

	codec nextShortPut: 0.
	codec nextShortstrPut: queue.
	bitBuffer := 0.
	( ifUnused ifNil: [ false ] )
		ifTrue: [ bitBuffer := bitBuffer bitOr: 1 ].
	( ifEmpty ifNil: [ false ] )
		ifTrue: [ bitBuffer := bitBuffer bitOr: 2 ].
	( noWait ifNil: [ false ] )
		ifTrue: [ bitBuffer := bitBuffer bitOr: 4 ].
	codec nextOctetPut: bitBuffer
]

{ #category : #'AMQP codec' }
Amqp091QueueDelete >> hasContents [

	^ false
]

{ #category : #accessing }
Amqp091QueueDelete >> ifEmpty [

	^ ifEmpty
]

{ #category : #accessing }
Amqp091QueueDelete >> ifEmpty: aValue [

	ifEmpty := aValue
]

{ #category : #accessing }
Amqp091QueueDelete >> ifUnused [

	^ ifUnused
]

{ #category : #accessing }
Amqp091QueueDelete >> ifUnused: aValue [

	ifUnused := aValue
]

{ #category : #accessing }
Amqp091QueueDelete >> noWait [

	^ noWait
]

{ #category : #accessing }
Amqp091QueueDelete >> noWait: aValue [

	noWait := aValue
]

{ #category : #accessing }
Amqp091QueueDelete >> queue [

	^ queue
]

{ #category : #accessing }
Amqp091QueueDelete >> queue: aValue [

	queue := aValue
]
