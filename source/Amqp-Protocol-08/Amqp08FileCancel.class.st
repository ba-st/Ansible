Class {
	#name : #Amqp08FileCancel,
	#superclass : #AmqpProtocolMethod,
	#instVars : [
		'consumerTag',
		'nowait'
	],
	#category : #'Amqp-Protocol-08'
}

{ #category : #'AMQP codec' }
Amqp08FileCancel >> acceptableResponseClasses [

	^ {Amqp08FileCancelOk}
]

{ #category : #'AMQP codec' }
Amqp08FileCancel >> codecMethodId [

	^ 4587550
]

{ #category : #accessing }
Amqp08FileCancel >> consumerTag [

	^ consumerTag
]

{ #category : #accessing }
Amqp08FileCancel >> consumerTag: aValue [

	consumerTag := aValue
]

{ #category : #'AMQP codec' }
Amqp08FileCancel >> decodeFrom: codec [

	| bitBuffer |

	consumerTag := codec nextShortstr.
	bitBuffer := codec nextOctet.
	nowait := ( bitBuffer bitAnd: 1 ) ~= 0
]

{ #category : #'AMQP codec' }
Amqp08FileCancel >> encodeOn: codec [

	| bitBuffer |

	codec nextShortstrPut: consumerTag.
	bitBuffer := 0.
	( nowait ifNil: [ false ] )
		ifTrue: [ bitBuffer := bitBuffer bitOr: 1 ].
	codec nextOctetPut: bitBuffer
]

{ #category : #'AMQP codec' }
Amqp08FileCancel >> hasContents [

	^ false
]

{ #category : #accessing }
Amqp08FileCancel >> nowait [

	^ nowait
]

{ #category : #accessing }
Amqp08FileCancel >> nowait: aValue [

	nowait := aValue
]
