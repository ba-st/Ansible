Class {
	#name : #Amqp08BasicReturn,
	#superclass : #AmqpProtocolMethod,
	#instVars : [
		'replyCode',
		'replyText',
		'exchange',
		'routingKey'
	],
	#category : #'Amqp-Protocol-08'
}

{ #category : #'AMQP codec' }
Amqp08BasicReturn >> acceptableResponseClasses [

	^ {}
]

{ #category : #'AMQP codec' }
Amqp08BasicReturn >> codecMethodId [

	^ 3932210
]

{ #category : #'AMQP codec' }
Amqp08BasicReturn >> decodeFrom: codec [

	| bitBuffer |

	replyCode := codec nextShort.
	replyText := codec nextShortstr.
	exchange := codec nextShortstr.
	routingKey := codec nextShortstr
]

{ #category : #'AMQP codec' }
Amqp08BasicReturn >> encodeOn: codec [

	| bitBuffer |

	codec nextShortPut: replyCode.
	codec nextShortstrPut: replyText.
	codec nextShortstrPut: exchange.
	codec nextShortstrPut: routingKey
]

{ #category : #accessing }
Amqp08BasicReturn >> exchange [

	^ exchange
]

{ #category : #accessing }
Amqp08BasicReturn >> exchange: aValue [

	exchange := aValue
]

{ #category : #'AMQP codec' }
Amqp08BasicReturn >> hasContents [

	^ true
]

{ #category : #accessing }
Amqp08BasicReturn >> replyCode [

	^ replyCode
]

{ #category : #accessing }
Amqp08BasicReturn >> replyCode: aValue [

	replyCode := aValue
]

{ #category : #accessing }
Amqp08BasicReturn >> replyText [

	^ replyText
]

{ #category : #accessing }
Amqp08BasicReturn >> replyText: aValue [

	replyText := aValue
]

{ #category : #accessing }
Amqp08BasicReturn >> routingKey [

	^ routingKey
]

{ #category : #accessing }
Amqp08BasicReturn >> routingKey: aValue [

	routingKey := aValue
]
