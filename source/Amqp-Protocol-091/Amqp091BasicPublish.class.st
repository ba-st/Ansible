Class {
	#name : #Amqp091BasicPublish,
	#superclass : #AmqpProtocolMethod,
	#instVars : [
		'exchange',
		'routingKey',
		'mandatory',
		'immediate'
	],
	#category : #'Amqp-Protocol-091'
}

{ #category : #'AMQP codec' }
Amqp091BasicPublish >> acceptableResponseClasses [

	^ {}
]

{ #category : #'AMQP codec' }
Amqp091BasicPublish >> codecMethodId [

	^ 3932200
]

{ #category : #'AMQP codec' }
Amqp091BasicPublish >> decodeFrom: codec [

	| bitBuffer |

	codec nextShort.
	exchange := codec nextShortstr.
	routingKey := codec nextShortstr.
	bitBuffer := codec nextOctet.
	mandatory := ( bitBuffer bitAnd: 1 ) ~= 0.
	immediate := ( bitBuffer bitAnd: 2 ) ~= 0
]

{ #category : #'AMQP codec' }
Amqp091BasicPublish >> encodeOn: codec [

	| bitBuffer |

	codec nextShortPut: 0.
	codec nextShortstrPut: exchange.
	codec nextShortstrPut: routingKey.
	bitBuffer := 0.
	( mandatory ifNil: [ false ] )
		ifTrue: [ bitBuffer := bitBuffer bitOr: 1 ].
	( immediate ifNil: [ false ] )
		ifTrue: [ bitBuffer := bitBuffer bitOr: 2 ].
	codec nextOctetPut: bitBuffer
]

{ #category : #accessing }
Amqp091BasicPublish >> exchange [

	^ exchange
]

{ #category : #accessing }
Amqp091BasicPublish >> exchange: aValue [

	exchange := aValue
]

{ #category : #'AMQP codec' }
Amqp091BasicPublish >> hasContents [

	^ true
]

{ #category : #accessing }
Amqp091BasicPublish >> immediate [

	^ immediate
]

{ #category : #accessing }
Amqp091BasicPublish >> immediate: aValue [

	immediate := aValue
]

{ #category : #accessing }
Amqp091BasicPublish >> mandatory [

	^ mandatory
]

{ #category : #accessing }
Amqp091BasicPublish >> mandatory: aValue [

	mandatory := aValue
]

{ #category : #accessing }
Amqp091BasicPublish >> routingKey [

	^ routingKey
]

{ #category : #accessing }
Amqp091BasicPublish >> routingKey: aValue [

	routingKey := aValue
]
