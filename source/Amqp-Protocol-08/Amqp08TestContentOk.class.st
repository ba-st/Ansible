Class {
	#name : #Amqp08TestContentOk,
	#superclass : #AmqpProtocolMethod,
	#instVars : [
		'contentChecksum'
	],
	#category : #'Amqp-Protocol-08'
}

{ #category : #'AMQP codec' }
Amqp08TestContentOk >> acceptableResponseClasses [

	^ {}
]

{ #category : #'AMQP codec' }
Amqp08TestContentOk >> codecMethodId [

	^ 7864361
]

{ #category : #accessing }
Amqp08TestContentOk >> contentChecksum [

	^ contentChecksum
]

{ #category : #accessing }
Amqp08TestContentOk >> contentChecksum: aValue [

	contentChecksum := aValue
]

{ #category : #'AMQP codec' }
Amqp08TestContentOk >> decodeFrom: codec [

	| bitBuffer |

	contentChecksum := codec nextLong
]

{ #category : #'AMQP codec' }
Amqp08TestContentOk >> encodeOn: codec [

	| bitBuffer |

	codec nextLongPut: contentChecksum
]

{ #category : #'AMQP codec' }
Amqp08TestContentOk >> hasContents [

	^ true
]
