Class {
	#name : #Amqp091BasicReturn,
	#superclass : #AmqpProtocolMethod,
	#instVars : [
		'replyCode',
		'replyText',
		'exchange',
		'routingKey'
	],
	#category : #'Ansible-Protocol-091'
}

{ #category : #'AMQP codec' }
Amqp091BasicReturn >> acceptableResponseClasses [

	^ #()
]

{ #category : #'AMQP codec' }
Amqp091BasicReturn >> codecMethodId [

	^ 3932210
]

{ #category : #'AMQP codec' }
Amqp091BasicReturn >> decodeFrom: codec [

	replyCode := codec nextShort.
	replyText := codec nextShortstr.
	exchange := codec nextShortstr.
	routingKey := codec nextShortstr
]

{ #category : #'AMQP codec' }
Amqp091BasicReturn >> encodeOn: codec [

	codec nextShortPut: replyCode.
	codec nextShortstrPut: replyText.
	codec nextShortstrPut: exchange.
	codec nextShortstrPut: routingKey
]

{ #category : #accessing }
Amqp091BasicReturn >> exchange [

	^ exchange
]

{ #category : #accessing }
Amqp091BasicReturn >> exchange: aValue [

	exchange := aValue
]

{ #category : #'AMQP codec' }
Amqp091BasicReturn >> hasContents [

	^ true
]

{ #category : #accessing }
Amqp091BasicReturn >> replyCode [

	^ replyCode
]

{ #category : #accessing }
Amqp091BasicReturn >> replyCode: aValue [

	replyCode := aValue
]

{ #category : #accessing }
Amqp091BasicReturn >> replyText [

	^ replyText
]

{ #category : #accessing }
Amqp091BasicReturn >> replyText: aValue [

	replyText := aValue
]

{ #category : #accessing }
Amqp091BasicReturn >> routingKey [

	^ routingKey
]

{ #category : #accessing }
Amqp091BasicReturn >> routingKey: aValue [

	routingKey := aValue
]
