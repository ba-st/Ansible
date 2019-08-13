Class {
	#name : #Amqp08FileQos,
	#superclass : #AmqpProtocolMethod,
	#instVars : [
		'prefetchSize',
		'prefetchCount',
		'global'
	],
	#category : #'Amqp-Protocol-08'
}

{ #category : #'AMQP codec' }
Amqp08FileQos >> acceptableResponseClasses [

	^ {Amqp08FileQosOk}
]

{ #category : #'AMQP codec' }
Amqp08FileQos >> codecMethodId [

	^ 4587530
]

{ #category : #'AMQP codec' }
Amqp08FileQos >> decodeFrom: codec [

	| bitBuffer |

	prefetchSize := codec nextLong.
	prefetchCount := codec nextShort.
	bitBuffer := codec nextOctet.
	global := ( bitBuffer bitAnd: 1 ) ~= 0
]

{ #category : #'AMQP codec' }
Amqp08FileQos >> encodeOn: codec [

	| bitBuffer |

	codec nextLongPut: prefetchSize.
	codec nextShortPut: prefetchCount.
	bitBuffer := 0.
	( global ifNil: [ false ] )
		ifTrue: [ bitBuffer := bitBuffer bitOr: 1 ].
	codec nextOctetPut: bitBuffer
]

{ #category : #accessing }
Amqp08FileQos >> global [

	^ global
]

{ #category : #accessing }
Amqp08FileQos >> global: aValue [

	global := aValue
]

{ #category : #'AMQP codec' }
Amqp08FileQos >> hasContents [

	^ false
]

{ #category : #accessing }
Amqp08FileQos >> prefetchCount [

	^ prefetchCount
]

{ #category : #accessing }
Amqp08FileQos >> prefetchCount: aValue [

	prefetchCount := aValue
]

{ #category : #accessing }
Amqp08FileQos >> prefetchSize [

	^ prefetchSize
]

{ #category : #accessing }
Amqp08FileQos >> prefetchSize: aValue [

	prefetchSize := aValue
]
