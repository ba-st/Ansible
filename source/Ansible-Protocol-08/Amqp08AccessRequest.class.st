Class {
	#name : #Amqp08AccessRequest,
	#superclass : #AmqpProtocolMethod,
	#instVars : [
		'realm',
		'exclusive',
		'passive',
		'active',
		'write',
		'read'
	],
	#category : #'Ansible-Protocol-08'
}

{ #category : #'AMQP codec' }
Amqp08AccessRequest >> acceptableResponseClasses [

	^ {Amqp08AccessRequestOk}
]

{ #category : #accessing }
Amqp08AccessRequest >> active [

	^ active
]

{ #category : #accessing }
Amqp08AccessRequest >> active: aValue [

	active := aValue
]

{ #category : #'AMQP codec' }
Amqp08AccessRequest >> codecMethodId [

	^ 1966090
]

{ #category : #'AMQP codec' }
Amqp08AccessRequest >> decodeFrom: codec [

	| bitBuffer |

	realm := codec nextShortstr.
	bitBuffer := codec nextOctet.
	exclusive := ( bitBuffer bitAnd: 1 ) ~= 0.
	passive := ( bitBuffer bitAnd: 2 ) ~= 0.
	active := ( bitBuffer bitAnd: 4 ) ~= 0.
	write := ( bitBuffer bitAnd: 8 ) ~= 0.
	read := ( bitBuffer bitAnd: 16 ) ~= 0
]

{ #category : #'AMQP codec' }
Amqp08AccessRequest >> encodeOn: codec [

	| bitBuffer |

	codec nextShortstrPut: realm.
	bitBuffer := 0.
	( exclusive ifNil: [ false ] )
		ifTrue: [ bitBuffer := bitBuffer bitOr: 1 ].
	( passive ifNil: [ false ] )
		ifTrue: [ bitBuffer := bitBuffer bitOr: 2 ].
	( active ifNil: [ false ] )
		ifTrue: [ bitBuffer := bitBuffer bitOr: 4 ].
	( write ifNil: [ false ] )
		ifTrue: [ bitBuffer := bitBuffer bitOr: 8 ].
	( read ifNil: [ false ] )
		ifTrue: [ bitBuffer := bitBuffer bitOr: 16 ].
	codec nextOctetPut: bitBuffer
]

{ #category : #accessing }
Amqp08AccessRequest >> exclusive [

	^ exclusive
]

{ #category : #accessing }
Amqp08AccessRequest >> exclusive: aValue [

	exclusive := aValue
]

{ #category : #'AMQP codec' }
Amqp08AccessRequest >> hasContents [

	^ false
]

{ #category : #accessing }
Amqp08AccessRequest >> passive [

	^ passive
]

{ #category : #accessing }
Amqp08AccessRequest >> passive: aValue [

	passive := aValue
]

{ #category : #accessing }
Amqp08AccessRequest >> read [

	^ read
]

{ #category : #accessing }
Amqp08AccessRequest >> read: aValue [

	read := aValue
]

{ #category : #accessing }
Amqp08AccessRequest >> realm [

	^ realm
]

{ #category : #accessing }
Amqp08AccessRequest >> realm: aValue [

	realm := aValue
]

{ #category : #accessing }
Amqp08AccessRequest >> write [

	^ write
]

{ #category : #accessing }
Amqp08AccessRequest >> write: aValue [

	write := aValue
]
