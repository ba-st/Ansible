Class {
	#name : #Amqp091BasicCancelOk,
	#superclass : #AmqpProtocolMethod,
	#instVars : [
		'consumerTag'
	],
	#category : #'Amqp-Protocol-091'
}

{ #category : #'AMQP codec' }
Amqp091BasicCancelOk >> acceptableResponseClasses [

	^ {}
]

{ #category : #'AMQP codec' }
Amqp091BasicCancelOk >> codecMethodId [

	^ 3932191
]

{ #category : #accessing }
Amqp091BasicCancelOk >> consumerTag [

	^ consumerTag
]

{ #category : #accessing }
Amqp091BasicCancelOk >> consumerTag: aValue [

	consumerTag := aValue
]

{ #category : #'AMQP codec' }
Amqp091BasicCancelOk >> decodeFrom: codec [

	| bitBuffer |

	consumerTag := codec nextShortstr
]

{ #category : #'AMQP codec' }
Amqp091BasicCancelOk >> encodeOn: codec [

	| bitBuffer |

	codec nextShortstrPut: consumerTag
]

{ #category : #'AMQP codec' }
Amqp091BasicCancelOk >> hasContents [

	^ false
]
