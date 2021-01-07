Class {
	#name : #Amqp091BasicDeliver,
	#superclass : #AmqpProtocolMethod,
	#instVars : [
		'consumerTag',
		'deliveryTag',
		'redelivered',
		'exchange',
		'routingKey'
	],
	#category : #'Ansible-Protocol-091'
}

{ #category : #'AMQP codec' }
Amqp091BasicDeliver >> acceptableResponseClasses [

	^ #()
]

{ #category : #'AMQP codec' }
Amqp091BasicDeliver >> codecMethodId [

	^ 3932220
]

{ #category : #accessing }
Amqp091BasicDeliver >> consumerTag [

	^ consumerTag
]

{ #category : #accessing }
Amqp091BasicDeliver >> consumerTag: aValue [

	consumerTag := aValue
]

{ #category : #'AMQP codec' }
Amqp091BasicDeliver >> decodeFrom: codec [

	| bitBuffer |

	consumerTag := codec nextShortstr.
	deliveryTag := codec nextLonglong.
	bitBuffer := codec nextOctet.
	redelivered := ( bitBuffer bitAnd: 1 ) ~= 0.
	exchange := codec nextShortstr.
	routingKey := codec nextShortstr
]

{ #category : #accessing }
Amqp091BasicDeliver >> deliveryTag [

	^ deliveryTag
]

{ #category : #accessing }
Amqp091BasicDeliver >> deliveryTag: aValue [

	deliveryTag := aValue
]

{ #category : #'AMQP codec' }
Amqp091BasicDeliver >> encodeOn: codec [

	| bitBuffer |

	codec nextShortstrPut: consumerTag.
	codec nextLonglongPut: deliveryTag.
	bitBuffer := 0.
	( redelivered ifNil: [ false ] )
		ifTrue: [ bitBuffer := bitBuffer bitOr: 1 ].
	codec nextOctetPut: bitBuffer.
	codec nextShortstrPut: exchange.
	codec nextShortstrPut: routingKey
]

{ #category : #accessing }
Amqp091BasicDeliver >> exchange [

	^ exchange
]

{ #category : #accessing }
Amqp091BasicDeliver >> exchange: aValue [

	exchange := aValue
]

{ #category : #'AMQP codec' }
Amqp091BasicDeliver >> hasContents [

	^ true
]

{ #category : #accessing }
Amqp091BasicDeliver >> redelivered [

	^ redelivered
]

{ #category : #accessing }
Amqp091BasicDeliver >> redelivered: aValue [

	redelivered := aValue
]

{ #category : #accessing }
Amqp091BasicDeliver >> routingKey [

	^ routingKey
]

{ #category : #accessing }
Amqp091BasicDeliver >> routingKey: aValue [

	routingKey := aValue
]
