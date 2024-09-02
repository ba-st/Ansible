Class {
	#name : 'AmqpFrame',
	#superclass : 'Object',
	#instVars : [
		'frameType',
		'channelNumber'
	],
	#category : 'Ansible-Protocol-Core',
	#package : 'Ansible-Protocol-Core'
}

{ #category : 'accessing' }
AmqpFrame >> channelNumber [

	^ channelNumber
]

{ #category : 'accessing' }
AmqpFrame >> channelNumber: anObject [

	channelNumber := anObject
]

{ #category : 'accessing' }
AmqpFrame >> encodeBodyOn: codec [

	self subclassResponsibility
]

{ #category : 'accessing' }
AmqpFrame >> encodeOn: codec [

	codec
		nextOctetPut: frameType;
		nextShortPut: channelNumber;
		nextLongstrPut: self encodedBody
]

{ #category : 'accessing' }
AmqpFrame >> encodedBody [

	| stream codec |

	stream := WriteStream with: ByteArray new.
	codec := AmqpCodec on: stream.
	self encodeBodyOn: codec.
	codec flush.
	^ stream contents
]

{ #category : 'accessing' }
AmqpFrame >> frameType [

	^ frameType
]

{ #category : 'accessing' }
AmqpFrame >> frameType: anObject [

	frameType := anObject
]

{ #category : 'accessing' }
AmqpFrame >> readFrom: connection length: length [

	self subclassResponsibility
]
