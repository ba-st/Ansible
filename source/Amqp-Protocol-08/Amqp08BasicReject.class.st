Class {
	#name : #Amqp08BasicReject,
	#superclass : #AmqpProtocolMethod,
	#instVars : [
		'deliveryTag',
		'requeue'
	],
	#category : #'Amqp-Protocol-08'
}

{ #category : #'AMQP codec' }
Amqp08BasicReject >> acceptableResponseClasses [

	^ {}
]

{ #category : #'AMQP codec' }
Amqp08BasicReject >> codecMethodId [

	^ 3932250
]

{ #category : #'AMQP codec' }
Amqp08BasicReject >> decodeFrom: codec [

	| bitBuffer |

	deliveryTag := codec nextLonglong.
	bitBuffer := codec nextOctet.
	requeue := ( bitBuffer bitAnd: 1 ) ~= 0
]

{ #category : #accessing }
Amqp08BasicReject >> deliveryTag [

	^ deliveryTag
]

{ #category : #accessing }
Amqp08BasicReject >> deliveryTag: aValue [

	deliveryTag := aValue
]

{ #category : #'AMQP codec' }
Amqp08BasicReject >> encodeOn: codec [

	| bitBuffer |

	codec nextLonglongPut: deliveryTag.
	bitBuffer := 0.
	( requeue ifNil: [ false ] )
		ifTrue: [ bitBuffer := bitBuffer bitOr: 1 ].
	codec nextOctetPut: bitBuffer
]

{ #category : #'AMQP codec' }
Amqp08BasicReject >> hasContents [

	^ false
]

{ #category : #accessing }
Amqp08BasicReject >> requeue [

	^ requeue
]

{ #category : #accessing }
Amqp08BasicReject >> requeue: aValue [

	requeue := aValue
]
