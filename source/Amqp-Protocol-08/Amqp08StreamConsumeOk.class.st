Class {
	#name : #Amqp08StreamConsumeOk,
	#superclass : #AmqpProtocolMethod,
	#instVars : [
		'consumerTag'
	],
	#category : #'Amqp-Protocol-08'
}

{ #category : #'AMQP codec' }
Amqp08StreamConsumeOk >> acceptableResponseClasses [

	^ {}
]

{ #category : #'AMQP codec' }
Amqp08StreamConsumeOk >> codecMethodId [

	^ 5242901
]

{ #category : #accessing }
Amqp08StreamConsumeOk >> consumerTag [

	^ consumerTag
]

{ #category : #accessing }
Amqp08StreamConsumeOk >> consumerTag: aValue [

	consumerTag := aValue
]

{ #category : #'AMQP codec' }
Amqp08StreamConsumeOk >> decodeFrom: codec [

	| bitBuffer |

	consumerTag := codec nextShortstr
]

{ #category : #'AMQP codec' }
Amqp08StreamConsumeOk >> encodeOn: codec [

	| bitBuffer |

	codec nextShortstrPut: consumerTag
]

{ #category : #'AMQP codec' }
Amqp08StreamConsumeOk >> hasContents [

	^ false
]
