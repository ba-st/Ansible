Class {
	#name : #Amqp091ConnectionTune,
	#superclass : #AmqpProtocolMethod,
	#instVars : [
		'channelMax',
		'frameMax',
		'heartbeat'
	],
	#category : #'Ansible-Protocol-091'
}

{ #category : #'AMQP codec' }
Amqp091ConnectionTune >> acceptableResponseClasses [

	^ Array with: Amqp091ConnectionTuneOk
]

{ #category : #accessing }
Amqp091ConnectionTune >> channelMax [

	^ channelMax
]

{ #category : #accessing }
Amqp091ConnectionTune >> channelMax: aValue [

	channelMax := aValue
]

{ #category : #'AMQP codec' }
Amqp091ConnectionTune >> codecMethodId [

	^ 655390
]

{ #category : #'AMQP codec' }
Amqp091ConnectionTune >> decodeFrom: codec [

	channelMax := codec nextShort.
	frameMax := codec nextLong.
	heartbeat := codec nextShort
]

{ #category : #'AMQP codec' }
Amqp091ConnectionTune >> encodeOn: codec [

	codec nextShortPut: channelMax.
	codec nextLongPut: frameMax.
	codec nextShortPut: heartbeat
]

{ #category : #accessing }
Amqp091ConnectionTune >> frameMax [

	^ frameMax
]

{ #category : #accessing }
Amqp091ConnectionTune >> frameMax: aValue [

	frameMax := aValue
]

{ #category : #'AMQP codec' }
Amqp091ConnectionTune >> hasContents [

	^ false
]

{ #category : #accessing }
Amqp091ConnectionTune >> heartbeat [

	^ heartbeat
]

{ #category : #accessing }
Amqp091ConnectionTune >> heartbeat: aValue [

	heartbeat := aValue
]
