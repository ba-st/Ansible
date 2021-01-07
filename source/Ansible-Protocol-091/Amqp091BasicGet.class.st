Class {
	#name : #Amqp091BasicGet,
	#superclass : #AmqpProtocolMethod,
	#instVars : [
		'queue',
		'noAck'
	],
	#category : #'Ansible-Protocol-091'
}

{ #category : #'AMQP codec' }
Amqp091BasicGet >> acceptableResponseClasses [

	^ Array with: Amqp091BasicGetOk with: Amqp091BasicGetEmpty
]

{ #category : #'AMQP codec' }
Amqp091BasicGet >> codecMethodId [

	^ 3932230
]

{ #category : #'AMQP codec' }
Amqp091BasicGet >> decodeFrom: codec [

	| bitBuffer |

	codec nextShort.
	queue := codec nextShortstr.
	bitBuffer := codec nextOctet.
	noAck := ( bitBuffer bitAnd: 1 ) ~= 0
]

{ #category : #'AMQP codec' }
Amqp091BasicGet >> encodeOn: codec [

	| bitBuffer |

	codec nextShortPut: 0.
	codec nextShortstrPut: queue.
	bitBuffer := 0.
	( noAck ifNil: [ false ] )
		ifTrue: [ bitBuffer := bitBuffer bitOr: 1 ].
	codec nextOctetPut: bitBuffer
]

{ #category : #'AMQP codec' }
Amqp091BasicGet >> hasContents [

	^ false
]

{ #category : #accessing }
Amqp091BasicGet >> noAck [

	^ noAck
]

{ #category : #accessing }
Amqp091BasicGet >> noAck: aValue [

	noAck := aValue
]

{ #category : #accessing }
Amqp091BasicGet >> queue [

	^ queue
]

{ #category : #accessing }
Amqp091BasicGet >> queue: aValue [

	queue := aValue
]
