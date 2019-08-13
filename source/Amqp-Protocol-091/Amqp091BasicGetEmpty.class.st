Class {
	#name : #Amqp091BasicGetEmpty,
	#superclass : #AmqpProtocolMethod,
	#category : #'Amqp-Protocol-091'
}

{ #category : #'AMQP codec' }
Amqp091BasicGetEmpty >> acceptableResponseClasses [

	^ {}
]

{ #category : #'AMQP codec' }
Amqp091BasicGetEmpty >> codecMethodId [

	^ 3932232
]

{ #category : #'AMQP codec' }
Amqp091BasicGetEmpty >> decodeFrom: codec [

	| bitBuffer |

	codec nextShortstr
]

{ #category : #'AMQP codec' }
Amqp091BasicGetEmpty >> encodeOn: codec [

	| bitBuffer |

	codec nextShortstrPut: nil
]

{ #category : #'AMQP codec' }
Amqp091BasicGetEmpty >> hasContents [

	^ false
]
