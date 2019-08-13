Class {
	#name : #Amqp08FileOpen,
	#superclass : #AmqpProtocolMethod,
	#instVars : [
		'identifier',
		'contentSize'
	],
	#category : #'Amqp-Protocol-08'
}

{ #category : #'AMQP codec' }
Amqp08FileOpen >> acceptableResponseClasses [

	^ {Amqp08FileOpenOk}
]

{ #category : #'AMQP codec' }
Amqp08FileOpen >> codecMethodId [

	^ 4587560
]

{ #category : #accessing }
Amqp08FileOpen >> contentSize [

	^ contentSize
]

{ #category : #accessing }
Amqp08FileOpen >> contentSize: aValue [

	contentSize := aValue
]

{ #category : #'AMQP codec' }
Amqp08FileOpen >> decodeFrom: codec [

	| bitBuffer |

	identifier := codec nextShortstr.
	contentSize := codec nextLonglong
]

{ #category : #'AMQP codec' }
Amqp08FileOpen >> encodeOn: codec [

	| bitBuffer |

	codec nextShortstrPut: identifier.
	codec nextLonglongPut: contentSize
]

{ #category : #'AMQP codec' }
Amqp08FileOpen >> hasContents [

	^ false
]

{ #category : #accessing }
Amqp08FileOpen >> identifier [

	^ identifier
]

{ #category : #accessing }
Amqp08FileOpen >> identifier: aValue [

	identifier := aValue
]
