Class {
	#name : #Amqp08StreamCancelOk,
	#superclass : #AmqpProtocolMethod,
	#instVars : [
		'consumerTag'
	],
	#category : #'Ansible-Protocol-08'
}

{ #category : #'AMQP codec' }
Amqp08StreamCancelOk >> acceptableResponseClasses [

	^ {}
]

{ #category : #'AMQP codec' }
Amqp08StreamCancelOk >> codecMethodId [

	^ 5242911
]

{ #category : #accessing }
Amqp08StreamCancelOk >> consumerTag [

	^ consumerTag
]

{ #category : #accessing }
Amqp08StreamCancelOk >> consumerTag: aValue [

	consumerTag := aValue
]

{ #category : #'AMQP codec' }
Amqp08StreamCancelOk >> decodeFrom: codec [

	| bitBuffer |

	consumerTag := codec nextShortstr
]

{ #category : #'AMQP codec' }
Amqp08StreamCancelOk >> encodeOn: codec [

	| bitBuffer |

	codec nextShortstrPut: consumerTag
]

{ #category : #'AMQP codec' }
Amqp08StreamCancelOk >> hasContents [

	^ false
]
