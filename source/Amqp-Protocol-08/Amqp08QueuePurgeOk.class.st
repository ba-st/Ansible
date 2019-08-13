Class {
	#name : #Amqp08QueuePurgeOk,
	#superclass : #AmqpProtocolMethod,
	#instVars : [
		'messageCount'
	],
	#category : #'Amqp-Protocol-08'
}

{ #category : #'AMQP codec' }
Amqp08QueuePurgeOk >> acceptableResponseClasses [

	^ {}
]

{ #category : #'AMQP codec' }
Amqp08QueuePurgeOk >> codecMethodId [

	^ 3276831
]

{ #category : #'AMQP codec' }
Amqp08QueuePurgeOk >> decodeFrom: codec [

	| bitBuffer |

	messageCount := codec nextLong
]

{ #category : #'AMQP codec' }
Amqp08QueuePurgeOk >> encodeOn: codec [

	| bitBuffer |

	codec nextLongPut: messageCount
]

{ #category : #'AMQP codec' }
Amqp08QueuePurgeOk >> hasContents [

	^ false
]

{ #category : #accessing }
Amqp08QueuePurgeOk >> messageCount [

	^ messageCount
]

{ #category : #accessing }
Amqp08QueuePurgeOk >> messageCount: aValue [

	messageCount := aValue
]
