Class {
	#name : #Amqp091QueuePurge,
	#superclass : #AmqpProtocolMethod,
	#instVars : [
		'queue',
		'noWait'
	],
	#category : #'Ansible-Protocol-091'
}

{ #category : #'AMQP codec' }
Amqp091QueuePurge >> acceptableResponseClasses [

	^ Array with: Amqp091QueuePurgeOk
]

{ #category : #'AMQP codec' }
Amqp091QueuePurge >> codecMethodId [

	^ 3276830
]

{ #category : #'AMQP codec' }
Amqp091QueuePurge >> decodeFrom: codec [

	| bitBuffer |

	codec nextShort.
	queue := codec nextShortstr.
	bitBuffer := codec nextOctet.
	noWait := ( bitBuffer bitAnd: 1 ) ~= 0
]

{ #category : #'AMQP codec' }
Amqp091QueuePurge >> encodeOn: codec [

	| bitBuffer |

	codec nextShortPut: 0.
	codec nextShortstrPut: queue.
	bitBuffer := 0.
	( noWait ifNil: [ false ] )
		ifTrue: [ bitBuffer := bitBuffer bitOr: 1 ].
	codec nextOctetPut: bitBuffer
]

{ #category : #'AMQP codec' }
Amqp091QueuePurge >> hasContents [

	^ false
]

{ #category : #accessing }
Amqp091QueuePurge >> noWait [

	^ noWait
]

{ #category : #accessing }
Amqp091QueuePurge >> noWait: aValue [

	noWait := aValue
]

{ #category : #accessing }
Amqp091QueuePurge >> queue [

	^ queue
]

{ #category : #accessing }
Amqp091QueuePurge >> queue: aValue [

	queue := aValue
]
