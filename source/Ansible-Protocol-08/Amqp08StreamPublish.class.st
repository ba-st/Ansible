Class {
	#name : #Amqp08StreamPublish,
	#superclass : #AmqpProtocolMethod,
	#instVars : [
		'ticket',
		'exchange',
		'routingKey',
		'mandatory',
		'immediate'
	],
	#category : #'Ansible-Protocol-08'
}

{ #category : #'AMQP codec' }
Amqp08StreamPublish >> acceptableResponseClasses [

	^ {}
]

{ #category : #'AMQP codec' }
Amqp08StreamPublish >> codecMethodId [

	^ 5242920
]

{ #category : #'AMQP codec' }
Amqp08StreamPublish >> decodeFrom: codec [

	| bitBuffer |

	ticket := codec nextShort.
	exchange := codec nextShortstr.
	routingKey := codec nextShortstr.
	bitBuffer := codec nextOctet.
	mandatory := ( bitBuffer bitAnd: 1 ) ~= 0.
	immediate := ( bitBuffer bitAnd: 2 ) ~= 0
]

{ #category : #'AMQP codec' }
Amqp08StreamPublish >> encodeOn: codec [

	| bitBuffer |

	codec nextShortPut: ticket.
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
Amqp08StreamPublish >> exchange [

	^ exchange
]

{ #category : #accessing }
Amqp08StreamPublish >> exchange: aValue [

	exchange := aValue
]

{ #category : #'AMQP codec' }
Amqp08StreamPublish >> hasContents [

	^ true
]

{ #category : #accessing }
Amqp08StreamPublish >> immediate [

	^ immediate
]

{ #category : #accessing }
Amqp08StreamPublish >> immediate: aValue [

	immediate := aValue
]

{ #category : #accessing }
Amqp08StreamPublish >> mandatory [

	^ mandatory
]

{ #category : #accessing }
Amqp08StreamPublish >> mandatory: aValue [

	mandatory := aValue
]

{ #category : #accessing }
Amqp08StreamPublish >> routingKey [

	^ routingKey
]

{ #category : #accessing }
Amqp08StreamPublish >> routingKey: aValue [

	routingKey := aValue
]

{ #category : #accessing }
Amqp08StreamPublish >> ticket [

	^ ticket
]

{ #category : #accessing }
Amqp08StreamPublish >> ticket: aValue [

	ticket := aValue
]
