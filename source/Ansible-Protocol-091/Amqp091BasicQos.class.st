Class {
	#name : #Amqp091BasicQos,
	#superclass : #AmqpProtocolMethod,
	#instVars : [
		'prefetchSize',
		'prefetchCount',
		'global'
	],
	#category : #'Ansible-Protocol-091'
}

{ #category : #'AMQP codec' }
Amqp091BasicQos >> acceptableResponseClasses [

	^ Array with: Amqp091BasicQosOk
]

{ #category : #'AMQP codec' }
Amqp091BasicQos >> codecMethodId [

	^ 3932170
]

{ #category : #'AMQP codec' }
Amqp091BasicQos >> decodeFrom: codec [

	| bitBuffer |

	prefetchSize := codec nextLong.
	prefetchCount := codec nextShort.
	bitBuffer := codec nextOctet.
	global := ( bitBuffer bitAnd: 1 ) ~= 0
]

{ #category : #'AMQP codec' }
Amqp091BasicQos >> encodeOn: codec [

	| bitBuffer |

	codec nextLongPut: prefetchSize.
	codec nextShortPut: prefetchCount.
	bitBuffer := 0.
	( global ifNil: [ false ] )
		ifTrue: [ bitBuffer := bitBuffer bitOr: 1 ].
	codec nextOctetPut: bitBuffer
]

{ #category : #accessing }
Amqp091BasicQos >> global [

	^ global
]

{ #category : #accessing }
Amqp091BasicQos >> global: aValue [

	global := aValue
]

{ #category : #'AMQP codec' }
Amqp091BasicQos >> hasContents [

	^ false
]

{ #category : #accessing }
Amqp091BasicQos >> prefetchCount [

	^ prefetchCount
]

{ #category : #accessing }
Amqp091BasicQos >> prefetchCount: aValue [

	prefetchCount := aValue
]

{ #category : #accessing }
Amqp091BasicQos >> prefetchSize [

	^ prefetchSize
]

{ #category : #accessing }
Amqp091BasicQos >> prefetchSize: aValue [

	prefetchSize := aValue
]
