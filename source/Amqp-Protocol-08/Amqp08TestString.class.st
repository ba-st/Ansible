Class {
	#name : #Amqp08TestString,
	#superclass : #AmqpProtocolMethod,
	#instVars : [
		'string1',
		'string2',
		'operation'
	],
	#category : #'Amqp-Protocol-08'
}

{ #category : #'AMQP codec' }
Amqp08TestString >> acceptableResponseClasses [

	^ {Amqp08TestStringOk}
]

{ #category : #'AMQP codec' }
Amqp08TestString >> codecMethodId [

	^ 7864340
]

{ #category : #'AMQP codec' }
Amqp08TestString >> decodeFrom: codec [

	| bitBuffer |

	string1 := codec nextShortstr.
	string2 := codec nextLongstr.
	operation := codec nextOctet
]

{ #category : #'AMQP codec' }
Amqp08TestString >> encodeOn: codec [

	| bitBuffer |

	codec nextShortstrPut: string1.
	codec nextLongstrPut: string2.
	codec nextOctetPut: operation
]

{ #category : #'AMQP codec' }
Amqp08TestString >> hasContents [

	^ false
]

{ #category : #accessing }
Amqp08TestString >> operation [

	^ operation
]

{ #category : #accessing }
Amqp08TestString >> operation: aValue [

	operation := aValue
]

{ #category : #accessing }
Amqp08TestString >> string1 [

	^ string1
]

{ #category : #accessing }
Amqp08TestString >> string1: aValue [

	string1 := aValue
]

{ #category : #accessing }
Amqp08TestString >> string2 [

	^ string2
]

{ #category : #accessing }
Amqp08TestString >> string2: aValue [

	string2 := aValue
]
