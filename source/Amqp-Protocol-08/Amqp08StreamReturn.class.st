Class {
	#name : #Amqp08StreamReturn,
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
Amqp08StreamReturn >> acceptableResponseClasses [

	^ {}
]

{ #category : #'AMQP codec' }
Amqp08StreamReturn >> codecMethodId [

	^ 5242930
]

{ #category : #'AMQP codec' }
Amqp08StreamReturn >> decodeFrom: codec [

	| bitBuffer |

	replyCode := codec nextShort.
	replyText := codec nextShortstr.
	exchange := codec nextShortstr.
	routingKey := codec nextShortstr
]

{ #category : #'AMQP codec' }
Amqp08StreamReturn >> encodeOn: codec [

	| bitBuffer |

	codec nextShortPut: replyCode.
	codec nextShortstrPut: replyText.
	codec nextShortstrPut: exchange.
	codec nextShortstrPut: routingKey
]

{ #category : #accessing }
Amqp08StreamReturn >> exchange [

	^ exchange
]

{ #category : #accessing }
Amqp08StreamReturn >> exchange: aValue [

	exchange := aValue
]

{ #category : #'AMQP codec' }
Amqp08StreamReturn >> hasContents [

	^ true
]

{ #category : #accessing }
Amqp08StreamReturn >> replyCode [

	^ replyCode
]

{ #category : #accessing }
Amqp08StreamReturn >> replyCode: aValue [

	replyCode := aValue
]

{ #category : #accessing }
Amqp08StreamReturn >> replyText [

	^ replyText
]

{ #category : #accessing }
Amqp08StreamReturn >> replyText: aValue [

	replyText := aValue
]

{ #category : #accessing }
Amqp08StreamReturn >> routingKey [

	^ routingKey
]

{ #category : #accessing }
Amqp08StreamReturn >> routingKey: aValue [

	routingKey := aValue
]
