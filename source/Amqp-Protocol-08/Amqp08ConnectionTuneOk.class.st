Class {
	#name : #Amqp08ConnectionTuneOk,
	#superclass : #AmqpProtocolMethod,
	#instVars : [
		'channelMax',
		'frameMax',
		'heartbeat'
	],
	#category : #'Amqp-Protocol-08'
}

{ #category : #'AMQP codec' }
Amqp08ConnectionTuneOk >> acceptableResponseClasses [

	^ {}
]

{ #category : #accessing }
Amqp08ConnectionTuneOk >> channelMax [

	^ channelMax
]

{ #category : #accessing }
Amqp08ConnectionTuneOk >> channelMax: aValue [

	channelMax := aValue
]

{ #category : #'AMQP codec' }
Amqp08ConnectionTuneOk >> codecMethodId [

	^ 655391
]

{ #category : #'AMQP codec' }
Amqp08ConnectionTuneOk >> decodeFrom: codec [

	| bitBuffer |

	channelMax := codec nextShort.
	frameMax := codec nextLong.
	heartbeat := codec nextShort
]

{ #category : #'AMQP codec' }
Amqp08ConnectionTuneOk >> encodeOn: codec [

	| bitBuffer |

	codec nextShortPut: channelMax.
	codec nextLongPut: frameMax.
	codec nextShortPut: heartbeat
]

{ #category : #accessing }
Amqp08ConnectionTuneOk >> frameMax [

	^ frameMax
]

{ #category : #accessing }
Amqp08ConnectionTuneOk >> frameMax: aValue [

	frameMax := aValue
]

{ #category : #'AMQP codec' }
Amqp08ConnectionTuneOk >> hasContents [

	^ false
]

{ #category : #accessing }
Amqp08ConnectionTuneOk >> heartbeat [

	^ heartbeat
]

{ #category : #accessing }
Amqp08ConnectionTuneOk >> heartbeat: aValue [

	heartbeat := aValue
]
