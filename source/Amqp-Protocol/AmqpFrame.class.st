Class {
	#name : #AmqpFrame,
	#superclass : #Object,
	#instVars : [
		'frameType',
		'channelNumber'
	],
	#category : #'Amqp-Protocol'
}

{ #category : #accessing }
AmqpFrame >> channelNumber [

	^ channelNumber
]

{ #category : #accessing }
AmqpFrame >> channelNumber: anObject [

	channelNumber := anObject
]

{ #category : #accessing }
AmqpFrame >> encodeBodyOn: codec [

	self subclassResponsibility
]

{ #category : #accessing }
AmqpFrame >> encodeOn: codec [

	codec
		nextOctetPut: frameType;
		nextShortPut: channelNumber;
		nextLongstrPut: self encodedBody
]

{ #category : #accessing }
AmqpFrame >> encodedBody [

	| s c |

	s := WriteStream with: ByteArray new.
	c := AmqpCodec new stream: s.
	self encodeBodyOn: c.
	c flush.
	^ s contents
]

{ #category : #accessing }
AmqpFrame >> frameType [

	^ frameType
]

{ #category : #accessing }
AmqpFrame >> frameType: anObject [

	frameType := anObject
]

{ #category : #accessing }
AmqpFrame >> readFrom: conn length: length [

	self subclassResponsibility
]
