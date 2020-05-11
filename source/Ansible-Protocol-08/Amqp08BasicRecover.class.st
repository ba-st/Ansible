Class {
	#name : #Amqp08BasicRecover,
	#superclass : #AmqpProtocolMethod,
	#instVars : [
		'requeue'
	],
	#category : #'Ansible-Protocol-08'
}

{ #category : #'AMQP codec' }
Amqp08BasicRecover >> acceptableResponseClasses [

	^ {}
]

{ #category : #'AMQP codec' }
Amqp08BasicRecover >> codecMethodId [

	^ 3932260
]

{ #category : #'AMQP codec' }
Amqp08BasicRecover >> decodeFrom: codec [

	| bitBuffer |

	bitBuffer := codec nextOctet.
	requeue := ( bitBuffer bitAnd: 1 ) ~= 0
]

{ #category : #'AMQP codec' }
Amqp08BasicRecover >> encodeOn: codec [

	| bitBuffer |

	bitBuffer := 0.
	( requeue ifNil: [ false ] )
		ifTrue: [ bitBuffer := bitBuffer bitOr: 1 ].
	codec nextOctetPut: bitBuffer
]

{ #category : #'AMQP codec' }
Amqp08BasicRecover >> hasContents [

	^ false
]

{ #category : #accessing }
Amqp08BasicRecover >> requeue [

	^ requeue
]

{ #category : #accessing }
Amqp08BasicRecover >> requeue: aValue [

	requeue := aValue
]
