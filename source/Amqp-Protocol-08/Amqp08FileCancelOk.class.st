Class {
	#name : #Amqp08FileCancelOk,
	#superclass : #AmqpProtocolMethod,
	#instVars : [
		'consumerTag'
	],
	#category : #'Amqp-Protocol-08'
}

{ #category : #'AMQP codec' }
Amqp08FileCancelOk >> acceptableResponseClasses [

	^ {}
]

{ #category : #'AMQP codec' }
Amqp08FileCancelOk >> codecMethodId [

	^ 4587551
]

{ #category : #accessing }
Amqp08FileCancelOk >> consumerTag [

	^ consumerTag
]

{ #category : #accessing }
Amqp08FileCancelOk >> consumerTag: aValue [

	consumerTag := aValue
]

{ #category : #'AMQP codec' }
Amqp08FileCancelOk >> decodeFrom: codec [

	| bitBuffer |

	consumerTag := codec nextShortstr
]

{ #category : #'AMQP codec' }
Amqp08FileCancelOk >> encodeOn: codec [

	| bitBuffer |

	codec nextShortstrPut: consumerTag
]

{ #category : #'AMQP codec' }
Amqp08FileCancelOk >> hasContents [

	^ false
]
