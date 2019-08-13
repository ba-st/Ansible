Class {
	#name : #Amqp08FileConsumeOk,
	#superclass : #AmqpProtocolMethod,
	#instVars : [
		'consumerTag'
	],
	#category : #'Amqp-Protocol-08'
}

{ #category : #'AMQP codec' }
Amqp08FileConsumeOk >> acceptableResponseClasses [

	^ {}
]

{ #category : #'AMQP codec' }
Amqp08FileConsumeOk >> codecMethodId [

	^ 4587541
]

{ #category : #accessing }
Amqp08FileConsumeOk >> consumerTag [

	^ consumerTag
]

{ #category : #accessing }
Amqp08FileConsumeOk >> consumerTag: aValue [

	consumerTag := aValue
]

{ #category : #'AMQP codec' }
Amqp08FileConsumeOk >> decodeFrom: codec [

	| bitBuffer |

	consumerTag := codec nextShortstr
]

{ #category : #'AMQP codec' }
Amqp08FileConsumeOk >> encodeOn: codec [

	| bitBuffer |

	codec nextShortstrPut: consumerTag
]

{ #category : #'AMQP codec' }
Amqp08FileConsumeOk >> hasContents [

	^ false
]
