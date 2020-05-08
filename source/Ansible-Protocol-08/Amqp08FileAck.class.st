Class {
	#name : #Amqp08FileAck,
	#superclass : #AmqpProtocolMethod,
	#instVars : [
		'deliveryTag',
		'multiple'
	],
	#category : #'Ansible-Protocol-08'
}

{ #category : #'AMQP codec' }
Amqp08FileAck >> acceptableResponseClasses [

	^ {}
]

{ #category : #'AMQP codec' }
Amqp08FileAck >> codecMethodId [

	^ 4587610
]

{ #category : #'AMQP codec' }
Amqp08FileAck >> decodeFrom: codec [

	| bitBuffer |

	deliveryTag := codec nextLonglong.
	bitBuffer := codec nextOctet.
	multiple := ( bitBuffer bitAnd: 1 ) ~= 0
]

{ #category : #accessing }
Amqp08FileAck >> deliveryTag [

	^ deliveryTag
]

{ #category : #accessing }
Amqp08FileAck >> deliveryTag: aValue [

	deliveryTag := aValue
]

{ #category : #'AMQP codec' }
Amqp08FileAck >> encodeOn: codec [

	| bitBuffer |

	codec nextLonglongPut: deliveryTag.
	bitBuffer := 0.
	( multiple ifNil: [ false ] )
		ifTrue: [ bitBuffer := bitBuffer bitOr: 1 ].
	codec nextOctetPut: bitBuffer
]

{ #category : #'AMQP codec' }
Amqp08FileAck >> hasContents [

	^ false
]

{ #category : #accessing }
Amqp08FileAck >> multiple [

	^ multiple
]

{ #category : #accessing }
Amqp08FileAck >> multiple: aValue [

	multiple := aValue
]
