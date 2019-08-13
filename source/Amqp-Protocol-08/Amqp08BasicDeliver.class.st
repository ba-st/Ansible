Class {
	#name : #Amqp08BasicDeliver,
	#superclass : #AmqpProtocolMethod,
	#instVars : [
		'consumerTag',
		'deliveryTag',
		'redelivered',
		'exchange',
		'routingKey'
	],
	#category : #'Amqp-Protocol-08'
}

{ #category : #'AMQP codec' }
Amqp08BasicDeliver >> acceptableResponseClasses [

	^ {}
]

{ #category : #'AMQP codec' }
Amqp08BasicDeliver >> codecMethodId [

	^ 3932220
]

{ #category : #accessing }
Amqp08BasicDeliver >> consumerTag [

	^ consumerTag
]

{ #category : #accessing }
Amqp08BasicDeliver >> consumerTag: aValue [

	consumerTag := aValue
]

{ #category : #'AMQP codec' }
Amqp08BasicDeliver >> decodeFrom: codec [

	| bitBuffer |

	consumerTag := codec nextShortstr.
	deliveryTag := codec nextLonglong.
	bitBuffer := codec nextOctet.
	redelivered := ( bitBuffer bitAnd: 1 ) ~= 0.
	exchange := codec nextShortstr.
	routingKey := codec nextShortstr
]

{ #category : #accessing }
Amqp08BasicDeliver >> deliveryTag [

	^ deliveryTag
]

{ #category : #accessing }
Amqp08BasicDeliver >> deliveryTag: aValue [

	deliveryTag := aValue
]

{ #category : #'AMQP codec' }
Amqp08BasicDeliver >> encodeOn: codec [

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
Amqp08BasicDeliver >> exchange [

	^ exchange
]

{ #category : #accessing }
Amqp08BasicDeliver >> exchange: aValue [

	exchange := aValue
]

{ #category : #'AMQP codec' }
Amqp08BasicDeliver >> hasContents [

	^ true
]

{ #category : #accessing }
Amqp08BasicDeliver >> redelivered [

	^ redelivered
]

{ #category : #accessing }
Amqp08BasicDeliver >> redelivered: aValue [

	redelivered := aValue
]

{ #category : #accessing }
Amqp08BasicDeliver >> routingKey [

	^ routingKey
]

{ #category : #accessing }
Amqp08BasicDeliver >> routingKey: aValue [

	routingKey := aValue
]
