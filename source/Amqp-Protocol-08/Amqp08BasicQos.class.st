Class {
	#name : #Amqp08BasicQos,
	#superclass : #AmqpProtocolMethod,
	#instVars : [
		'prefetchSize',
		'prefetchCount',
		'global'
	],
	#category : #'Amqp-Protocol-08'
}

{ #category : #'AMQP codec' }
Amqp08BasicQos >> acceptableResponseClasses [

	^ {Amqp08BasicQosOk}
]

{ #category : #'AMQP codec' }
Amqp08BasicQos >> codecMethodId [

	^ 3932170
]

{ #category : #'AMQP codec' }
Amqp08BasicQos >> decodeFrom: codec [

	| bitBuffer |

	prefetchSize := codec nextLong.
	prefetchCount := codec nextShort.
	bitBuffer := codec nextOctet.
	global := ( bitBuffer bitAnd: 1 ) ~= 0
]

{ #category : #'AMQP codec' }
Amqp08BasicQos >> encodeOn: codec [

	| bitBuffer |

	codec nextLongPut: prefetchSize.
	codec nextShortPut: prefetchCount.
	bitBuffer := 0.
	( global ifNil: [ false ] )
		ifTrue: [ bitBuffer := bitBuffer bitOr: 1 ].
	codec nextOctetPut: bitBuffer
]

{ #category : #accessing }
Amqp08BasicQos >> global [

	^ global
]

{ #category : #accessing }
Amqp08BasicQos >> global: aValue [

	global := aValue
]

{ #category : #'AMQP codec' }
Amqp08BasicQos >> hasContents [

	^ false
]

{ #category : #accessing }
Amqp08BasicQos >> prefetchCount [

	^ prefetchCount
]

{ #category : #accessing }
Amqp08BasicQos >> prefetchCount: aValue [

	prefetchCount := aValue
]

{ #category : #accessing }
Amqp08BasicQos >> prefetchSize [

	^ prefetchSize
]

{ #category : #accessing }
Amqp08BasicQos >> prefetchSize: aValue [

	prefetchSize := aValue
]
