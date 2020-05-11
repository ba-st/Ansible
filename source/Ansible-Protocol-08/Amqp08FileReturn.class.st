Class {
	#name : #Amqp08FileReturn,
	#superclass : #AmqpProtocolMethod,
	#instVars : [
		'replyCode',
		'replyText',
		'exchange',
		'routingKey'
	],
	#category : #'Ansible-Protocol-08'
}

{ #category : #'AMQP codec' }
Amqp08FileReturn >> acceptableResponseClasses [

	^ {}
]

{ #category : #'AMQP codec' }
Amqp08FileReturn >> codecMethodId [

	^ 4587590
]

{ #category : #'AMQP codec' }
Amqp08FileReturn >> decodeFrom: codec [

	| bitBuffer |

	replyCode := codec nextShort.
	replyText := codec nextShortstr.
	exchange := codec nextShortstr.
	routingKey := codec nextShortstr
]

{ #category : #'AMQP codec' }
Amqp08FileReturn >> encodeOn: codec [

	| bitBuffer |

	codec nextShortPut: replyCode.
	codec nextShortstrPut: replyText.
	codec nextShortstrPut: exchange.
	codec nextShortstrPut: routingKey
]

{ #category : #accessing }
Amqp08FileReturn >> exchange [

	^ exchange
]

{ #category : #accessing }
Amqp08FileReturn >> exchange: aValue [

	exchange := aValue
]

{ #category : #'AMQP codec' }
Amqp08FileReturn >> hasContents [

	^ true
]

{ #category : #accessing }
Amqp08FileReturn >> replyCode [

	^ replyCode
]

{ #category : #accessing }
Amqp08FileReturn >> replyCode: aValue [

	replyCode := aValue
]

{ #category : #accessing }
Amqp08FileReturn >> replyText [

	^ replyText
]

{ #category : #accessing }
Amqp08FileReturn >> replyText: aValue [

	replyText := aValue
]

{ #category : #accessing }
Amqp08FileReturn >> routingKey [

	^ routingKey
]

{ #category : #accessing }
Amqp08FileReturn >> routingKey: aValue [

	routingKey := aValue
]
