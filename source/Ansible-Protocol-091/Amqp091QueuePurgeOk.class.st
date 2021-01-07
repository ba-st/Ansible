Class {
	#name : #Amqp091QueuePurgeOk,
	#superclass : #AmqpProtocolMethod,
	#instVars : [
		'messageCount'
	],
	#category : #'Ansible-Protocol-091'
}

{ #category : #'AMQP codec' }
Amqp091QueuePurgeOk >> acceptableResponseClasses [

	^ #()
]

{ #category : #'AMQP codec' }
Amqp091QueuePurgeOk >> codecMethodId [

	^ 3276831
]

{ #category : #'AMQP codec' }
Amqp091QueuePurgeOk >> decodeFrom: codec [

	messageCount := codec nextLong
]

{ #category : #'AMQP codec' }
Amqp091QueuePurgeOk >> encodeOn: codec [

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
