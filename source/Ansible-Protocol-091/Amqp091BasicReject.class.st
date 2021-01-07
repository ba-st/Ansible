Class {
	#name : #Amqp091BasicReject,
	#superclass : #AmqpProtocolMethod,
	#instVars : [
		'deliveryTag',
		'requeue'
	],
	#category : #'Ansible-Protocol-091'
}

{ #category : #'AMQP codec' }
Amqp091BasicReject >> acceptableResponseClasses [

	^ #()
]

{ #category : #'AMQP codec' }
Amqp091BasicReject >> codecMethodId [

	^ 3932250
]

{ #category : #'AMQP codec' }
Amqp091BasicReject >> decodeFrom: codec [

	| bitBuffer |

	deliveryTag := codec nextLonglong.
	bitBuffer := codec nextOctet.
	requeue := ( bitBuffer bitAnd: 1 ) ~= 0
]

{ #category : #accessing }
Amqp091BasicReject >> deliveryTag [

	^ deliveryTag
]

{ #category : #accessing }
Amqp091BasicReject >> deliveryTag: aValue [

	deliveryTag := aValue
]

{ #category : #'AMQP codec' }
Amqp091BasicReject >> encodeOn: codec [

	| bitBuffer |

	codec nextLonglongPut: deliveryTag.
	bitBuffer := 0.
	( requeue ifNil: [ false ] )
		ifTrue: [ bitBuffer := bitBuffer bitOr: 1 ].
	codec nextOctetPut: bitBuffer
]

{ #category : #'AMQP codec' }
Amqp091BasicReject >> hasContents [

	^ false
]

{ #category : #accessing }
Amqp091BasicReject >> requeue [

	^ requeue
]

{ #category : #accessing }
Amqp091BasicReject >> requeue: aValue [

	requeue := aValue
]
