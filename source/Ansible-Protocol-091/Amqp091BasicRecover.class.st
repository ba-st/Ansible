Class {
	#name : #Amqp091BasicRecover,
	#superclass : #AmqpProtocolMethod,
	#instVars : [
		'requeue'
	],
	#category : #'Ansible-Protocol-091'
}

{ #category : #'AMQP codec' }
Amqp091BasicRecover >> acceptableResponseClasses [

	^ #()
]

{ #category : #'AMQP codec' }
Amqp091BasicRecover >> codecMethodId [

	^ 3932270
]

{ #category : #'AMQP codec' }
Amqp091BasicRecover >> decodeFrom: codec [

	| bitBuffer |

	bitBuffer := codec nextOctet.
	requeue := ( bitBuffer bitAnd: 1 ) ~= 0
]

{ #category : #'AMQP codec' }
Amqp091BasicRecover >> encodeOn: codec [

	| bitBuffer |

	bitBuffer := 0.
	( requeue ifNil: [ false ] )
		ifTrue: [ bitBuffer := bitBuffer bitOr: 1 ].
	codec nextOctetPut: bitBuffer
]

{ #category : #'AMQP codec' }
Amqp091BasicRecover >> hasContents [

	^ false
]

{ #category : #accessing }
Amqp091BasicRecover >> requeue [

	^ requeue
]

{ #category : #accessing }
Amqp091BasicRecover >> requeue: aValue [

	requeue := aValue
]
