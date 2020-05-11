Class {
	#name : #Amqp08ChannelClose,
	#superclass : #AmqpProtocolMethod,
	#instVars : [
		'replyCode',
		'replyText',
		'classId',
		'methodId'
	],
	#category : #'Ansible-Protocol-08'
}

{ #category : #'AMQP codec' }
Amqp08ChannelClose >> acceptableResponseClasses [

	^ {Amqp08ChannelCloseOk}
]

{ #category : #accessing }
Amqp08ChannelClose >> classId [

	^ classId
]

{ #category : #accessing }
Amqp08ChannelClose >> classId: aValue [

	classId := aValue
]

{ #category : #'AMQP codec' }
Amqp08ChannelClose >> codecMethodId [

	^ 1310760
]

{ #category : #'AMQP codec' }
Amqp08ChannelClose >> decodeFrom: codec [

	| bitBuffer |

	replyCode := codec nextShort.
	replyText := codec nextShortstr.
	classId := codec nextShort.
	methodId := codec nextShort
]

{ #category : #'AMQP codec' }
Amqp08ChannelClose >> encodeOn: codec [

	| bitBuffer |

	codec nextShortPut: replyCode.
	codec nextShortstrPut: replyText.
	codec nextShortPut: classId.
	codec nextShortPut: methodId
]

{ #category : #'AMQP codec' }
Amqp08ChannelClose >> hasContents [

	^ false
]

{ #category : #accessing }
Amqp08ChannelClose >> methodId [

	^ methodId
]

{ #category : #accessing }
Amqp08ChannelClose >> methodId: aValue [

	methodId := aValue
]

{ #category : #accessing }
Amqp08ChannelClose >> replyCode [

	^ replyCode
]

{ #category : #accessing }
Amqp08ChannelClose >> replyCode: aValue [

	replyCode := aValue
]

{ #category : #accessing }
Amqp08ChannelClose >> replyText [

	^ replyText
]

{ #category : #accessing }
Amqp08ChannelClose >> replyText: aValue [

	replyText := aValue
]
