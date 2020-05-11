Class {
	#name : #Amqp091BasicAck,
	#superclass : #AmqpProtocolMethod,
	#instVars : [
		'deliveryTag',
		'multiple'
	],
	#category : #'Ansible-Protocol-091'
}

{ #category : #'AMQP codec' }
Amqp091BasicAck >> acceptableResponseClasses [

	^ {}
]

{ #category : #'AMQP codec' }
Amqp091BasicAck >> codecMethodId [

	^ 3932240
]

{ #category : #'AMQP codec' }
Amqp091BasicAck >> decodeFrom: codec [

	| bitBuffer |

	deliveryTag := codec nextLonglong.
	bitBuffer := codec nextOctet.
	multiple := ( bitBuffer bitAnd: 1 ) ~= 0
]

{ #category : #accessing }
Amqp091BasicAck >> deliveryTag [

	^ deliveryTag
]

{ #category : #accessing }
Amqp091BasicAck >> deliveryTag: aValue [

	deliveryTag := aValue
]

{ #category : #'AMQP codec' }
Amqp091BasicAck >> encodeOn: codec [

	| bitBuffer |

	codec nextLonglongPut: deliveryTag.
	bitBuffer := 0.
	( multiple ifNil: [ false ] )
		ifTrue: [ bitBuffer := bitBuffer bitOr: 1 ].
	codec nextOctetPut: bitBuffer
]

{ #category : #'AMQP codec' }
Amqp091BasicAck >> hasContents [

	^ false
]

{ #category : #accessing }
Amqp091BasicAck >> multiple [

	^ multiple
]

{ #category : #accessing }
Amqp091BasicAck >> multiple: aValue [

	multiple := aValue
]
