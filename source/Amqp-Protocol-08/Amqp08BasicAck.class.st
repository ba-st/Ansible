Class {
	#name : #Amqp08BasicAck,
	#superclass : #AmqpProtocolMethod,
	#instVars : [
		'deliveryTag',
		'multiple'
	],
	#category : #'Amqp-Protocol-08'
}

{ #category : #'AMQP codec' }
Amqp08BasicAck >> acceptableResponseClasses [

	^ {}
]

{ #category : #'AMQP codec' }
Amqp08BasicAck >> codecMethodId [

	^ 3932240
]

{ #category : #'AMQP codec' }
Amqp08BasicAck >> decodeFrom: codec [

	| bitBuffer |

	deliveryTag := codec nextLonglong.
	bitBuffer := codec nextOctet.
	multiple := ( bitBuffer bitAnd: 1 ) ~= 0
]

{ #category : #accessing }
Amqp08BasicAck >> deliveryTag [

	^ deliveryTag
]

{ #category : #accessing }
Amqp08BasicAck >> deliveryTag: aValue [

	deliveryTag := aValue
]

{ #category : #'AMQP codec' }
Amqp08BasicAck >> encodeOn: codec [

	| bitBuffer |

	codec nextLonglongPut: deliveryTag.
	bitBuffer := 0.
	( multiple ifNil: [ false ] )
		ifTrue: [ bitBuffer := bitBuffer bitOr: 1 ].
	codec nextOctetPut: bitBuffer
]

{ #category : #'AMQP codec' }
Amqp08BasicAck >> hasContents [

	^ false
]

{ #category : #accessing }
Amqp08BasicAck >> multiple [

	^ multiple
]

{ #category : #accessing }
Amqp08BasicAck >> multiple: aValue [

	multiple := aValue
]
