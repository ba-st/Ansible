Class {
	#name : #Amqp091QueuePurgeOk,
	#superclass : #AmqpProtocolMethod,
	#instVars : [
		'messageCount'
	],
	#category : #'Amqp-Protocol-091'
}

{ #category : #'AMQP codec' }
Amqp091QueuePurgeOk >> acceptableResponseClasses [

	^ {}
]

{ #category : #'AMQP codec' }
Amqp091QueuePurgeOk >> codecMethodId [

	^ 3276831
]

{ #category : #'AMQP codec' }
Amqp091QueuePurgeOk >> decodeFrom: codec [

	| bitBuffer |

	messageCount := codec nextLong
]

{ #category : #'AMQP codec' }
Amqp091QueuePurgeOk >> encodeOn: codec [

	| bitBuffer |

	codec nextLongPut: messageCount
]

{ #category : #'AMQP codec' }
Amqp091QueuePurgeOk >> hasContents [

	^ false
]

{ #category : #accessing }
Amqp091QueuePurgeOk >> messageCount [

	^ messageCount
]

{ #category : #accessing }
Amqp091QueuePurgeOk >> messageCount: aValue [

	messageCount := aValue
]
