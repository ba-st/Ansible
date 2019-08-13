Class {
	#name : #Amqp08BasicCancel,
	#superclass : #AmqpProtocolMethod,
	#instVars : [
		'consumerTag',
		'nowait'
	],
	#category : #'Amqp-Protocol-08'
}

{ #category : #'AMQP codec' }
Amqp08BasicCancel >> acceptableResponseClasses [

	^ {Amqp08BasicCancelOk}
]

{ #category : #'AMQP codec' }
Amqp08BasicCancel >> codecMethodId [

	^ 3932190
]

{ #category : #accessing }
Amqp08BasicCancel >> consumerTag [

	^ consumerTag
]

{ #category : #accessing }
Amqp08BasicCancel >> consumerTag: aValue [

	consumerTag := aValue
]

{ #category : #'AMQP codec' }
Amqp08BasicCancel >> decodeFrom: codec [

	| bitBuffer |

	consumerTag := codec nextShortstr.
	bitBuffer := codec nextOctet.
	nowait := ( bitBuffer bitAnd: 1 ) ~= 0
]

{ #category : #'AMQP codec' }
Amqp08BasicCancel >> encodeOn: codec [

	| bitBuffer |

	codec nextShortstrPut: consumerTag.
	bitBuffer := 0.
	( nowait ifNil: [ false ] )
		ifTrue: [ bitBuffer := bitBuffer bitOr: 1 ].
	codec nextOctetPut: bitBuffer
]

{ #category : #'AMQP codec' }
Amqp08BasicCancel >> hasContents [

	^ false
]

{ #category : #accessing }
Amqp08BasicCancel >> nowait [

	^ nowait
]

{ #category : #accessing }
Amqp08BasicCancel >> nowait: aValue [

	nowait := aValue
]
