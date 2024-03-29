Class {
	#name : #AmqpProtocol,
	#superclass : #Object,
	#classInstVars : [
		'classIds',
		'methodIds'
	],
	#category : #'Ansible-Protocol-Common'
}

{ #category : #accessing }
AmqpProtocol class >> classForId: classId [

	^ classIds at: classId ifAbsent: [ AmqpProtocolSyntaxError signal: 'Unsupported AMQP class' ]
]

{ #category : #accessing }
AmqpProtocol class >> frameClassFor: typeCode [

	typeCode = self frameMethod
		ifTrue: [ ^ AmqpMethodFrame ].
	typeCode = self frameHeader
		ifTrue: [ ^ AmqpContentHeaderFrame ].
	typeCode = self frameBody
		ifTrue: [ ^ AmqpContentBodyFrame ].
	typeCode = self frameHeartbeat
		ifTrue: [ ^ AmqpHeartbeatFrame ].
	typeCode = $A asciiValue
		ifTrue: [ ^ AmqpProtocolHeaderFrame ].
	^ nil	"ignored frame kind"
]

{ #category : #'class initialization' }
AmqpProtocol class >> initialize [

	classIds := Dictionary new.
	methodIds := Dictionary new
]

{ #category : #accessing }
AmqpProtocol class >> isObsoleteProtocolVariant [

	self subclassResponsibility
]

{ #category : #accessing }
AmqpProtocol class >> majorVersion [

	self subclassResponsibility
]

{ #category : #accessing }
AmqpProtocol class >> methodForId: methodId [

	^ methodIds at: methodId ifAbsent: [ AmqpProtocolSyntaxError signal: 'Unsupported AMQP method' ]
]

{ #category : #accessing }
AmqpProtocol class >> minorVersion [

	self subclassResponsibility
]

{ #category : #accessing }
AmqpProtocol class >> portNumber [

	self subclassResponsibility
]

{ #category : #accessing }
AmqpProtocol class >> protocolHeader [

	| stream |

	stream := WriteStream on: ( ByteArray new: 8 ).
	stream nextPutAll: 'AMQP' asByteArray.
	self isObsoleteProtocolVariant
		ifTrue: [ stream
				nextPut: 1;
				nextPut: 1;
				nextPut: self majorVersion;
				nextPut: self minorVersion
			]
		ifFalse: [ stream
				nextPut: 0;
				nextPut: self majorVersion;
				nextPut: self minorVersion;
				nextPut: self revision
			].
	^ stream contents
]

{ #category : #accessing }
AmqpProtocol class >> revision [

	self subclassResponsibility
]

{ #category : #accessing }
AmqpProtocol class >> versionString [

	^ self majorVersion asString , '-' , self minorVersion asString
		,
			( self revision > 0
				ifTrue: [ '-' , self revision asString ]
				ifFalse: [ '' ] )
]
