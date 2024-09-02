Class {
	#name : 'AmqpProtocolHeaderFrame',
	#superclass : 'AmqpFrame',
	#instVars : [
		'majorVersion',
		'minorVersion',
		'revision',
		'transportVersion',
		'isObsoleteProtocolVariant'
	],
	#category : 'Ansible-Protocol-Core',
	#package : 'Ansible-Protocol-Core'
}

{ #category : 'accessing' }
AmqpProtocolHeaderFrame >> encodeBodyOn: codec [

	"do nothing."

	
]

{ #category : 'accessing' }
AmqpProtocolHeaderFrame >> readFrom: connection length: length [

	| codec |
	
	"length is four bytes big-endian: $P followed by the first three bytes of the version spec."
	codec := connection codec.
	( length byteAt: 4 ) = $P asciiValue
		ifFalse: [ AmqpProtocolSyntaxError signal: 'Invalid AMQP protocol version header' ].
	transportVersion := length byteAt: 3.
	transportVersion = 1
		ifTrue: [ isObsoleteProtocolVariant := true.
			( length byteAt: 2 ) = 1
				ifFalse: [ AmqpProtocolSyntaxError signal: 'Unexpected transport version low byte' ].
			majorVersion := length byteAt: 1.
			minorVersion := codec nextOctet.
			revision := nil
			]
		ifFalse: [ isObsoleteProtocolVariant := false.
			majorVersion := length byteAt: 2.
			minorVersion := length byteAt: 1.
			revision := codec nextOctet
			].
	AmqpProtocolMismatchError new
		serverProtocolHeader: self;
		signal: 'Incompatible server AMQP protocol version'
]
