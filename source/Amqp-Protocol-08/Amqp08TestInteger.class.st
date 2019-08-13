Class {
	#name : #Amqp08TestInteger,
	#superclass : #AmqpProtocolMethod,
	#instVars : [
		'integer1',
		'integer2',
		'integer3',
		'integer4',
		'operation'
	],
	#category : #'Amqp-Protocol-08'
}

{ #category : #'AMQP codec' }
Amqp08TestInteger >> acceptableResponseClasses [

	^ {Amqp08TestIntegerOk}
]

{ #category : #'AMQP codec' }
Amqp08TestInteger >> codecMethodId [

	^ 7864330
]

{ #category : #'AMQP codec' }
Amqp08TestInteger >> decodeFrom: codec [

	| bitBuffer |

	integer1 := codec nextOctet.
	integer2 := codec nextShort.
	integer3 := codec nextLong.
	integer4 := codec nextLonglong.
	operation := codec nextOctet
]

{ #category : #'AMQP codec' }
Amqp08TestInteger >> encodeOn: codec [

	| bitBuffer |

	codec nextOctetPut: integer1.
	codec nextShortPut: integer2.
	codec nextLongPut: integer3.
	codec nextLonglongPut: integer4.
	codec nextOctetPut: operation
]

{ #category : #'AMQP codec' }
Amqp08TestInteger >> hasContents [

	^ false
]

{ #category : #accessing }
Amqp08TestInteger >> integer1 [

	^ integer1
]

{ #category : #accessing }
Amqp08TestInteger >> integer1: aValue [

	integer1 := aValue
]

{ #category : #accessing }
Amqp08TestInteger >> integer2 [

	^ integer2
]

{ #category : #accessing }
Amqp08TestInteger >> integer2: aValue [

	integer2 := aValue
]

{ #category : #accessing }
Amqp08TestInteger >> integer3 [

	^ integer3
]

{ #category : #accessing }
Amqp08TestInteger >> integer3: aValue [

	integer3 := aValue
]

{ #category : #accessing }
Amqp08TestInteger >> integer4 [

	^ integer4
]

{ #category : #accessing }
Amqp08TestInteger >> integer4: aValue [

	integer4 := aValue
]

{ #category : #accessing }
Amqp08TestInteger >> operation [

	^ operation
]

{ #category : #accessing }
Amqp08TestInteger >> operation: aValue [

	operation := aValue
]
