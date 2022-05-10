Class {
	#name : #Amqp091ConfirmSelect,
	#superclass : #AmqpProtocolMethod,
	#instVars : [
		'noWait'
	],
	#category : #'Ansible-Protocol-091'
}

{ #category : #accessing }
Amqp091ConfirmSelect >> acceptableResponseClasses [

	^ Array with: Amqp091ConfirmSelectOk
]

{ #category : #accessing }
Amqp091ConfirmSelect >> codecMethodId [

	^ 5570570
]

{ #category : #decoding }
Amqp091ConfirmSelect >> decodeFrom: codec [

	| bitBuffer |

	bitBuffer := codec nextOctet.
	noWait := (bitBuffer bitAnd: 1) ~= 0
]

{ #category : #encoding }
Amqp091ConfirmSelect >> encodeOn: codec [

	| bitBuffer |

	bitBuffer := 0.
	(noWait ifNil: [false]) ifTrue: [bitBuffer := bitBuffer bitOr: 1].
	codec nextOctetPut: bitBuffer
]

{ #category : #testing }
Amqp091ConfirmSelect >> hasContents [

	^false
]

{ #category : #accessing }
Amqp091ConfirmSelect >> noWait [

	^ noWait
]

{ #category : #accessing }
Amqp091ConfirmSelect >> noWait: aValue [

	noWait := aValue
]
