Class {
	#name : #Amqp08FileProperties,
	#superclass : #AmqpProtocolProperties,
	#instVars : [
		'contentType',
		'contentEncoding',
		'headers',
		'priority',
		'replyTo',
		'messageId',
		'filename',
		'timestamp',
		'clusterId'
	],
	#category : #'Amqp-Protocol-08'
}

{ #category : #accessing }
Amqp08FileProperties >> clusterId [

	^ clusterId
]

{ #category : #accessing }
Amqp08FileProperties >> clusterId: aValue [

	clusterId := aValue
]

{ #category : #'AMQP codec' }
Amqp08FileProperties >> codecClassId [

	^ 70
]

{ #category : #accessing }
Amqp08FileProperties >> contentEncoding [

	^ contentEncoding
]

{ #category : #accessing }
Amqp08FileProperties >> contentEncoding: aValue [

	contentEncoding := aValue
]

{ #category : #accessing }
Amqp08FileProperties >> contentType [

	^ contentType
]

{ #category : #accessing }
Amqp08FileProperties >> contentType: aValue [

	contentType := aValue
]

{ #category : #'AMQP codec' }
Amqp08FileProperties >> decodeFrom: codec [

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
		ifTrue: [ priority := nil ]
		ifFalse: [ priority := codec nextOctet ].
	( qFlags bitAnd: 2048 ) = 0
		ifTrue: [ replyTo := nil ]
		ifFalse: [ replyTo := codec nextShortstr ].
	( qFlags bitAnd: 1024 ) = 0
		ifTrue: [ messageId := nil ]
		ifFalse: [ messageId := codec nextShortstr ].
	( qFlags bitAnd: 512 ) = 0
		ifTrue: [ filename := nil ]
		ifFalse: [ filename := codec nextShortstr ].
	( qFlags bitAnd: 256 ) = 0
		ifTrue: [ timestamp := nil ]
		ifFalse: [ timestamp := codec nextTimestamp ].
	( qFlags bitAnd: 128 ) = 0
		ifTrue: [ clusterId := nil ]
		ifFalse: [ clusterId := codec nextShortstr ]
]

{ #category : #'AMQP codec' }
Amqp08FileProperties >> encodeOn: codec [

	| qFlags |

	qFlags := 0.

	contentType isNil
		ifFalse: [ qFlags := qFlags bitOr: 32768 ].
	contentEncoding isNil
		ifFalse: [ qFlags := qFlags bitOr: 16384 ].
	headers isNil
		ifFalse: [ qFlags := qFlags bitOr: 8192 ].
	priority isNil
		ifFalse: [ qFlags := qFlags bitOr: 4096 ].
	replyTo isNil
		ifFalse: [ qFlags := qFlags bitOr: 2048 ].
	messageId isNil
		ifFalse: [ qFlags := qFlags bitOr: 1024 ].
	filename isNil
		ifFalse: [ qFlags := qFlags bitOr: 512 ].
	timestamp isNil
		ifFalse: [ qFlags := qFlags bitOr: 256 ].
	clusterId isNil
		ifFalse: [ qFlags := qFlags bitOr: 128 ].

	self encodeFlags: qFlags on: codec.

	contentType isNil
		ifFalse: [ codec nextShortstrPut: contentType ].
	contentEncoding isNil
		ifFalse: [ codec nextShortstrPut: contentEncoding ].
	headers isNil
		ifFalse: [ codec nextTablePut: headers ].
	priority isNil
		ifFalse: [ codec nextOctetPut: priority ].
	replyTo isNil
		ifFalse: [ codec nextShortstrPut: replyTo ].
	messageId isNil
		ifFalse: [ codec nextShortstrPut: messageId ].
	filename isNil
		ifFalse: [ codec nextShortstrPut: filename ].
	timestamp isNil
		ifFalse: [ codec nextTimestampPut: timestamp ].
	clusterId isNil
		ifFalse: [ codec nextShortstrPut: clusterId ]
]

{ #category : #accessing }
Amqp08FileProperties >> filename [

	^ filename
]

{ #category : #accessing }
Amqp08FileProperties >> filename: aValue [

	filename := aValue
]

{ #category : #accessing }
Amqp08FileProperties >> headers [

	^ headers
]

{ #category : #accessing }
Amqp08FileProperties >> headers: aValue [

	headers := aValue
]

{ #category : #accessing }
Amqp08FileProperties >> messageId [

	^ messageId
]

{ #category : #accessing }
Amqp08FileProperties >> messageId: aValue [

	messageId := aValue
]

{ #category : #accessing }
Amqp08FileProperties >> priority [

	^ priority
]

{ #category : #accessing }
Amqp08FileProperties >> priority: aValue [

	priority := aValue
]

{ #category : #accessing }
Amqp08FileProperties >> replyTo [

	^ replyTo
]

{ #category : #accessing }
Amqp08FileProperties >> replyTo: aValue [

	replyTo := aValue
]

{ #category : #accessing }
Amqp08FileProperties >> timestamp [

	^ timestamp
]

{ #category : #accessing }
Amqp08FileProperties >> timestamp: aValue [

	timestamp := aValue
]
