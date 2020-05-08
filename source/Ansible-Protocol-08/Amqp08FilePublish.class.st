Class {
	#name : #Amqp08FilePublish,
	#superclass : #AmqpProtocolMethod,
	#instVars : [
		'ticket',
		'exchange',
		'routingKey',
		'mandatory',
		'immediate',
		'identifier'
	],
	#category : #'Ansible-Protocol-08'
}

{ #category : #'AMQP codec' }
Amqp08FilePublish >> acceptableResponseClasses [

	^ {}
]

{ #category : #'AMQP codec' }
Amqp08FilePublish >> codecMethodId [

	^ 4587580
]

{ #category : #'AMQP codec' }
Amqp08FilePublish >> decodeFrom: codec [

	| bitBuffer |

	ticket := codec nextShort.
	exchange := codec nextShortstr.
	routingKey := codec nextShortstr.
	bitBuffer := codec nextOctet.
	mandatory := ( bitBuffer bitAnd: 1 ) ~= 0.
	immediate := ( bitBuffer bitAnd: 2 ) ~= 0.
	identifier := codec nextShortstr
]

{ #category : #'AMQP codec' }
Amqp08FilePublish >> encodeOn: codec [

	| bitBuffer |

	codec nextShortPut: ticket.
	codec nextShortstrPut: exchange.
	codec nextShortstrPut: routingKey.
	bitBuffer := 0.
	( mandatory ifNil: [ false ] )
		ifTrue: [ bitBuffer := bitBuffer bitOr: 1 ].
	( immediate ifNil: [ false ] )
		ifTrue: [ bitBuffer := bitBuffer bitOr: 2 ].
	codec nextOctetPut: bitBuffer.
	codec nextShortstrPut: identifier
]

{ #category : #accessing }
Amqp08FilePublish >> exchange [

	^ exchange
]

{ #category : #accessing }
Amqp08FilePublish >> exchange: aValue [

	exchange := aValue
]

{ #category : #'AMQP codec' }
Amqp08FilePublish >> hasContents [

	^ false
]

{ #category : #accessing }
Amqp08FilePublish >> identifier [

	^ identifier
]

{ #category : #accessing }
Amqp08FilePublish >> identifier: aValue [

	identifier := aValue
]

{ #category : #accessing }
Amqp08FilePublish >> immediate [

	^ immediate
]

{ #category : #accessing }
Amqp08FilePublish >> immediate: aValue [

	immediate := aValue
]

{ #category : #accessing }
Amqp08FilePublish >> mandatory [

	^ mandatory
]

{ #category : #accessing }
Amqp08FilePublish >> mandatory: aValue [

	mandatory := aValue
]

{ #category : #accessing }
Amqp08FilePublish >> routingKey [

	^ routingKey
]

{ #category : #accessing }
Amqp08FilePublish >> routingKey: aValue [

	routingKey := aValue
]

{ #category : #accessing }
Amqp08FilePublish >> ticket [

	^ ticket
]

{ #category : #accessing }
Amqp08FilePublish >> ticket: aValue [

	ticket := aValue
]
