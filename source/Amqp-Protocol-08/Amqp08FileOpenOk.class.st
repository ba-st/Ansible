Class {
	#name : #Amqp08FileOpenOk,
	#superclass : #AmqpProtocolMethod,
	#instVars : [
		'stagedSize'
	],
	#category : #'Amqp-Protocol-08'
}

{ #category : #'AMQP codec' }
Amqp08FileOpenOk >> acceptableResponseClasses [

	^ {Amqp08FileStage}
]

{ #category : #'AMQP codec' }
Amqp08FileOpenOk >> codecMethodId [

	^ 4587561
]

{ #category : #'AMQP codec' }
Amqp08FileOpenOk >> decodeFrom: codec [

	| bitBuffer |

	stagedSize := codec nextLonglong
]

{ #category : #'AMQP codec' }
Amqp08FileOpenOk >> encodeOn: codec [

	| bitBuffer |

	codec nextLonglongPut: stagedSize
]

{ #category : #'AMQP codec' }
Amqp08FileOpenOk >> hasContents [

	^ false
]

{ #category : #accessing }
Amqp08FileOpenOk >> stagedSize [

	^ stagedSize
]

{ #category : #accessing }
Amqp08FileOpenOk >> stagedSize: aValue [

	stagedSize := aValue
]
