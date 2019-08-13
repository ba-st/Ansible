Class {
	#name : #Amqp08BasicProperties,
	#superclass : #AmqpProtocolProperties,
	#instVars : [
		'contentType',
		'contentEncoding',
		'headers',
		'deliveryMode',
		'priority',
		'correlationId',
		'replyTo',
		'expiration',
		'messageId',
		'timestamp',
		'type',
		'userId',
		'appId',
		'clusterId'
	],
	#category : #'Amqp-Protocol-08'
}

{ #category : #accessing }
Amqp08BasicProperties >> appId [

	^ appId
]

{ #category : #accessing }
Amqp08BasicProperties >> appId: aValue [

	appId := aValue
]

{ #category : #accessing }
Amqp08BasicProperties >> clusterId [

	^ clusterId
]

{ #category : #accessing }
Amqp08BasicProperties >> clusterId: aValue [

	clusterId := aValue
]

{ #category : #'AMQP codec' }
Amqp08BasicProperties >> codecClassId [

	^ 60
]

{ #category : #accessing }
Amqp08BasicProperties >> contentEncoding [

	^ contentEncoding
]

{ #category : #accessing }
Amqp08BasicProperties >> contentEncoding: aValue [

	contentEncoding := aValue
]

{ #category : #accessing }
Amqp08BasicProperties >> contentType [

	^ contentType
]

{ #category : #accessing }
Amqp08BasicProperties >> contentType: aValue [

	contentType := aValue
]

{ #category : #accessing }
Amqp08BasicProperties >> correlationId [

	^ correlationId
]

{ #category : #accessing }
Amqp08BasicProperties >> correlationId: aValue [

	correlationId := aValue
]

{ #category : #'AMQP codec' }
Amqp08BasicProperties >> decodeFrom: codec [

	| qFlags |

	qFlags := self decodeFlagsFrom: codec.
	( qFlags bitAnd: 32768 ) = 0
		ifTrue: [ contentType := nil ]
		ifFalse: [ contentType := codec nextShortstr ].
	( qFlags bitAnd: 16384 ) = 0
		ifTrue: [ contentEncoding := nil ]
		ifFalse: [ contentEncoding := codec nextShortstr ].
	( qFlags bitAnd: 8192 ) = 0
		ifTrue: [ headers := nil ]
		ifFalse: [ headers := codec nextTable ].
	( qFlags bitAnd: 4096 ) = 0
		ifTrue: [ deliveryMode := nil ]
		ifFalse: [ deliveryMode := codec nextOctet ].
	( qFlags bitAnd: 2048 ) = 0
		ifTrue: [ priority := nil ]
		ifFalse: [ priority := codec nextOctet ].
	( qFlags bitAnd: 1024 ) = 0
		ifTrue: [ correlationId := nil ]
		ifFalse: [ correlationId := codec nextShortstr ].
	( qFlags bitAnd: 512 ) = 0
		ifTrue: [ replyTo := nil ]
		ifFalse: [ replyTo := codec nextShortstr ].
	( qFlags bitAnd: 256 ) = 0
		ifTrue: [ expiration := nil ]
		ifFalse: [ expiration := codec nextShortstr ].
	( qFlags bitAnd: 128 ) = 0
		ifTrue: [ messageId := nil ]
		ifFalse: [ messageId := codec nextShortstr ].
	( qFlags bitAnd: 64 ) = 0
		ifTrue: [ timestamp := nil ]
		ifFalse: [ timestamp := codec nextTimestamp ].
	( qFlags bitAnd: 32 ) = 0
		ifTrue: [ type := nil ]
		ifFalse: [ type := codec nextShortstr ].
	( qFlags bitAnd: 16 ) = 0
		ifTrue: [ userId := nil ]
		ifFalse: [ userId := codec nextShortstr ].
	( qFlags bitAnd: 8 ) = 0
		ifTrue: [ appId := nil ]
		ifFalse: [ appId := codec nextShortstr ].
	( qFlags bitAnd: 4 ) = 0
		ifTrue: [ clusterId := nil ]
		ifFalse: [ clusterId := codec nextShortstr ]
]

{ #category : #accessing }
Amqp08BasicProperties >> deliveryMode [

	^ deliveryMode
]

{ #category : #accessing }
Amqp08BasicProperties >> deliveryMode: aValue [

	deliveryMode := aValue
]

{ #category : #'AMQP codec' }
Amqp08BasicProperties >> encodeOn: codec [

	| qFlags |

	qFlags := 0.

	contentType isNil
		ifFalse: [ qFlags := qFlags bitOr: 32768 ].
	contentEncoding isNil
		ifFalse: [ qFlags := qFlags bitOr: 16384 ].
	headers isNil
		ifFalse: [ qFlags := qFlags bitOr: 8192 ].
	deliveryMode isNil
		ifFalse: [ qFlags := qFlags bitOr: 4096 ].
	priority isNil
		ifFalse: [ qFlags := qFlags bitOr: 2048 ].
	correlationId isNil
		ifFalse: [ qFlags := qFlags bitOr: 1024 ].
	replyTo isNil
		ifFalse: [ qFlags := qFlags bitOr: 512 ].
	expiration isNil
		ifFalse: [ qFlags := qFlags bitOr: 256 ].
	messageId isNil
		ifFalse: [ qFlags := qFlags bitOr: 128 ].
	timestamp isNil
		ifFalse: [ qFlags := qFlags bitOr: 64 ].
	type isNil
		ifFalse: [ qFlags := qFlags bitOr: 32 ].
	userId isNil
		ifFalse: [ qFlags := qFlags bitOr: 16 ].
	appId isNil
		ifFalse: [ qFlags := qFlags bitOr: 8 ].
	clusterId isNil
		ifFalse: [ qFlags := qFlags bitOr: 4 ].

	self encodeFlags: qFlags on: codec.

	contentType isNil
		ifFalse: [ codec nextShortstrPut: contentType ].
	contentEncoding isNil
		ifFalse: [ codec nextShortstrPut: contentEncoding ].
	headers isNil
		ifFalse: [ codec nextTablePut: headers ].
	deliveryMode isNil
		ifFalse: [ codec nextOctetPut: deliveryMode ].
	priority isNil
		ifFalse: [ codec nextOctetPut: priority ].
	correlationId isNil
		ifFalse: [ codec nextShortstrPut: correlationId ].
	replyTo isNil
		ifFalse: [ codec nextShortstrPut: replyTo ].
	expiration isNil
		ifFalse: [ codec nextShortstrPut: expiration ].
	messageId isNil
		ifFalse: [ codec nextShortstrPut: messageId ].
	timestamp isNil
		ifFalse: [ codec nextTimestampPut: timestamp ].
	type isNil
		ifFalse: [ codec nextShortstrPut: type ].
	userId isNil
		ifFalse: [ codec nextShortstrPut: userId ].
	appId isNil
		ifFalse: [ codec nextShortstrPut: appId ].
	clusterId isNil
		ifFalse: [ codec nextShortstrPut: clusterId ]
]

{ #category : #accessing }
Amqp08BasicProperties >> expiration [

	^ expiration
]

{ #category : #accessing }
Amqp08BasicProperties >> expiration: aValue [

	expiration := aValue
]

{ #category : #accessing }
Amqp08BasicProperties >> headers [

	^ headers
]

{ #category : #accessing }
Amqp08BasicProperties >> headers: aValue [

	headers := aValue
]

{ #category : #accessing }
Amqp08BasicProperties >> messageId [

	^ messageId
]

{ #category : #accessing }
Amqp08BasicProperties >> messageId: aValue [

	messageId := aValue
]

{ #category : #accessing }
Amqp08BasicProperties >> priority [

	^ priority
]

{ #category : #accessing }
Amqp08BasicProperties >> priority: aValue [

	priority := aValue
]

{ #category : #accessing }
Amqp08BasicProperties >> replyTo [

	^ replyTo
]

{ #category : #accessing }
Amqp08BasicProperties >> replyTo: aValue [

	replyTo := aValue
]

{ #category : #accessing }
Amqp08BasicProperties >> timestamp [

	^ timestamp
]

{ #category : #accessing }
Amqp08BasicProperties >> timestamp: aValue [

	timestamp := aValue
]

{ #category : #accessing }
Amqp08BasicProperties >> type [

	^ type
]

{ #category : #accessing }
Amqp08BasicProperties >> type: aValue [

	type := aValue
]

{ #category : #accessing }
Amqp08BasicProperties >> userId [

	^ userId
]

{ #category : #accessing }
Amqp08BasicProperties >> userId: aValue [

	userId := aValue
]
