Class {
	#name : #Amqp091QueueDeleteOk,
	#superclass : #AmqpProtocolMethod,
	#instVars : [
		'messageCount'
	],
	#category : #'Ansible-Protocol-091'
}

{ #category : #'AMQP codec' }
Amqp091QueueDeleteOk >> acceptableResponseClasses [

	^ #()
]

{ #category : #'AMQP codec' }
Amqp091QueueDeleteOk >> codecMethodId [

	^ 3276841
]

{ #category : #'AMQP codec' }
Amqp091QueueDeleteOk >> decodeFrom: codec [

	messageCount := codec nextLong
]

{ #category : #'AMQP codec' }
Amqp091QueueDeleteOk >> encodeOn: codec [

	codec nextLongPut: messageCount
]

{ #category : #'AMQP codec' }
Amqp091QueueDeleteOk >> hasContents [

	^ false
]

{ #category : #accessing }
Amqp091QueueDeleteOk >> messageCount [

	^ messageCount
]

{ #category : #accessing }
Amqp091QueueDeleteOk >> messageCount: aValue [

	messageCount := aValue
]
