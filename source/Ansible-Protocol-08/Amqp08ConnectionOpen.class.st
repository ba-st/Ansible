Class {
	#name : #Amqp08ConnectionOpen,
	#superclass : #AmqpProtocolMethod,
	#instVars : [
		'virtualHost',
		'capabilities',
		'insist'
	],
	#category : #'Ansible-Protocol-08'
}

{ #category : #'AMQP codec' }
Amqp08ConnectionOpen >> acceptableResponseClasses [

	^ {Amqp08ConnectionOpenOk.
	Amqp08ConnectionRedirect}
]

{ #category : #accessing }
Amqp08ConnectionOpen >> capabilities [

	^ capabilities
]

{ #category : #accessing }
Amqp08ConnectionOpen >> capabilities: aValue [

	capabilities := aValue
]

{ #category : #'AMQP codec' }
Amqp08ConnectionOpen >> codecMethodId [

	^ 655400
]

{ #category : #'AMQP codec' }
Amqp08ConnectionOpen >> decodeFrom: codec [

	| bitBuffer |

	virtualHost := codec nextShortstr.
	capabilities := codec nextShortstr.
	bitBuffer := codec nextOctet.
	insist := ( bitBuffer bitAnd: 1 ) ~= 0
]

{ #category : #'AMQP codec' }
Amqp08ConnectionOpen >> encodeOn: codec [

	| bitBuffer |

	codec nextShortstrPut: virtualHost.
	codec nextShortstrPut: capabilities.
	bitBuffer := 0.
	( insist ifNil: [ false ] )
		ifTrue: [ bitBuffer := bitBuffer bitOr: 1 ].
	codec nextOctetPut: bitBuffer
]

{ #category : #'AMQP codec' }
Amqp08ConnectionOpen >> hasContents [

	^ false
]

{ #category : #accessing }
Amqp08ConnectionOpen >> insist [

	^ insist
]

{ #category : #accessing }
Amqp08ConnectionOpen >> insist: aValue [

	insist := aValue
]

{ #category : #accessing }
Amqp08ConnectionOpen >> virtualHost [

	^ virtualHost
]

{ #category : #accessing }
Amqp08ConnectionOpen >> virtualHost: aValue [

	virtualHost := aValue
]
