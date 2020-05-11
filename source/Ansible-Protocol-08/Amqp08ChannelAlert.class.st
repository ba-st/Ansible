Class {
	#name : #Amqp08ChannelAlert,
	#superclass : #AmqpProtocolMethod,
	#instVars : [
		'replyCode',
		'replyText',
		'details'
	],
	#category : #'Ansible-Protocol-08'
}

{ #category : #'AMQP codec' }
Amqp08ChannelAlert >> acceptableResponseClasses [

	^ {}
]

{ #category : #'AMQP codec' }
Amqp08ChannelAlert >> codecMethodId [

	^ 1310750
]

{ #category : #'AMQP codec' }
Amqp08ChannelAlert >> decodeFrom: codec [

	| bitBuffer |

	replyCode := codec nextShort.
	replyText := codec nextShortstr.
	details := codec nextTable
]

{ #category : #accessing }
Amqp08ChannelAlert >> details [

	^ details
]

{ #category : #accessing }
Amqp08ChannelAlert >> details: aValue [

	details := aValue
]

{ #category : #'AMQP codec' }
Amqp08ChannelAlert >> encodeOn: codec [

	| bitBuffer |

	codec nextShortPut: replyCode.
	codec nextShortstrPut: replyText.
	codec nextTablePut: details
]

{ #category : #'AMQP codec' }
Amqp08ChannelAlert >> hasContents [

	^ false
]

{ #category : #accessing }
Amqp08ChannelAlert >> replyCode [

	^ replyCode
]

{ #category : #accessing }
Amqp08ChannelAlert >> replyCode: aValue [

	replyCode := aValue
]

{ #category : #accessing }
Amqp08ChannelAlert >> replyText [

	^ replyText
]

{ #category : #accessing }
Amqp08ChannelAlert >> replyText: aValue [

	replyText := aValue
]
