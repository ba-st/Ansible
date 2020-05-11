Class {
	#name : #Amqp08StreamQos,
	#superclass : #AmqpProtocolMethod,
	#instVars : [
		'prefetchSize',
		'prefetchCount',
		'consumeRate',
		'global'
	],
	#category : #'Ansible-Protocol-08'
}

{ #category : #'AMQP codec' }
Amqp08StreamQos >> acceptableResponseClasses [

	^ {Amqp08StreamQosOk}
]

{ #category : #'AMQP codec' }
Amqp08StreamQos >> codecMethodId [

	^ 5242890
]

{ #category : #accessing }
Amqp08StreamQos >> consumeRate [

	^ consumeRate
]

{ #category : #accessing }
Amqp08StreamQos >> consumeRate: aValue [

	consumeRate := aValue
]

{ #category : #'AMQP codec' }
Amqp08StreamQos >> decodeFrom: codec [

	| bitBuffer |

	prefetchSize := codec nextLong.
	prefetchCount := codec nextShort.
	consumeRate := codec nextLong.
	bitBuffer := codec nextOctet.
	global := ( bitBuffer bitAnd: 1 ) ~= 0
]

{ #category : #'AMQP codec' }
Amqp08StreamQos >> encodeOn: codec [

	| bitBuffer |

	codec nextLongPut: prefetchSize.
	codec nextShortPut: prefetchCount.
	codec nextLongPut: consumeRate.
	bitBuffer := 0.
	( global ifNil: [ false ] )
		ifTrue: [ bitBuffer := bitBuffer bitOr: 1 ].
	codec nextOctetPut: bitBuffer
]

{ #category : #accessing }
Amqp08StreamQos >> global [

	^ global
]

{ #category : #accessing }
Amqp08StreamQos >> global: aValue [

	global := aValue
]

{ #category : #'AMQP codec' }
Amqp08StreamQos >> hasContents [

	^ false
]

{ #category : #accessing }
Amqp08StreamQos >> prefetchCount [

	^ prefetchCount
]

{ #category : #accessing }
Amqp08StreamQos >> prefetchCount: aValue [

	prefetchCount := aValue
]

{ #category : #accessing }
Amqp08StreamQos >> prefetchSize [

	^ prefetchSize
]

{ #category : #accessing }
Amqp08StreamQos >> prefetchSize: aValue [

	prefetchSize := aValue
]
