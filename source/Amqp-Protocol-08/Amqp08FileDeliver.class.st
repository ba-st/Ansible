Class {
	#name : #Amqp08FileDeliver,
	#superclass : #AmqpProtocolMethod,
	#instVars : [
		'consumerTag',
		'deliveryTag',
		'redelivered',
		'exchange',
		'routingKey',
		'identifier'
	],
	#category : #'Amqp-Protocol-08'
}

{ #category : #'AMQP codec' }
Amqp08FileDeliver >> acceptableResponseClasses [

	^ {}
]

{ #category : #'AMQP codec' }
Amqp08FileDeliver >> codecMethodId [

	^ 4587600
]

{ #category : #accessing }
Amqp08FileDeliver >> consumerTag [

	^ consumerTag
]

{ #category : #accessing }
Amqp08FileDeliver >> consumerTag: aValue [

	consumerTag := aValue
]

{ #category : #'AMQP codec' }
Amqp08FileDeliver >> decodeFrom: codec [

	| bitBuffer |

	consumerTag := codec nextShortstr.
	deliveryTag := codec nextLonglong.
	bitBuffer := codec nextOctet.
	redelivered := ( bitBuffer bitAnd: 1 ) ~= 0.
	exchange := codec nextShortstr.
	routingKey := codec nextShortstr.
	identifier := codec nextShortstr
]

{ #category : #accessing }
Amqp08FileDeliver >> deliveryTag [

	^ deliveryTag
]

{ #category : #accessing }
Amqp08FileDeliver >> deliveryTag: aValue [

	deliveryTag := aValue
]

{ #category : #'AMQP codec' }
Amqp08FileDeliver >> encodeOn: codec [

	| bitBuffer |

	codec nextShortstrPut: consumerTag.
	codec nextLonglongPut: deliveryTag.
	bitBuffer := 0.
	( redelivered ifNil: [ false ] )
		ifTrue: [ bitBuffer := bitBuffer bitOr: 1 ].
	codec nextOctetPut: bitBuffer.
	codec nextShortstrPut: exchange.
	codec nextShortstrPut: routingKey.
	codec nextShortstrPut: identifier
]

{ #category : #accessing }
Amqp08FileDeliver >> exchange [

	^ exchange
]

{ #category : #accessing }
Amqp08FileDeliver >> exchange: aValue [

	exchange := aValue
]

{ #category : #'AMQP codec' }
Amqp08FileDeliver >> hasContents [

	^ false
]

{ #category : #accessing }
Amqp08FileDeliver >> identifier [

	^ identifier
]

{ #category : #accessing }
Amqp08FileDeliver >> identifier: aValue [

	identifier := aValue
]

{ #category : #accessing }
Amqp08FileDeliver >> redelivered [

	^ redelivered
]

{ #category : #accessing }
Amqp08FileDeliver >> redelivered: aValue [

	redelivered := aValue
]

{ #category : #accessing }
Amqp08FileDeliver >> routingKey [

	^ routingKey
]

{ #category : #accessing }
Amqp08FileDeliver >> routingKey: aValue [

	routingKey := aValue
]
