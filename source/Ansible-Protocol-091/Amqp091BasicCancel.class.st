Class {
	#name : #Amqp091BasicCancel,
	#superclass : #AmqpProtocolMethod,
	#instVars : [
		'consumerTag',
		'noWait'
	],
	#category : #'Ansible-Protocol-091'
}

{ #category : #'AMQP codec' }
Amqp091BasicCancel >> acceptableResponseClasses [

	^ {Amqp091BasicCancelOk}
]

{ #category : #'AMQP codec' }
Amqp091BasicCancel >> codecMethodId [

	^ 3932190
]

{ #category : #accessing }
Amqp091BasicCancel >> consumerTag [

	^ consumerTag
]

{ #category : #accessing }
Amqp091BasicCancel >> consumerTag: aValue [

	consumerTag := aValue
]

{ #category : #'AMQP codec' }
Amqp091BasicCancel >> decodeFrom: codec [

	| bitBuffer |

	consumerTag := codec nextShortstr.
	bitBuffer := codec nextOctet.
	noWait := ( bitBuffer bitAnd: 1 ) ~= 0
]

{ #category : #'AMQP codec' }
Amqp091BasicCancel >> encodeOn: codec [

	| bitBuffer |

	codec nextShortstrPut: consumerTag.
	bitBuffer := 0.
	( noWait ifNil: [ false ] )
		ifTrue: [ bitBuffer := bitBuffer bitOr: 1 ].
	codec nextOctetPut: bitBuffer
]

{ #category : #'AMQP codec' }
Amqp091BasicCancel >> hasContents [

	^ false
]

{ #category : #accessing }
Amqp091BasicCancel >> noWait [

	^ noWait
]

{ #category : #accessing }
Amqp091BasicCancel >> noWait: aValue [

	noWait := aValue
]
