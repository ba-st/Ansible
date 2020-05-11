Class {
	#name : #Amqp08BasicCancelOk,
	#superclass : #AmqpProtocolMethod,
	#instVars : [
		'consumerTag'
	],
	#category : #'Ansible-Protocol-08'
}

{ #category : #'AMQP codec' }
Amqp08BasicCancelOk >> acceptableResponseClasses [

	^ {}
]

{ #category : #'AMQP codec' }
Amqp08BasicCancelOk >> codecMethodId [

	^ 3932191
]

{ #category : #accessing }
Amqp08BasicCancelOk >> consumerTag [

	^ consumerTag
]

{ #category : #accessing }
Amqp08BasicCancelOk >> consumerTag: aValue [

	consumerTag := aValue
]

{ #category : #'AMQP codec' }
Amqp08BasicCancelOk >> decodeFrom: codec [

	| bitBuffer |

	consumerTag := codec nextShortstr
]

{ #category : #'AMQP codec' }
Amqp08BasicCancelOk >> encodeOn: codec [

	| bitBuffer |

	codec nextShortstrPut: consumerTag
]

{ #category : #'AMQP codec' }
Amqp08BasicCancelOk >> hasContents [

	^ false
]
