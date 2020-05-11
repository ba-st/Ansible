Class {
	#name : #AmqpCodec,
	#superclass : #Object,
	#instVars : [
		'stream'
	],
	#category : #'Ansible-Protocol-Core'
}

{ #category : #streaming }
AmqpCodec >> flush [

	stream flush
]

{ #category : #streaming }
AmqpCodec >> nextBoolean [

	^ self nextOctet bitAnd: 1
]

{ #category : #streaming }
AmqpCodec >> nextLong [

	| v |

	v := stream next.
	v := ( v bitShift: 8 ) + stream next.
	v := ( v bitShift: 8 ) + stream next.
	v := ( v bitShift: 8 ) + stream next.
	^ v
]

{ #category : #streaming }
AmqpCodec >> nextLongPut: v [

	v ifNil: [ ^ self nextLongPut: 0 ].
	1 to: 4 do: [ :i | self nextOctetPut: ( v digitAt: 5 - i ) ].
	^ v
]

{ #category : #streaming }
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

{ #category : #streaming }
AmqpCodec >> nextLonglongPut: v [

	v ifNil: [ ^ self nextLonglongPut: 0 ].
	1 to: 8 do: [ :i | self nextOctetPut: ( v digitAt: 9 - i ) ].
	^ v
]

{ #category : #streaming }
AmqpCodec >> nextLongstr [

	^ self nextLongstrBytes asString
]

{ #category : #streaming }
AmqpCodec >> nextLongstrBytes [

	^ stream next: self nextLong
]

{ #category : #streaming }
AmqpCodec >> nextLongstrPut: v [

	v
		ifNil: [ self nextLongPut: 0.
			^ v
			].
	self nextLongPut: v size.
	stream nextPutAll: v asByteArray.
	^ v
]

{ #category : #streaming }
AmqpCodec >> nextOctet [

	^ stream next
]

{ #category : #streaming }
AmqpCodec >> nextOctetPut: v [

	v ifNil: [ ^ self nextOctetPut: 0 ].
	^ stream nextPut: v
]

{ #category : #streaming }
AmqpCodec >> nextShort [

	| v |

	v := stream next.
	v := ( v bitShift: 8 ) + stream next.
	^ v
]

{ #category : #streaming }
AmqpCodec >> nextShortPut: v [

	v ifNil: [ ^ self nextShortPut: 0 ].
	1 to: 2 do: [ :i | self nextOctetPut: ( v digitAt: 3 - i ) ].
	^ v
]

{ #category : #streaming }
AmqpCodec >> nextShortstr [

	^ ( stream next: self nextOctet ) asString
]

{ #category : #streaming }
AmqpCodec >> nextShortstrPut: v [

	v
		ifNil: [ self nextOctetPut: 0.
			^ v
			].
	self nextOctetPut: v size.
	stream nextPutAll: v asByteArray.
	^ v
]

{ #category : #streaming }
AmqpCodec >> nextTable [

	| buf d key type val |

	buf := self nextLongstrBytes.
	d := Dictionary new.
	self
		withStream: buf readStream
		during: [ [ stream peek notNil ]
				whileTrue: [ key := self nextShortstr.
					type := self nextOctet.
					val := self nextTableValue: type.
					d at: key put: val
					]
			].
	^ d
]

{ #category : #streaming }
AmqpCodec >> nextTablePut: d [

	| s |

	d
		ifNil: [ self nextLongPut: 0.
			^ d
			].
	s := WriteStream on: ByteArray new.
	self
		withStream: s
		during: [ d
				keysAndValuesDo: [ :key :val | 
					self nextShortstrPut: key.
					self nextTableValuePut: val
					]
			].
	self nextLongstrPut: s contents.
	^ d
]

{ #category : #streaming }
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

{ #category : #streaming }
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

{ #category : #streaming }
AmqpCodec >> nextTimestamp [

	^ ( DateAndTime year: 1970 day: 1 ) + self nextLonglong seconds
]

{ #category : #streaming }
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

{ #category : #accessing }
AmqpCodec >> stream: anObject [

	stream := anObject
]

{ #category : #streaming }
AmqpCodec >> withStream: aStream during: aBlock [

	| saved |

	saved := stream.
	stream := aStream.
	^ aBlock
		ensure: [ stream := saved ]
]
