Class {
	#name : #Amqp091ChannelClose,
	#superclass : #AmqpProtocolMethod,
	#instVars : [
		'replyCode',
		'replyText',
		'classId',
		'methodId'
	],
	#category : #'Ansible-Protocol-091'
}

{ #category : #'AMQP codec' }
Amqp091ChannelClose >> acceptableResponseClasses [

	^ Array with: Amqp091ChannelCloseOk
]

{ #category : #accessing }
Amqp091ChannelClose >> classId [

	^ classId
]

{ #category : #accessing }
Amqp091ChannelClose >> classId: aValue [

	classId := aValue
]

{ #category : #'AMQP codec' }
Amqp091ChannelClose >> codecMethodId [

	^ 1310760
]

{ #category : #'AMQP codec' }
Amqp091ChannelClose >> decodeFrom: codec [

	replyCode := codec nextShort.
	replyText := codec nextShortstr.
	classId := codec nextShort.
	methodId := codec nextShort
]

{ #category : #'AMQP codec' }
Amqp091ChannelClose >> encodeOn: codec [

	codec nextShortPut: replyCode.
	codec nextShortstrPut: replyText.
	codec nextShortPut: classId.
	codec nextShortPut: methodId
]

{ #category : #'AMQP codec' }
Amqp091ChannelClose >> hasContents [

	^ false
]

{ #category : #accessing }
Amqp091ChannelClose >> methodId [

	^ methodId
]

{ #category : #accessing }
Amqp091ChannelClose >> methodId: aValue [

	methodId := aValue
]

{ #category : #accessing }
Amqp091ChannelClose >> replyCode [

	^ replyCode
]

{ #category : #accessing }
Amqp091ChannelClose >> replyCode: aValue [

	replyCode := aValue
]

{ #category : #accessing }
Amqp091ChannelClose >> replyText [

	^ replyText
]

{ #category : #accessing }
Amqp091ChannelClose >> replyText: aValue [

	replyText := aValue
]
