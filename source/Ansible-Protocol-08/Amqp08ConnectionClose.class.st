Class {
	#name : #Amqp08ConnectionClose,
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
Amqp08ConnectionClose >> acceptableResponseClasses [

	^ {Amqp08ConnectionCloseOk}
]

{ #category : #accessing }
Amqp08ConnectionClose >> classId [

	^ classId
]

{ #category : #accessing }
Amqp08ConnectionClose >> classId: aValue [

	classId := aValue
]

{ #category : #'AMQP codec' }
Amqp08ConnectionClose >> codecMethodId [

	^ 655420
]

{ #category : #'AMQP codec' }
Amqp08ConnectionClose >> decodeFrom: codec [

	| bitBuffer |

	replyCode := codec nextShort.
	replyText := codec nextShortstr.
	classId := codec nextShort.
	methodId := codec nextShort
]

{ #category : #'AMQP codec' }
Amqp08ConnectionClose >> encodeOn: codec [

	| bitBuffer |

	codec nextShortPut: replyCode.
	codec nextShortstrPut: replyText.
	codec nextShortPut: classId.
	codec nextShortPut: methodId
]

{ #category : #'AMQP codec' }
Amqp08ConnectionClose >> hasContents [

	^ false
]

{ #category : #accessing }
Amqp08ConnectionClose >> methodId [

	^ methodId
]

{ #category : #accessing }
Amqp08ConnectionClose >> methodId: aValue [

	methodId := aValue
]

{ #category : #accessing }
Amqp08ConnectionClose >> replyCode [

	^ replyCode
]

{ #category : #accessing }
Amqp08ConnectionClose >> replyCode: aValue [

	replyCode := aValue
]

{ #category : #accessing }
Amqp08ConnectionClose >> replyText [

	^ replyText
]

{ #category : #accessing }
Amqp08ConnectionClose >> replyText: aValue [

	replyText := aValue
]
