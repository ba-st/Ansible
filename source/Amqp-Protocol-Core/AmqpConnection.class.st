Class {
	#name : #AmqpConnection,
	#superclass : #Object,
	#instVars : [
		'socket',
		'codec',
		'credentials',
		'parameters',
		'virtualHost',
		'isOpen',
		'closeReason',
		'channels',
		'nextChannel',
		'protocolClass'
	],
	#category : #'Amqp-Protocol-Core-Amqp-Protocol-Core'
}

{ #category : #accessing }
AmqpConnection class >> protocolClass [

	^ Amqp091
]

{ #category : #'instance creation' }
AmqpConnection class >> to: aHostname using: aProtocolVersion with: connectionCredentials parameterizedBy: connectionParameters [

	^ self basicNew
		initializeTo: aHostname
		using: aProtocolVersion
		with: connectionCredentials
		parameterizedBy: connectionParameters
]

{ #category : #'connection-handling' }
AmqpConnection >> close [

	| c |

	isOpen
		ifTrue: [ isOpen := false.
			c := self protocolClass connectionCloseMethod new
				replyCode: self protocolClass replySuccess;
				replyText: 'Normal shutdown';
				classId: 0;
				methodId: 0.
			self rpc: c onChannel: 0.
			self internalClose: c
			].
	socket close
]

{ #category : #'connection-handling' }
AmqpConnection >> closeReason [

	^ closeReason
]

{ #category : #accessing }
AmqpConnection >> codec [

	^ codec
]

{ #category : #accessing }
AmqpConnection >> codec: anObject [

	codec := anObject
]

{ #category : #'connection-handling' }
AmqpConnection >> createChannel [

	| handler |

	self ensureOpen.
	handler := AmqpChannelHandler new connection: self.
	^ AmqpChannel using: handler
]

{ #category : #accessing }
AmqpConnection >> credentials [

	^ credentials
]

{ #category : #accessing }
AmqpConnection >> credentials: anObject [

	credentials := anObject
]

{ #category : #'connection-handling' }
AmqpConnection >> ensureChannel: channelNumber [

	self ensureOpen.
	^ ( channels at: channelNumber ) ensureOpen
]

{ #category : #'connection-handling' }
AmqpConnection >> ensureOpen [

	closeReason notNil
		ifTrue: [ AmqpDisconnectedError signal: 'Connection closed' ]
]

{ #category : #'connection-handling' }
AmqpConnection >> handleConnectionClose: cmd [

	self internalClose: cmd method.
	isOpen := false.
	self sendMethod: self protocolClass connectionCloseOkMethod new onChannel: 0.
	socket close
]

{ #category : #'connection-handling' }
AmqpConnection >> hardClose [

	| c |

	isOpen
		ifTrue: [ isOpen := false.
			c := self protocolClass connectionCloseMethod new
				replyCode: self protocolClass internalError;
				replyText: 'Abnormal disconnection'.
			self internalClose: c
			].
	socket close
]

{ #category : #'connection-handling' }
AmqpConnection >> host: hostName [

	^ self host: hostName port: self protocolClass portNumber
]

{ #category : #'connection-handling' }
AmqpConnection >> host: hostName port: portNumber [

	socket connectToHostNamed: hostName port: portNumber
]

{ #category : #initialization }
AmqpConnection >> initialize [

	super initialize.
	virtualHost := '/'.
	isOpen := false.
	closeReason := nil.
	channels := Dictionary new.
	nextChannel := 0
]

{ #category : #initialization }
AmqpConnection >> initializeTo: aHostname using: aProtocolVersion with: connectionCredentials parameterizedBy: connectionParameters [

	protocolClass := aProtocolVersion.

	socket := Socket newTCP.
	socket connectToHostNamed: aHostname port: aProtocolVersion portNumber.

	credentials := connectionCredentials.
	parameters := connectionParameters.

	self initialize
]

{ #category : #'connection-handling' }
AmqpConnection >> installChannel0 [

	| channel |

	channel := AmqpChannelHandler new connection: self.
	channel mapEvent: self protocolClass connectionCloseMethod to: self selector: #handleConnectionClose:
]

{ #category : #'connection-handling' }
AmqpConnection >> internalClose: method [

	closeReason
		ifNil: [ closeReason := method.
			channels values copy do: [ :ch | ch internalClose: method ].
			self changed: #connectionClosed
			]
]

{ #category : #'connection-handling' }
AmqpConnection >> mainLoopCycle [

	| frame |

	frame := self nextFrame.
	frame
		ifNil: [ self hardClose.
			^ self
			].
	( frame isKindOf: AmqpHeartbeatFrame )
		ifTrue: [ self sendFrame: frame ]
		ifFalse: [ ( channels at: frame channelNumber ) handleFrame: frame ]
]

{ #category : #'connection-handling' }
AmqpConnection >> nextChannel [

	| tries limit |

	tries := 0.
	limit := parameters channelMax.
	( limit isNil or: [ limit = 0 ] )
		ifTrue: [ limit := 32767 ].
	[ channels includesKey: nextChannel ]
		whileTrue: [ nextChannel := nextChannel + 1 rem: limit.
			tries := tries + 1.
			nextChannel = 0
				ifTrue: [ nextChannel := 1 ].
			tries > limit
				ifTrue: [ AmqpResourceError signal: 'No free channels' ]
			].
	^ nextChannel
]

{ #category : #'connection-handling' }
AmqpConnection >> nextFrame [

	| type channel length fc f |

	[ type := codec nextOctet.
	type ifNil: [ ^ nil ].
	channel := codec nextShort.
	length := codec nextLong.
	fc := self protocolClass frameClassFor: type.
	fc notNil
		ifTrue: [ f := fc new.
			f frameType: type.
			f channelNumber: channel.
			f readFrom: self length: length.
			codec nextOctet = self protocolClass frameEnd
				ifFalse: [ AmqpProtocolSyntaxError signal: 'Missing frame end marker' ].
			^ f
			]
	] repeat
]

{ #category : #opening }
AmqpConnection >> open [

	| protocol response |

	codec := AmqpCodec new.
	codec stream: ( SocketStream on: socket ) noTimeout.
	codec stream binary.
	protocol := self protocolClass.
	codec stream nextPutAll: protocol protocolHeader.
	codec flush.
	response := credentials responseFor: self nextFrame method.
	response
		ifNil: [ AmqpDisconnectedError signal: 'No acceptable SASL mechanism for the given credentials' ].
	self
		sendMethod:
			( protocol connectionStartOkMethod new
				clientProperties:
					( Dictionary new
						at: 'product' put: 'RabbitMQ Smalltalk';
						yourself );
				mechanism: response key;
				response: response value )
		onChannel: 0.
	credentials := nil.
	parameters applyServerSettings: self nextFrame method.
	self
		sendMethod:
			( protocol connectionTuneOkMethod new
				channelMax: parameters channelMax;
				frameMax: parameters frameMax;
				heartbeat: parameters heartbeat )
		onChannel: 0.
	self installChannel0.
	self rpc: ( protocol connectionOpenMethod new virtualHost: virtualHost ) onChannel: 0.
	isOpen := true
]

{ #category : #accessing }
AmqpConnection >> parameters [

	^ parameters
]

{ #category : #accessing }
AmqpConnection >> parameters: anObject [

	parameters := anObject
]

{ #category : #'connection-handling' }
AmqpConnection >> processAsyncEvents [

	[ self ensureOpen.
	codec stream isDataAvailable or: [ socket isConnected not ]
	] whileTrue: [ self mainLoopCycle ]
]

{ #category : #'connection-handling' }
AmqpConnection >> protocolClass [

	^ protocolClass
]

{ #category : #'connection-handling' }
AmqpConnection >> protocolClass: aProtocolVersion [

	protocolClass := aProtocolVersion
]

{ #category : #'connection-handling' }
AmqpConnection >> resetChannel: channelNumber [

	channels removeKey: channelNumber ifAbsent: [  ]
]

{ #category : #'connection-handling' }
AmqpConnection >> rpc: requestMethod onChannel: channelNumber [

	| ch |

	ch := self ensureChannel: channelNumber.
	self sendMethod: requestMethod onChannel: channelNumber.
	^ ch waitForReply: requestMethod acceptableResponseClasses
]

{ #category : #'connection-handling' }
AmqpConnection >> sendBodyFrameContaining: aByteArray startingAt: pos onChannel: channelNumber [

	| pieceLen |

	pieceLen := aByteArray size min: parameters frameMax - 8.	"Seven bytes of header, plus one byte of footer."
	self
		sendFrame:
			( AmqpContentBodyFrame new
				frameType: protocolClass frameBody;
				channelNumber: channelNumber;
				fragment: ( aByteArray copyFrom: pos to: pos + pieceLen - 1 ) ).
	^ pos + pieceLen
]

{ #category : #'connection-handling' }
AmqpConnection >> sendFrame: aFrame [

	aFrame encodeOn: codec.
	codec nextOctetPut: self protocolClass frameEnd
]

{ #category : #'connection-handling' }
AmqpConnection >> sendMethod: aMethod onChannel: aChannelNumber [

	self
		sendFrame:
			( AmqpMethodFrame new
				frameType: self protocolClass frameMethod;
				channelNumber: aChannelNumber;
				methodId: aMethod codecMethodId;
				method: aMethod ).
	codec flush
]

{ #category : #'connection-handling' }
AmqpConnection >> sendMethod: aMethod properties: aProperties body: aByteArray onChannel: channelNumber [

	| pos |

	self ensureChannel: channelNumber.
	self
		sendFrame:
			( AmqpMethodFrame new
				frameType: protocolClass frameMethod;
				channelNumber: channelNumber;
				methodId: aMethod codecMethodId;
				method: aMethod ).
	self
		sendFrame:
			( AmqpContentHeaderFrame new
				frameType: protocolClass frameHeader;
				channelNumber: channelNumber;
				classId: aProperties codecClassId;
				bodySize: aByteArray size;
				properties: aProperties ).
	pos := 1.
	[ pos <= aByteArray size ]
		whileTrue: [ pos := self sendBodyFrameContaining: aByteArray startingAt: pos onChannel: channelNumber ].
	codec flush
]

{ #category : #accessing }
AmqpConnection >> setChannel: n to: aChannelHandler [

	channels at: n put: aChannelHandler
]

{ #category : #accessing }
AmqpConnection >> virtualHost [

	^ virtualHost
]

{ #category : #accessing }
AmqpConnection >> virtualHost: anObject [

	virtualHost := anObject
]

{ #category : #'connection-handling' }
AmqpConnection >> waitForEvent [

	self ensureOpen.
	[ codec stream peek ]
		on: ConnectionTimedOut
		do: [  ].
	^ self processAsyncEvents
]
