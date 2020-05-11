Class {
	#name : #Amqp08StreamConsume,
	#superclass : #AmqpProtocolMethod,
	#instVars : [
		'ticket',
		'queue',
		'consumerTag',
		'noLocal',
		'exclusive',
		'nowait'
	],
	#category : #'Ansible-Protocol-08'
}

{ #category : #'AMQP codec' }
Amqp08StreamConsume >> acceptableResponseClasses [

	^ {Amqp08StreamConsumeOk}
]

{ #category : #'AMQP codec' }
Amqp08StreamConsume >> codecMethodId [

	^ 5242900
]

{ #category : #accessing }
Amqp08StreamConsume >> consumerTag [

	^ consumerTag
]

{ #category : #accessing }
Amqp08StreamConsume >> consumerTag: aValue [

	consumerTag := aValue
]

{ #category : #'AMQP codec' }
Amqp08StreamConsume >> decodeFrom: codec [

	| bitBuffer |

	ticket := codec nextShort.
	queue := codec nextShortstr.
	consumerTag := codec nextShortstr.
	bitBuffer := codec nextOctet.
	noLocal := ( bitBuffer bitAnd: 1 ) ~= 0.
	exclusive := ( bitBuffer bitAnd: 2 ) ~= 0.
	nowait := ( bitBuffer bitAnd: 4 ) ~= 0
]

{ #category : #'AMQP codec' }
Amqp08StreamConsume >> encodeOn: codec [

	| bitBuffer |

	codec nextShortPut: ticket.
	codec nextShortstrPut: queue.
	codec nextShortstrPut: consumerTag.
	bitBuffer := 0.
	( noLocal ifNil: [ false ] )
		ifTrue: [ bitBuffer := bitBuffer bitOr: 1 ].
	( exclusive ifNil: [ false ] )
		ifTrue: [ bitBuffer := bitBuffer bitOr: 2 ].
	( nowait ifNil: [ false ] )
		ifTrue: [ bitBuffer := bitBuffer bitOr: 4 ].
	codec nextOctetPut: bitBuffer
]

{ #category : #accessing }
Amqp08StreamConsume >> exclusive [

	^ exclusive
]

{ #category : #accessing }
Amqp08StreamConsume >> exclusive: aValue [

	exclusive := aValue
]

{ #category : #'AMQP codec' }
Amqp08StreamConsume >> hasContents [

	^ false
]

{ #category : #accessing }
Amqp08StreamConsume >> noLocal [

	^ noLocal
]

{ #category : #accessing }
Amqp08StreamConsume >> noLocal: aValue [

	noLocal := aValue
]

{ #category : #accessing }
Amqp08StreamConsume >> nowait [

	^ nowait
]

{ #category : #accessing }
Amqp08StreamConsume >> nowait: aValue [

	nowait := aValue
]

{ #category : #accessing }
Amqp08StreamConsume >> queue [

	^ queue
]

{ #category : #accessing }
Amqp08StreamConsume >> queue: aValue [

	queue := aValue
]

{ #category : #accessing }
Amqp08StreamConsume >> ticket [

	^ ticket
]

{ #category : #accessing }
Amqp08StreamConsume >> ticket: aValue [

	ticket := aValue
]
