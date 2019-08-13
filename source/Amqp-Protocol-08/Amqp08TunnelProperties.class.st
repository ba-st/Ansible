Class {
	#name : #Amqp08TunnelProperties,
	#superclass : #AmqpProtocolProperties,
	#instVars : [
		'headers',
		'proxyName',
		'dataName',
		'durable',
		'broadcast'
	],
	#category : #'Amqp-Protocol-08'
}

{ #category : #accessing }
Amqp08TunnelProperties >> broadcast [

	^ broadcast
]

{ #category : #accessing }
Amqp08TunnelProperties >> broadcast: aValue [

	broadcast := aValue
]

{ #category : #'AMQP codec' }
Amqp08TunnelProperties >> codecClassId [

	^ 110
]

{ #category : #accessing }
Amqp08TunnelProperties >> dataName [

	^ dataName
]

{ #category : #accessing }
Amqp08TunnelProperties >> dataName: aValue [

	dataName := aValue
]

{ #category : #'AMQP codec' }
Amqp08TunnelProperties >> decodeFrom: codec [

	| qFlags |

	qFlags := self decodeFlagsFrom: codec.
	( qFlags bitAnd: 32768 ) = 0
		ifTrue: [ headers := nil ]
		ifFalse: [ headers := codec nextTable ].
	( qFlags bitAnd: 16384 ) = 0
		ifTrue: [ proxyName := nil ]
		ifFalse: [ proxyName := codec nextShortstr ].
	( qFlags bitAnd: 8192 ) = 0
		ifTrue: [ dataName := nil ]
		ifFalse: [ dataName := codec nextShortstr ].
	( qFlags bitAnd: 4096 ) = 0
		ifTrue: [ durable := nil ]
		ifFalse: [ durable := codec nextOctet ].
	( qFlags bitAnd: 2048 ) = 0
		ifTrue: [ broadcast := nil ]
		ifFalse: [ broadcast := codec nextOctet ]
]

{ #category : #accessing }
Amqp08TunnelProperties >> durable [

	^ durable
]

{ #category : #accessing }
Amqp08TunnelProperties >> durable: aValue [

	durable := aValue
]

{ #category : #'AMQP codec' }
Amqp08TunnelProperties >> encodeOn: codec [

	| qFlags |

	qFlags := 0.

	headers isNil
		ifFalse: [ qFlags := qFlags bitOr: 32768 ].
	proxyName isNil
		ifFalse: [ qFlags := qFlags bitOr: 16384 ].
	dataName isNil
		ifFalse: [ qFlags := qFlags bitOr: 8192 ].
	durable isNil
		ifFalse: [ qFlags := qFlags bitOr: 4096 ].
	broadcast isNil
		ifFalse: [ qFlags := qFlags bitOr: 2048 ].

	self encodeFlags: qFlags on: codec.

	headers isNil
		ifFalse: [ codec nextTablePut: headers ].
	proxyName isNil
		ifFalse: [ codec nextShortstrPut: proxyName ].
	dataName isNil
		ifFalse: [ codec nextShortstrPut: dataName ].
	durable isNil
		ifFalse: [ codec nextOctetPut: durable ].
	broadcast isNil
		ifFalse: [ codec nextOctetPut: broadcast ]
]

{ #category : #accessing }
Amqp08TunnelProperties >> headers [

	^ headers
]

{ #category : #accessing }
Amqp08TunnelProperties >> headers: aValue [

	headers := aValue
]

{ #category : #accessing }
Amqp08TunnelProperties >> proxyName [

	^ proxyName
]

{ #category : #accessing }
Amqp08TunnelProperties >> proxyName: aValue [

	proxyName := aValue
]
