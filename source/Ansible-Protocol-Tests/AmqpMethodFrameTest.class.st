Class {
	#name : #AmqpMethodFrameTest,
	#superclass : #TestCase,
	#instVars : [
		'message'
	],
	#category : #'Ansible-Protocol-Tests'
}

{ #category : #mocking }
AmqpMethodFrameTest >> codec [

	^ AmqpCodec on: (ReadStream on: message)
]

{ #category : #streaming }
AmqpMethodFrameTest >> nextLongPut: anObject on: aWriteStream [ 

	aWriteStream nextPutAll: (anObject asByteArrayOfSize: 4)
]

{ #category : #streaming }
AmqpMethodFrameTest >> nextLongstrPut: aValue on: aWriteStream [ 

	self nextLongPut: aValue size on: aWriteStream.
	aWriteStream nextPutAll: aValue asByteArray 
]

{ #category : #streaming }
AmqpMethodFrameTest >> nextShortPut: anObject on: aWriteStream [ 

	aWriteStream nextPutAll: (anObject asByteArrayOfSize: 2)
]

{ #category : #streaming }
AmqpMethodFrameTest >> nextShortstrPut: aString on: aWriteStream [

	aWriteStream
		nextPut: aString size;
		nextPutAll: aString asByteArray
]

{ #category : #streaming }
AmqpMethodFrameTest >> nextTablePut: aTable on: aWriteStream [

	| stream |

	stream := WriteStream on: ByteArray new.

	aTable
		keysAndValuesDo: [ :key :value | 
			self
				putFieldNamed: key on: stream;
				putFieldValue: value on: stream ].

	self nextLongstrPut: stream contents on: aWriteStream
]

{ #category : #mocking }
AmqpMethodFrameTest >> protocolClass [
	
	^ Amqp091
]

{ #category : #streaming }
AmqpMethodFrameTest >> putFieldNamed: aName on: aStream [

	self nextShortstrPut: aName on: aStream
]

{ #category : #streaming }
AmqpMethodFrameTest >> putFieldValue: aValue on: aWriteStream [ 

	( aValue isKindOf: String )
		ifTrue: [ 
				aWriteStream nextPut: $S asciiValue.
				self nextLongstrPut: aValue on: aWriteStream
			].
]

{ #category : #tests }
AmqpMethodFrameTest >> testReadConnectionStartOk [

	| method frame clientProperties |

	method := Amqp091ConnectionStartOk new.
	clientProperties :=  Dictionary new
						at: 'product' put: 'RabbitMQ Smalltalk';
						yourself.

	message := ByteArray
		streamContents: [ :stream | 
			self
				nextLongPut: method codecMethodId on: stream;
				nextTablePut: clientProperties on: stream;
				nextShortstrPut: 'PLAIN' on: stream;
				nextLongstrPut: ' guest guest' on: stream;
				nextShortstrPut: 'en_US' on: stream ].

	frame := AmqpMethodFrame new
		frameType: 1;
		channelNumber: 0;
		methodId: method codecMethodId.

	frame readFrom: self length: 62.

	self
		assert: frame method codecMethodId equals: method codecMethodId;
		assert: frame method mechanism equals: 'PLAIN';
		assert: frame method response equals: ('<1s>guest<1s>guest' expandMacrosWith: Character null asString);
		assert: frame method locale equals: 'en_US'
]

{ #category : #tests }
AmqpMethodFrameTest >> testReadConnectionTune [

	| method frame |

	method := Amqp091ConnectionTune new.

	message := ByteArray
		streamContents: [ :stream | 
			self
				nextLongPut: method codecMethodId on: stream;
				nextShortPut: 2047 on: stream;
				nextLongPut: 131072 on: stream;
				nextShortPut: 0 on: stream ].

	frame := AmqpMethodFrame new
		frameType: 1;
		channelNumber: 0;
		methodId: method codecMethodId.

	frame readFrom: self length: 12.

	self
		assert: frame method codecMethodId equals: method codecMethodId;
		assert: frame method channelMax equals: 2047;
		assert: frame method frameMax equals: 131072;
		assert: frame method heartbeat equals: 0
]

{ #category : #tests }
AmqpMethodFrameTest >> testReadConnectionTuneOk [

	| method frame |

	method := Amqp091ConnectionTuneOk new.

	message := ByteArray
		streamContents: [ :stream | 
			self
				nextLongPut: method codecMethodId on: stream;
				nextShortPut: 2047 on: stream;
				nextLongPut: 131072 on: stream;
				nextShortPut: 0 on: stream ].

	frame := AmqpMethodFrame new
		frameType: 1;
		channelNumber: 0;
		methodId: method codecMethodId.

	frame readFrom: self length: 12.

	self
		assert: frame method codecMethodId equals: method codecMethodId;
		assert: frame method channelMax equals: 2047;
		assert: frame method frameMax equals: 131072;
		assert: frame method heartbeat equals: 0
]
