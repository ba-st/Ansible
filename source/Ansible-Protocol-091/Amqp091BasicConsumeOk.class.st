Class {
	#name : #Amqp091BasicConsumeOk,
	#superclass : #AmqpProtocolMethod,
	#instVars : [
		'consumerTag'
	],
	#category : #'Ansible-Protocol-091'
}

{ #category : #'AMQP codec' }
Amqp091BasicConsumeOk >> acceptableResponseClasses [

	^ #()
]

{ #category : #'AMQP codec' }
Amqp091BasicConsumeOk >> codecMethodId [

	^ 3932181
]

{ #category : #accessing }
Amqp091BasicConsumeOk >> consumerTag [

	^ consumerTag
]

{ #category : #accessing }
Amqp091BasicConsumeOk >> consumerTag: aValue [

	consumerTag := aValue
]

{ #category : #'AMQP codec' }
Amqp091BasicConsumeOk >> decodeFrom: codec [

	consumerTag := codec nextShortstr
]

{ #category : #'AMQP codec' }
Amqp091BasicConsumeOk >> encodeOn: codec [

	codec nextShortstrPut: consumerTag
]

{ #category : #'AMQP codec' }
Amqp091BasicConsumeOk >> hasContents [

	^ false
]
