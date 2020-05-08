Class {
	#name : #Amqp08BasicConsumeOk,
	#superclass : #AmqpProtocolMethod,
	#instVars : [
		'consumerTag'
	],
	#category : #'Ansible-Protocol-08'
}

{ #category : #'AMQP codec' }
Amqp08BasicConsumeOk >> acceptableResponseClasses [

	^ {}
]

{ #category : #'AMQP codec' }
Amqp08BasicConsumeOk >> codecMethodId [

	^ 3932181
]

{ #category : #accessing }
Amqp08BasicConsumeOk >> consumerTag [

	^ consumerTag
]

{ #category : #accessing }
Amqp08BasicConsumeOk >> consumerTag: aValue [

	consumerTag := aValue
]

{ #category : #'AMQP codec' }
Amqp08BasicConsumeOk >> decodeFrom: codec [

	| bitBuffer |

	consumerTag := codec nextShortstr
]

{ #category : #'AMQP codec' }
Amqp08BasicConsumeOk >> encodeOn: codec [

	| bitBuffer |

	codec nextShortstrPut: consumerTag
]

{ #category : #'AMQP codec' }
Amqp08BasicConsumeOk >> hasContents [

	^ false
]
