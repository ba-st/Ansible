Class {
	#name : #Amqp08BasicPublish,
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
Amqp08BasicPublish >> acceptableResponseClasses [

	^ {}
]

{ #category : #'AMQP codec' }
Amqp08BasicPublish >> codecMethodId [

	^ 3932200
]

{ #category : #'AMQP codec' }
Amqp08BasicPublish >> decodeFrom: codec [

	| bitBuffer |

	ticket := codec nextShort.
	exchange := codec nextShortstr.
	routingKey := codec nextShortstr.
	bitBuffer := codec nextOctet.
	mandatory := ( bitBuffer bitAnd: 1 ) ~= 0.
	immediate := ( bitBuffer bitAnd: 2 ) ~= 0
]

{ #category : #'AMQP codec' }
Amqp08BasicPublish >> encodeOn: codec [

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
Amqp08BasicPublish >> exchange [

	^ exchange
]

{ #category : #accessing }
Amqp08BasicPublish >> exchange: aValue [

	exchange := aValue
]

{ #category : #'AMQP codec' }
Amqp08BasicPublish >> hasContents [

	^ true
]

{ #category : #accessing }
Amqp08BasicPublish >> immediate [

	^ immediate
]

{ #category : #accessing }
Amqp08BasicPublish >> immediate: aValue [

	immediate := aValue
]

{ #category : #accessing }
Amqp08BasicPublish >> mandatory [

	^ mandatory
]

{ #category : #accessing }
Amqp08BasicPublish >> mandatory: aValue [

	mandatory := aValue
]

{ #category : #accessing }
Amqp08BasicPublish >> routingKey [

	^ routingKey
]

{ #category : #accessing }
Amqp08BasicPublish >> routingKey: aValue [

	routingKey := aValue
]

{ #category : #accessing }
Amqp08BasicPublish >> ticket [

	^ ticket
]

{ #category : #accessing }
Amqp08BasicPublish >> ticket: aValue [

	ticket := aValue
]
