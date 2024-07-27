Class {
	#name : 'AmqpContentHeaderFrame',
	#superclass : 'AmqpFrame',
	#instVars : [
		'classId',
		'bodySize',
		'properties'
	],
	#category : 'Ansible-Protocol-Core',
	#package : 'Ansible-Protocol-Core'
}

{ #category : 'accessing' }
AmqpContentHeaderFrame >> bodySize [

	^ bodySize
]

{ #category : 'accessing' }
AmqpContentHeaderFrame >> bodySize: anObject [

	bodySize := anObject
]

{ #category : 'accessing' }
AmqpContentHeaderFrame >> classId [

	^ classId
]

{ #category : 'accessing' }
AmqpContentHeaderFrame >> classId: anObject [

	classId := anObject
]

{ #category : 'accessing' }
AmqpContentHeaderFrame >> encodeBodyOn: codec [

	codec nextShortPut: classId.
	codec nextShortPut: 0.
	codec nextLonglongPut: bodySize.
	properties encodeOn: codec
]

{ #category : 'accessing' }
AmqpContentHeaderFrame >> properties [

	^ properties
]

{ #category : 'accessing' }
AmqpContentHeaderFrame >> properties: anObject [

	properties := anObject
]

{ #category : 'accessing' }
AmqpContentHeaderFrame >> readFrom: connection length: length [

	| codec |

	codec := connection codec.
	classId := codec nextShort.
	codec nextShort.	"skip unused weight field."
	bodySize := codec nextLonglong.
	properties := ( connection protocolClass classForId: classId ) new.
	properties decodeFrom: codec
]
