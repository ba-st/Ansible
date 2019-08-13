Class {
	#name : #Amqp091QueueUnbind,
	#superclass : #AmqpProtocolMethod,
	#instVars : [
		'queue',
		'exchange',
		'routingKey',
		'arguments'
	],
	#category : #'Amqp-Protocol-091'
}

{ #category : #'AMQP codec' }
Amqp091QueueUnbind >> acceptableResponseClasses [

	^ {Amqp091QueueUnbindOk}
]

{ #category : #accessing }
Amqp091QueueUnbind >> arguments [

	^ arguments
]

{ #category : #accessing }
Amqp091QueueUnbind >> arguments: aValue [

	arguments := aValue
]

{ #category : #'AMQP codec' }
Amqp091QueueUnbind >> codecMethodId [

	^ 3276850
]

{ #category : #'AMQP codec' }
Amqp091QueueUnbind >> decodeFrom: codec [

	| bitBuffer |

	codec nextShort.
	queue := codec nextShortstr.
	exchange := codec nextShortstr.
	routingKey := codec nextShortstr.
	arguments := codec nextTable
]

{ #category : #'AMQP codec' }
Amqp091QueueUnbind >> encodeOn: codec [

	| bitBuffer |

	codec nextShortPut: 0.
	codec nextShortstrPut: queue.
	codec nextShortstrPut: exchange.
	codec nextShortstrPut: routingKey.
	codec nextTablePut: arguments
]

{ #category : #accessing }
Amqp091QueueUnbind >> exchange [

	^ exchange
]

{ #category : #accessing }
Amqp091QueueUnbind >> exchange: aValue [

	exchange := aValue
]

{ #category : #'AMQP codec' }
Amqp091QueueUnbind >> hasContents [

	^ false
]

{ #category : #accessing }
Amqp091QueueUnbind >> queue [

	^ queue
]

{ #category : #accessing }
Amqp091QueueUnbind >> queue: aValue [

	queue := aValue
]

{ #category : #accessing }
Amqp091QueueUnbind >> routingKey [

	^ routingKey
]

{ #category : #accessing }
Amqp091QueueUnbind >> routingKey: aValue [

	routingKey := aValue
]
