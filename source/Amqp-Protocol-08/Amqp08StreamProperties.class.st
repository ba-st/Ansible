Class {
	#name : #Amqp08StreamProperties,
	#superclass : #AmqpProtocolProperties,
	#instVars : [
		'contentType',
		'contentEncoding',
		'headers',
		'priority',
		'timestamp'
	],
	#category : #'Amqp-Protocol-08'
}

{ #category : #'AMQP codec' }
Amqp08StreamProperties >> codecClassId [

	^ 80
]

{ #category : #accessing }
Amqp08StreamProperties >> contentEncoding [

	^ contentEncoding
]

{ #category : #accessing }
Amqp08StreamProperties >> contentEncoding: aValue [

	contentEncoding := aValue
]

{ #category : #accessing }
Amqp08StreamProperties >> contentType [

	^ contentType
]

{ #category : #accessing }
Amqp08StreamProperties >> contentType: aValue [

	contentType := aValue
]

{ #category : #'AMQP codec' }
Amqp08StreamProperties >> decodeFrom: codec [

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
		ifTrue: [ timestamp := nil ]
		ifFalse: [ timestamp := codec nextTimestamp ]
]

{ #category : #'AMQP codec' }
Amqp08StreamProperties >> encodeOn: codec [

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
	timestamp isNil
		ifFalse: [ qFlags := qFlags bitOr: 2048 ].

	self encodeFlags: qFlags on: codec.

	contentType isNil
		ifFalse: [ codec nextShortstrPut: contentType ].
	contentEncoding isNil
		ifFalse: [ codec nextShortstrPut: contentEncoding ].
	headers isNil
		ifFalse: [ codec nextTablePut: headers ].
	priority isNil
		ifFalse: [ codec nextOctetPut: priority ].
	timestamp isNil
		ifFalse: [ codec nextTimestampPut: timestamp ]
]

{ #category : #accessing }
Amqp08StreamProperties >> headers [

	^ headers
]

{ #category : #accessing }
Amqp08StreamProperties >> headers: aValue [

	headers := aValue
]

{ #category : #accessing }
Amqp08StreamProperties >> priority [

	^ priority
]

{ #category : #accessing }
Amqp08StreamProperties >> priority: aValue [

	priority := aValue
]

{ #category : #accessing }
Amqp08StreamProperties >> timestamp [

	^ timestamp
]

{ #category : #accessing }
Amqp08StreamProperties >> timestamp: aValue [

	timestamp := aValue
]
