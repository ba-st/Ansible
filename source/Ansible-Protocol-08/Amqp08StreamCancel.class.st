Class {
	#name : #Amqp08StreamCancel,
	#superclass : #AmqpProtocolMethod,
	#instVars : [
		'consumerTag',
		'nowait'
	],
	#category : #'Ansible-Protocol-08'
}

{ #category : #'AMQP codec' }
Amqp08StreamCancel >> acceptableResponseClasses [

	^ {Amqp08StreamCancelOk}
]

{ #category : #'AMQP codec' }
Amqp08StreamCancel >> codecMethodId [

	^ 5242910
]

{ #category : #accessing }
Amqp08StreamCancel >> consumerTag [

	^ consumerTag
]

{ #category : #accessing }
Amqp08StreamCancel >> consumerTag: aValue [

	consumerTag := aValue
]

{ #category : #'AMQP codec' }
Amqp08StreamCancel >> decodeFrom: codec [

	| bitBuffer |

	consumerTag := codec nextShortstr.
	bitBuffer := codec nextOctet.
	nowait := ( bitBuffer bitAnd: 1 ) ~= 0
]

{ #category : #'AMQP codec' }
Amqp08StreamCancel >> encodeOn: codec [

	| bitBuffer |

	codec nextShortstrPut: consumerTag.
	bitBuffer := 0.
	( nowait ifNil: [ false ] )
		ifTrue: [ bitBuffer := bitBuffer bitOr: 1 ].
	codec nextOctetPut: bitBuffer
]

{ #category : #'AMQP codec' }
Amqp08StreamCancel >> hasContents [

	^ false
]

{ #category : #accessing }
Amqp08StreamCancel >> nowait [

	^ nowait
]

{ #category : #accessing }
Amqp08StreamCancel >> nowait: aValue [

	nowait := aValue
]
