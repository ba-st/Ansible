Class {
	#name : #AmqpProtocolHeaderFrame,
	#superclass : #AmqpFrame,
	#instVars : [
		'majorVersion',
		'minorVersion',
		'revision',
		'transportVersion',
		'isObsoleteProtocolVariant'
	],
	#category : #'Amqp-Protocol-Core-Amqp-Protocol-Core'
}

{ #category : #accessing }
AmqpProtocolHeaderFrame >> encodeBodyOn: codec [

	"do nothing."

	
]

{ #category : #accessing }
AmqpProtocolHeaderFrame >> readFrom: conn length: length [

	| codec |

	"length is four bytes big-endian: $P followed by the first three bytes of the version spec."
	codec := conn codec.
	( length digitAt: 4 ) = $P asciiValue
		ifFalse: [ AmqpProtocolSyntaxError signal: 'Invalid AMQP protocol version header' ].
	transportVersion := length digitAt: 3.
	transportVersion = 1
		ifTrue: [ isObsoleteProtocolVariant := true.
			( length digitAt: 2 ) = 1
				ifFalse: [ AmqpProtocolSyntaxError signal: 'Unexpected transport version low byte' ].
			majorVersion := length digitAt: 1.
			minorVersion := codec nextOctet.
			revision := nil
			]
		ifFalse: [ isObsoleteProtocolVariant := false.
			majorVersion := length digitAt: 2.
			minorVersion := length digitAt: 1.
			revision := codec nextOctet
			].
	AmqpProtocolMismatchError new
		serverProtocolHeader: self;
		signal: 'Incompatible server AMQP protocol version'
]
