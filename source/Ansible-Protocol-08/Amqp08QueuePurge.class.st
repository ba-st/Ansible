Class {
	#name : #Amqp08QueuePurge,
	#superclass : #AmqpProtocolMethod,
	#instVars : [
		'ticket',
		'queue',
		'nowait'
	],
	#category : #'Ansible-Protocol-08'
}

{ #category : #'AMQP codec' }
Amqp08QueuePurge >> acceptableResponseClasses [

	^ {Amqp08QueuePurgeOk}
]

{ #category : #'AMQP codec' }
Amqp08QueuePurge >> codecMethodId [

	^ 3276830
]

{ #category : #'AMQP codec' }
Amqp08QueuePurge >> decodeFrom: codec [

	| bitBuffer |

	ticket := codec nextShort.
	queue := codec nextShortstr.
	bitBuffer := codec nextOctet.
	nowait := ( bitBuffer bitAnd: 1 ) ~= 0
]

{ #category : #'AMQP codec' }
Amqp08QueuePurge >> encodeOn: codec [

	| bitBuffer |

	codec nextShortPut: ticket.
	codec nextShortstrPut: queue.
	bitBuffer := 0.
	( nowait ifNil: [ false ] )
		ifTrue: [ bitBuffer := bitBuffer bitOr: 1 ].
	codec nextOctetPut: bitBuffer
]

{ #category : #'AMQP codec' }
Amqp08QueuePurge >> hasContents [

	^ false
]

{ #category : #accessing }
Amqp08QueuePurge >> nowait [

	^ nowait
]

{ #category : #accessing }
Amqp08QueuePurge >> nowait: aValue [

	nowait := aValue
]

{ #category : #accessing }
Amqp08QueuePurge >> queue [

	^ queue
]

{ #category : #accessing }
Amqp08QueuePurge >> queue: aValue [

	queue := aValue
]

{ #category : #accessing }
Amqp08QueuePurge >> ticket [

	^ ticket
]

{ #category : #accessing }
Amqp08QueuePurge >> ticket: aValue [

	ticket := aValue
]
