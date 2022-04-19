Class {
	#name : #AmqpCodec,
	#superclass : #Object,
	#instVars : [
		'stream'
	],
	#category : #'Ansible-Protocol-Core'
}

{ #category : #'instance creation' }
AmqpCodec class >> on: aStream [

	^ self new initializeOn: aStream
]

{ #category : #streaming }
AmqpCodec >> flush [

	stream flush
]

{ #category : #initialization }
AmqpCodec >> initializeOn: aStream [

	stream := aStream
]

{ #category : #streaming }
AmqpCodec >> next: length [

	^ stream next: length
]

{ #category : #decoding }
AmqpCodec >> nextBoolean [

	^ self nextOctet bitAnd: 1
]

{ #category : #decoding }
AmqpCodec >> nextLong [

	| v |

	v := stream next.
	v := ( v bitShift: 8 ) + stream next.
	v := ( v bitShift: 8 ) + stream next.
	v := ( v bitShift: 8 ) + stream next.
	^ v
]

{ #category : #encoding }
AmqpCodec >> nextLongPut: v [

	v ifNil: [ ^ self nextLongPut: 0 ].
	1 to: 4 do: [ :i | self nextOctetPut: ( v byteAt: 5 - i ) ].
	^ v
]

{ #category : #decoding }
AmqpCodec >> nextLonglong [

	| v |

	v := stream next.
	v := ( v bitShift: 8 ) + stream next.
	v := ( v bitShift: 8 ) + stream next.
	v := ( v bitShift: 8 ) + stream next.
	v := ( v bitShift: 8 ) + stream next.
	v := ( v bitShift: 8 ) + stream next.
	v := ( v bitShift: 8 ) + stream next.
	v := ( v bitShift: 8 ) + stream next.
	^ v
]

{ #category : #encoding }
AmqpCodec >> nextLonglongPut: v [

	v ifNil: [ ^ self nextLonglongPut: 0 ].
	1 to: 8 do: [ :i | self nextOctetPut: ( v byteAt: 9 - i ) ].
	^ v
]

{ #category : #decoding }
AmqpCodec >> nextLongstr [

	^ self nextLongstrBytes asString
]

{ #category : #decoding }
AmqpCodec >> nextLongstrBytes [

	^ stream next: self nextLong
]

{ #category : #encoding }
AmqpCodec >> nextLongstrPut: v [

	v
		ifNil: [ self nextLongPut: 0.
			^ v
			].
	self nextLongPut: v size.
	stream nextPutAll: v asByteArray.
	^ v
]

{ #category : #decoding }
AmqpCodec >> nextOctet [

	^ stream next
]

{ #category : #encoding }
AmqpCodec >> nextOctetPut: v [

	v ifNil: [ ^ self nextOctetPut: 0 ].
	^ stream nextPut: v
]

{ #category : #streaming }
AmqpCodec >> nextPutAll: aCollection [

	stream nextPutAll: aCollection
]

{ #category : #decoding }
AmqpCodec >> nextShort [

	| v |

	v := stream next.
	v := ( v bitShift: 8 ) + stream next.
	^ v
]

{ #category : #encoding }
AmqpCodec >> nextShortPut: v [

	v ifNil: [ ^ self nextShortPut: 0 ].
	1 to: 2 do: [ :i | self nextOctetPut: ( v byteAt: 3 - i ) ].
	^ v
]

{ #category : #decoding }
AmqpCodec >> nextShortstr [

	^ ( stream next: self nextOctet ) asString
]

{ #category : #encoding }
AmqpCodec >> nextShortstrPut: v [

	v
		ifNil: [ self nextOctetPut: 0.
			^ v
			].
	self nextOctetPut: v size.
	stream nextPutAll: v asByteArray.
	^ v
]

{ #category : #decoding }
AmqpCodec >> nextTable [

	| buffer table key type value |

	buffer := self nextLongstrBytes.
	table := Dictionary new.
	self
		withStream: buffer readStream
		during: [ [ stream peek notNil ]
				whileTrue: [ key := self nextShortstr.
					type := self nextOctet.
					value := self nextTableValue: type.
					table at: key put: value
					]
			].
	^ table
]

{ #category : #encoding }
AmqpCodec >> nextTablePut: table [

	| buffer |

	table
		ifNil: [ self nextLongPut: 0.
			^ table
			].
	buffer := WriteStream on: ByteArray new.
	self
		withStream: buffer
		during: [ table
				keysAndValuesDo: [ :key :value | 
					self nextShortstrPut: key.
					self nextTableValuePut: value
					]
			].
	self nextLongstrPut: buffer contents.
	^ table
]

{ #category : #encoding }
AmqpCodec >> nextTableValue: type [

	type = $S asciiValue
		ifTrue: [ ^ self nextLongstr ].
	type = $I asciiValue
		ifTrue: [ ^ self nextLong ].
	type = $D asciiValue
		ifTrue: [ | decimals raw |

			decimals := self nextOctet.
			raw := self nextLong.
			^ raw / ( 10 raisedTo: decimals ) asScaledDecimal: decimals
			].
	type = $T asciiValue
		ifTrue: [ ^ self nextTimestamp ].
	type = $F asciiValue
		ifTrue: [ ^ self nextTable ].
	type = $t asciiValue
		ifTrue: [ ^ self nextBoolean ].
	AmqpProtocolSyntaxError signal: 'Unsupported AMQP table field type'
]

{ #category : #encoding }
AmqpCodec >> nextTableValuePut: val [

	( val isKindOf: ScaledDecimal )
		ifTrue: [ self nextOctetPut: $D asciiValue.
			self nextOctetPut: val scale.
			self nextLongPut: val asFraction * ( 10 raisedTo: val scale ).
			^ val
			].
	( val isKindOf: String )
		ifTrue: [ self nextOctetPut: $S asciiValue.
			self nextLongstrPut: val.
			^ val
			].
	( val isKindOf: Integer )
		ifTrue: [ self nextOctetPut: $I asciiValue.
			self nextLongPut: val.
			^ val
			].
	( val isKindOf: DateAndTime )
		ifTrue: [ self nextOctetPut: $T asciiValue.
			self nextTimestampPut: val.
			^ val
			].
	( val isKindOf: Dictionary )
		ifTrue: [ self nextOctetPut: $F asciiValue.
			self nextTablePut: val.
			^ val
			].
	AmqpProtocolSyntaxError signal: 'Unsupported AMQP table field value'
]

{ #category : #decoding }
AmqpCodec >> nextTimestamp [

	^ ( DateAndTime year: 1970 day: 1 ) + self nextLonglong seconds
]

{ #category : #encoding }
AmqpCodec >> nextTimestampPut: v [

	v
		ifNil: [ self nextLonglongPut: 0.
			^ v
			].
	self nextLonglongPut: ( v - ( DateAndTime year: 1970 day: 1 ) ) asSeconds.
	^ v
]

{ #category : #accessing }
AmqpCodec >> stream [

	^ stream
]

{ #category : #streaming }
AmqpCodec >> withStream: aStream during: aBlock [

	| saved |

	saved := stream.
	stream := aStream.
	^ aBlock
		ensure: [ stream := saved ]
]
