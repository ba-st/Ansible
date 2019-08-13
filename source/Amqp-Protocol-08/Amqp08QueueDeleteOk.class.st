Class {
	#name : #Amqp08QueueDeleteOk,
	#superclass : #AmqpProtocolMethod,
	#instVars : [
		'messageCount'
	],
	#category : #'Amqp-Protocol-08'
}

{ #category : #'AMQP codec' }
Amqp08QueueDeleteOk >> acceptableResponseClasses [

	^ {}
]

{ #category : #'AMQP codec' }
Amqp08QueueDeleteOk >> codecMethodId [

	^ 3276841
]

{ #category : #'AMQP codec' }
Amqp08QueueDeleteOk >> decodeFrom: codec [

	| bitBuffer |

	messageCount := codec nextLong
]

{ #category : #'AMQP codec' }
Amqp08QueueDeleteOk >> encodeOn: codec [

	| bitBuffer |

	codec nextLongPut: messageCount
]

{ #category : #'AMQP codec' }
Amqp08QueueDeleteOk >> hasContents [

	^ false
]

{ #category : #accessing }
Amqp08QueueDeleteOk >> messageCount [

	^ messageCount
]

{ #category : #accessing }
Amqp08QueueDeleteOk >> messageCount: aValue [

	messageCount := aValue
]
