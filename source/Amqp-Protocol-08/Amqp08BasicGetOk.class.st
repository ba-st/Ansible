Class {
	#name : #Amqp08BasicGetOk,
	#superclass : #AmqpProtocolMethod,
	#instVars : [
		'deliveryTag',
		'redelivered',
		'exchange',
		'routingKey',
		'messageCount'
	],
	#category : #'Amqp-Protocol-08'
}

{ #category : #'AMQP codec' }
Amqp08BasicGetOk >> acceptableResponseClasses [

	^ {}
]

{ #category : #'AMQP codec' }
Amqp08BasicGetOk >> codecMethodId [

	^ 3932231
]

{ #category : #'AMQP codec' }
Amqp08BasicGetOk >> decodeFrom: codec [

	| bitBuffer |

	deliveryTag := codec nextLonglong.
	bitBuffer := codec nextOctet.
	redelivered := ( bitBuffer bitAnd: 1 ) ~= 0.
	exchange := codec nextShortstr.
	routingKey := codec nextShortstr.
	messageCount := codec nextLong
]

{ #category : #accessing }
Amqp08BasicGetOk >> deliveryTag [

	^ deliveryTag
]

{ #category : #accessing }
Amqp08BasicGetOk >> deliveryTag: aValue [

	deliveryTag := aValue
]

{ #category : #'AMQP codec' }
Amqp08BasicGetOk >> encodeOn: codec [

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
Amqp08BasicGetOk >> exchange [

	^ exchange
]

{ #category : #accessing }
Amqp08BasicGetOk >> exchange: aValue [

	exchange := aValue
]

{ #category : #'AMQP codec' }
Amqp08BasicGetOk >> hasContents [

	^ true
]

{ #category : #accessing }
Amqp08BasicGetOk >> messageCount [

	^ messageCount
]

{ #category : #accessing }
Amqp08BasicGetOk >> messageCount: aValue [

	messageCount := aValue
]

{ #category : #accessing }
Amqp08BasicGetOk >> redelivered [

	^ redelivered
]

{ #category : #accessing }
Amqp08BasicGetOk >> redelivered: aValue [

	redelivered := aValue
]

{ #category : #accessing }
Amqp08BasicGetOk >> routingKey [

	^ routingKey
]

{ #category : #accessing }
Amqp08BasicGetOk >> routingKey: aValue [

	routingKey := aValue
]
