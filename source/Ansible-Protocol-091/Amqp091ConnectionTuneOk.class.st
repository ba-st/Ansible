Class {
	#name : #Amqp091ConnectionTuneOk,
	#superclass : #AmqpProtocolMethod,
	#instVars : [
		'channelMax',
		'frameMax',
		'heartbeat'
	],
	#category : #'Ansible-Protocol-091'
}

{ #category : #'AMQP codec' }
Amqp091ConnectionTuneOk >> acceptableResponseClasses [

	^ #()
]

{ #category : #accessing }
Amqp091ConnectionTuneOk >> channelMax [

	^ channelMax
]

{ #category : #accessing }
Amqp091ConnectionTuneOk >> channelMax: aValue [

	channelMax := aValue
]

{ #category : #'AMQP codec' }
Amqp091ConnectionTuneOk >> codecMethodId [

	^ 655391
]

{ #category : #'AMQP codec' }
Amqp091ConnectionTuneOk >> decodeFrom: codec [

	channelMax := codec nextShort.
	frameMax := codec nextLong.
	heartbeat := codec nextShort
]

{ #category : #'AMQP codec' }
Amqp091ConnectionTuneOk >> encodeOn: codec [

	codec nextShortPut: channelMax.
	codec nextLongPut: frameMax.
	codec nextShortPut: heartbeat
]

{ #category : #accessing }
Amqp091ConnectionTuneOk >> frameMax [

	^ frameMax
]

{ #category : #accessing }
Amqp091ConnectionTuneOk >> frameMax: aValue [

	frameMax := aValue
]

{ #category : #'AMQP codec' }
Amqp091ConnectionTuneOk >> hasContents [

	^ false
]

{ #category : #accessing }
Amqp091ConnectionTuneOk >> heartbeat [

	^ heartbeat
]

{ #category : #accessing }
Amqp091ConnectionTuneOk >> heartbeat: aValue [

	heartbeat := aValue
]
