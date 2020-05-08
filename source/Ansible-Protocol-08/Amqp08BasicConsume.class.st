Class {
	#name : #Amqp08BasicConsume,
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
	#category : #'Ansible-Protocol-08'
}

{ #category : #'AMQP codec' }
Amqp08BasicConsume >> acceptableResponseClasses [

	^ {Amqp08BasicConsumeOk}
]

{ #category : #'AMQP codec' }
Amqp08BasicConsume >> codecMethodId [

	^ 3932180
]

{ #category : #accessing }
Amqp08BasicConsume >> consumerTag [

	^ consumerTag
]

{ #category : #accessing }
Amqp08BasicConsume >> consumerTag: aValue [

	consumerTag := aValue
]

{ #category : #'AMQP codec' }
Amqp08BasicConsume >> decodeFrom: codec [

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
Amqp08BasicConsume >> encodeOn: codec [

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
Amqp08BasicConsume >> exclusive [

	^ exclusive
]

{ #category : #accessing }
Amqp08BasicConsume >> exclusive: aValue [

	exclusive := aValue
]

{ #category : #'AMQP codec' }
Amqp08BasicConsume >> hasContents [

	^ false
]

{ #category : #accessing }
Amqp08BasicConsume >> noAck [

	^ noAck
]

{ #category : #accessing }
Amqp08BasicConsume >> noAck: aValue [

	noAck := aValue
]

{ #category : #accessing }
Amqp08BasicConsume >> noLocal [

	^ noLocal
]

{ #category : #accessing }
Amqp08BasicConsume >> noLocal: aValue [

	noLocal := aValue
]

{ #category : #accessing }
Amqp08BasicConsume >> nowait [

	^ nowait
]

{ #category : #accessing }
Amqp08BasicConsume >> nowait: aValue [

	nowait := aValue
]

{ #category : #accessing }
Amqp08BasicConsume >> queue [

	^ queue
]

{ #category : #accessing }
Amqp08BasicConsume >> queue: aValue [

	queue := aValue
]

{ #category : #accessing }
Amqp08BasicConsume >> ticket [

	^ ticket
]

{ #category : #accessing }
Amqp08BasicConsume >> ticket: aValue [

	ticket := aValue
]
