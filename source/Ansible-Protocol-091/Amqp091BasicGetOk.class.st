Class {
	#name : #Amqp091BasicGetOk,
	#superclass : #AmqpProtocolMethod,
	#instVars : [
		'deliveryTag',
		'redelivered',
		'exchange',
		'routingKey',
		'messageCount'
	],
	#category : #'Ansible-Protocol-091'
}

{ #category : #'AMQP codec' }
Amqp091BasicGetOk >> acceptableResponseClasses [

	^ {}
]

{ #category : #'AMQP codec' }
Amqp091BasicGetOk >> codecMethodId [

	^ 3932231
]

{ #category : #'AMQP codec' }
Amqp091BasicGetOk >> decodeFrom: codec [

	| bitBuffer |

	deliveryTag := codec nextLonglong.
	bitBuffer := codec nextOctet.
	redelivered := ( bitBuffer bitAnd: 1 ) ~= 0.
	exchange := codec nextShortstr.
	routingKey := codec nextShortstr.
	messageCount := codec nextLong
]

{ #category : #accessing }
Amqp091BasicGetOk >> deliveryTag [

	^ deliveryTag
]

{ #category : #accessing }
Amqp091BasicGetOk >> deliveryTag: aValue [

	deliveryTag := aValue
]

{ #category : #'AMQP codec' }
Amqp091BasicGetOk >> encodeOn: codec [

	| bitBuffer |

	codec nextLonglongPut: deliveryTag.
	bitBuffer := 0.
	( redelivered ifNil: [ false ] )
		ifTrue: [ bitBuffer := bitBuffer bitOr: 1 ].
	codec nextOctetPut: bitBuffer.
	codec nextShortstrPut: exchange.
	codec nextShortstrPut: routingKey.
	codec nextLongPut: messageCount
]

{ #category : #accessing }
Amqp091BasicGetOk >> exchange [

	^ exchange
]

{ #category : #accessing }
Amqp091BasicGetOk >> exchange: aValue [

	exchange := aValue
]

{ #category : #'AMQP codec' }
Amqp091BasicGetOk >> hasContents [

	^ true
]

{ #category : #accessing }
Amqp091BasicGetOk >> messageCount [

	^ messageCount
]

{ #category : #accessing }
Amqp091BasicGetOk >> messageCount: aValue [

	messageCount := aValue
]

{ #category : #accessing }
Amqp091BasicGetOk >> redelivered [

	^ redelivered
]

{ #category : #accessing }
Amqp091BasicGetOk >> redelivered: aValue [

	redelivered := aValue
]

{ #category : #accessing }
Amqp091BasicGetOk >> routingKey [

	^ routingKey
]

{ #category : #accessing }
Amqp091BasicGetOk >> routingKey: aValue [

	routingKey := aValue
]
