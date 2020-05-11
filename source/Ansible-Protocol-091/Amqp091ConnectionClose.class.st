Class {
	#name : #Amqp091ConnectionClose,
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
Amqp091ConnectionClose >> acceptableResponseClasses [

	^ {Amqp091ConnectionCloseOk}
]

{ #category : #accessing }
Amqp091ConnectionClose >> classId [

	^ classId
]

{ #category : #accessing }
Amqp091ConnectionClose >> classId: aValue [

	classId := aValue
]

{ #category : #'AMQP codec' }
Amqp091ConnectionClose >> codecMethodId [

	^ 655410
]

{ #category : #'AMQP codec' }
Amqp091ConnectionClose >> decodeFrom: codec [

	| bitBuffer |

	replyCode := codec nextShort.
	replyText := codec nextShortstr.
	classId := codec nextShort.
	methodId := codec nextShort
]

{ #category : #'AMQP codec' }
Amqp091ConnectionClose >> encodeOn: codec [

	| bitBuffer |

	codec nextShortPut: replyCode.
	codec nextShortstrPut: replyText.
	codec nextShortPut: classId.
	codec nextShortPut: methodId
]

{ #category : #'AMQP codec' }
Amqp091ConnectionClose >> hasContents [

	^ false
]

{ #category : #accessing }
Amqp091ConnectionClose >> methodId [

	^ methodId
]

{ #category : #accessing }
Amqp091ConnectionClose >> methodId: aValue [

	methodId := aValue
]

{ #category : #accessing }
Amqp091ConnectionClose >> replyCode [

	^ replyCode
]

{ #category : #accessing }
Amqp091ConnectionClose >> replyCode: aValue [

	replyCode := aValue
]

{ #category : #accessing }
Amqp091ConnectionClose >> replyText [

	^ replyText
]

{ #category : #accessing }
Amqp091ConnectionClose >> replyText: aValue [

	replyText := aValue
]
