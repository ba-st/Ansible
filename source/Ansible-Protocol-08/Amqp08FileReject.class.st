Class {
	#name : #Amqp08FileReject,
	#superclass : #AmqpProtocolMethod,
	#instVars : [
		'deliveryTag',
		'requeue'
	],
	#category : #'Ansible-Protocol-08'
}

{ #category : #'AMQP codec' }
Amqp08FileReject >> acceptableResponseClasses [

	^ {}
]

{ #category : #'AMQP codec' }
Amqp08FileReject >> codecMethodId [

	^ 4587620
]

{ #category : #'AMQP codec' }
Amqp08FileReject >> decodeFrom: codec [

	| bitBuffer |

	deliveryTag := codec nextLonglong.
	bitBuffer := codec nextOctet.
	requeue := ( bitBuffer bitAnd: 1 ) ~= 0
]

{ #category : #accessing }
Amqp08FileReject >> deliveryTag [

	^ deliveryTag
]

{ #category : #accessing }
Amqp08FileReject >> deliveryTag: aValue [

	deliveryTag := aValue
]

{ #category : #'AMQP codec' }
Amqp08FileReject >> encodeOn: codec [

	| bitBuffer |

	codec nextLonglongPut: deliveryTag.
	bitBuffer := 0.
	( requeue ifNil: [ false ] )
		ifTrue: [ bitBuffer := bitBuffer bitOr: 1 ].
	codec nextOctetPut: bitBuffer
]

{ #category : #'AMQP codec' }
Amqp08FileReject >> hasContents [

	^ false
]

{ #category : #accessing }
Amqp08FileReject >> requeue [

	^ requeue
]

{ #category : #accessing }
Amqp08FileReject >> requeue: aValue [

	requeue := aValue
]
