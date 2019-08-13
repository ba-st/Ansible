Class {
	#name : #Amqp08ConnectionTune,
	#superclass : #AmqpProtocolMethod,
	#instVars : [
		'channelMax',
		'frameMax',
		'heartbeat'
	],
	#category : #'Amqp-Protocol-08'
}

{ #category : #'AMQP codec' }
Amqp08ConnectionTune >> acceptableResponseClasses [

	^ {Amqp08ConnectionTuneOk}
]

{ #category : #accessing }
Amqp08ConnectionTune >> channelMax [

	^ channelMax
]

{ #category : #accessing }
Amqp08ConnectionTune >> channelMax: aValue [

	channelMax := aValue
]

{ #category : #'AMQP codec' }
Amqp08ConnectionTune >> codecMethodId [

	^ 655390
]

{ #category : #'AMQP codec' }
Amqp08ConnectionTune >> decodeFrom: codec [

	| bitBuffer |

	channelMax := codec nextShort.
	frameMax := codec nextLong.
	heartbeat := codec nextShort
]

{ #category : #'AMQP codec' }
Amqp08ConnectionTune >> encodeOn: codec [

	| bitBuffer |

	codec nextShortPut: channelMax.
	codec nextLongPut: frameMax.
	codec nextShortPut: heartbeat
]

{ #category : #accessing }
Amqp08ConnectionTune >> frameMax [

	^ frameMax
]

{ #category : #accessing }
Amqp08ConnectionTune >> frameMax: aValue [

	frameMax := aValue
]

{ #category : #'AMQP codec' }
Amqp08ConnectionTune >> hasContents [

	^ false
]

{ #category : #accessing }
Amqp08ConnectionTune >> heartbeat [

	^ heartbeat
]

{ #category : #accessing }
Amqp08ConnectionTune >> heartbeat: aValue [

	heartbeat := aValue
]
