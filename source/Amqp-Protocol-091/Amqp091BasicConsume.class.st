Class {
	#name : #Amqp091BasicConsume,
	#superclass : #AmqpProtocolMethod,
	#instVars : [
		'queue',
		'consumerTag',
		'noLocal',
		'noAck',
		'exclusive',
		'noWait',
		'arguments'
	],
	#category : #'Amqp-Protocol-091'
}

{ #category : #'AMQP codec' }
Amqp091BasicConsume >> acceptableResponseClasses [

	^ {Amqp091BasicConsumeOk}
]

{ #category : #accessing }
Amqp091BasicConsume >> arguments [

	^ arguments
]

{ #category : #accessing }
Amqp091BasicConsume >> arguments: aValue [

	arguments := aValue
]

{ #category : #'AMQP codec' }
Amqp091BasicConsume >> codecMethodId [

	^ 3932180
]

{ #category : #accessing }
Amqp091BasicConsume >> consumerTag [

	^ consumerTag
]

{ #category : #accessing }
Amqp091BasicConsume >> consumerTag: aValue [

	consumerTag := aValue
]

{ #category : #'AMQP codec' }
Amqp091BasicConsume >> decodeFrom: codec [

	| bitBuffer |

	codec nextShort.
	queue := codec nextShortstr.
	consumerTag := codec nextShortstr.
	bitBuffer := codec nextOctet.
	noLocal := ( bitBuffer bitAnd: 1 ) ~= 0.
	noAck := ( bitBuffer bitAnd: 2 ) ~= 0.
	exclusive := ( bitBuffer bitAnd: 4 ) ~= 0.
	noWait := ( bitBuffer bitAnd: 8 ) ~= 0.
	arguments := codec nextTable
]

{ #category : #'AMQP codec' }
Amqp091BasicConsume >> encodeOn: codec [

	| bitBuffer |

	codec nextShortPut: 0.
	codec nextShortstrPut: queue.
	codec nextShortstrPut: consumerTag.
	bitBuffer := 0.
	( noLocal ifNil: [ false ] )
		ifTrue: [ bitBuffer := bitBuffer bitOr: 1 ].
	( noAck ifNil: [ false ] )
		ifTrue: [ bitBuffer := bitBuffer bitOr: 2 ].
	( exclusive ifNil: [ false ] )
		ifTrue: [ bitBuffer := bitBuffer bitOr: 4 ].
	( noWait ifNil: [ false ] )
		ifTrue: [ bitBuffer := bitBuffer bitOr: 8 ].
	codec nextOctetPut: bitBuffer.
	codec nextTablePut: arguments
]

{ #category : #accessing }
Amqp091BasicConsume >> exclusive [

	^ exclusive
]

{ #category : #accessing }
Amqp091BasicConsume >> exclusive: aValue [

	exclusive := aValue
]

{ #category : #'AMQP codec' }
Amqp091BasicConsume >> hasContents [

	^ false
]

{ #category : #accessing }
Amqp091BasicConsume >> noAck [

	^ noAck
]

{ #category : #accessing }
Amqp091BasicConsume >> noAck: aValue [

	noAck := aValue
]

{ #category : #accessing }
Amqp091BasicConsume >> noLocal [

	^ noLocal
]

{ #category : #accessing }
Amqp091BasicConsume >> noLocal: aValue [

	noLocal := aValue
]

{ #category : #accessing }
Amqp091BasicConsume >> noWait [

	^ noWait
]

{ #category : #accessing }
Amqp091BasicConsume >> noWait: aValue [

	noWait := aValue
]

{ #category : #accessing }
Amqp091BasicConsume >> queue [

	^ queue
]

{ #category : #accessing }
Amqp091BasicConsume >> queue: aValue [

	queue := aValue
]
