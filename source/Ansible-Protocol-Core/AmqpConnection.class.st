Class {
	#name : 'AmqpConnection',
	#superclass : 'Object',
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
		'protocolClass',
		'heartbeatSender',
		'hostname',
		'socketConnectionStatus',
		'portNumber'
	],
	#category : 'Ansible-Protocol-Core',
	#package : 'Ansible-Protocol-Core'
}

{ #category : 'instance creation' }
AmqpConnection class >> to: aHostname over: aPort using: aProtocolVersion with: connectionCredentials parameterizedBy: connectionParameters [

	^ self new
		  initializeTo: aHostname
		  over: aPort
		  using: aProtocolVersion
		  with: connectionCredentials
		  parameterizedBy: connectionParameters
]

{ #category : 'connection-handling' }
AmqpConnection >> close [

	| connectionClose |

	heartbeatSender stop.
	isOpen ifTrue: [ 
		isOpen := false.
		connectionClose := self protocolClass connectionCloseMethod new
			                   replyCode: self protocolClass replySuccess;
			                   replyText: 'Normal shutdown';
			                   classId: 0;
			                   methodId: 0.
		self rpc: connectionClose onChannel: 0.
		self internalClose: connectionClose
		].

	socket close
]

{ #category : 'connection-handling' }
AmqpConnection >> closeReason [

	^ closeReason
]

{ #category : 'accessing' }
AmqpConnection >> codec [

	^ codec
]

{ #category : 'connection-handling' }
AmqpConnection >> createChannel [

	| handler |

	self ensureOpen.
	handler := AmqpChannelHandler new connection: self.
	^ AmqpChannel using: handler
]

{ #category : 'accessing' }
AmqpConnection >> credentials [

	^ credentials
]

{ #category : 'connection-handling' }
AmqpConnection >> ensureChannel: channelNumber [

	self ensureOpen.
	^ ( channels at: channelNumber ) ensureOpen
]

{ #category : 'connection-handling' }
AmqpConnection >> ensureOpen [

	closeReason notNil
		ifTrue: [ AmqpDisconnectedError signal: 'Connection closed' ]
]

{ #category : 'connection-handling' }
AmqpConnection >> handleConnectionClose: cmd [

	self internalClose: cmd method.
	isOpen := false.
	self sendMethod: self protocolClass connectionCloseOkMethod new onChannel: 0.
	socket close
]

{ #category : 'connection-handling' }
AmqpConnection >> hardClose [

	| connectionClose |

	isOpen
		ifTrue: [ isOpen := false.
			connectionClose := self protocolClass connectionCloseMethod new
				replyCode: self protocolClass internalError;
				replyText: 'Abnormal disconnection'.
			self internalClose: connectionClose
			].
	heartbeatSender stop.		
	socket close
]

{ #category : 'initialization' }
AmqpConnection >> initialize [

	super initialize.
	virtualHost := '/'.
	isOpen := false.
	closeReason := nil.
	channels := Dictionary new.
	nextChannel := 0
]

{ #category : 'initialization' }
AmqpConnection >> initializeHeartbeatSender [

	heartbeatSender := AmqpHeartbeatSender keepingOpen: self
]

{ #category : 'initialization' }
AmqpConnection >> initializeSocketConnection [

	socket := Socket newTCP.
	[ 
	socket connectToHostNamed: hostname port: portNumber.
	socketConnectionStatus := SuccesfulSocketConnection new
	]
		on: NetworkError
		do: [ :error | 
			socketConnectionStatus := FailedSocketConnection dueTo: error.
			error return
			]
]

{ #category : 'initialization' }
AmqpConnection >> initializeTo: aHostname over: aPort using: aProtocolVersion with: connectionCredentials parameterizedBy: connectionParameters [

	protocolClass := aProtocolVersion.
	hostname := aHostname.
	portNumber := aPort.
	credentials := connectionCredentials.
	parameters := connectionParameters.
	self initializeSocketConnection.
	self initializeHeartbeatSender
]

{ #category : 'private-opening' }
AmqpConnection >> installChannel0 [

	| channel |

	channel := AmqpChannelHandler new connection: self.
	channel mapEvent: self protocolClass connectionCloseMethod to: self selector: #handleConnectionClose:
]

{ #category : 'connection-handling' }
AmqpConnection >> internalClose: method [

	closeReason
		ifNil: [ closeReason := method.
			channels values copy do: [ :ch | ch internalClose: method ].
			self changed: #connectionClosed
			]
]

{ #category : 'connection-handling' }
AmqpConnection >> mainLoopCycle [

	| frame |

	frame := self nextFrame.
	frame
		ifNil: [ self hardClose.
			^ self ].
	(frame isKindOf: AmqpHeartbeatFrame)
		ifFalse: [ (channels at: frame channelNumber) handleFrame: frame ]
]

{ #category : 'connection-handling' }
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

{ #category : 'connection-handling' }
AmqpConnection >> nextFrame [

	| typeCode channel length frameType frame |

	[ 
	typeCode := codec nextOctet.
	typeCode ifNil: [ ^ nil ].
	channel := codec nextShort.
	length := codec nextLong.
	frameType := self protocolClass frameClassFor: typeCode.
	frameType notNil
		ifTrue: [ frame := frameType new.
			frame frameType: typeCode.
			frame channelNumber: channel.
			frame readFrom: self length: length.
			codec nextOctet = self protocolClass frameEnd
				ifFalse: [ AmqpProtocolSyntaxError signal: 'Missing frame end marker' ].
			^ frame
			]
	] repeat
]

{ #category : 'opening' }
AmqpConnection >> open [

	codec := AmqpCodec
		on:
			((SocketStream on: socket)
				noTimeout;
				binary;
				yourself).

	self
		sendProtocolHeader;
		startConnection;
		tuneConnection;
		openConnection.

	heartbeatSender startBeatingEvery: parameters heartbeat
]

{ #category : 'private-opening' }
AmqpConnection >> openConnection [


	self installChannel0.

	self
		rpc: (self protocolClass connectionOpenMethod new virtualHost: virtualHost)
		onChannel: 0.
		
	isOpen := true.
]

{ #category : 'connection-handling' }
AmqpConnection >> processAsyncEvents [

	[ self ensureOpen.
	codec stream isDataAvailable or: [ socket isConnected not ]
	] whileTrue: [ self mainLoopCycle ]
]

{ #category : 'connection-handling' }
AmqpConnection >> protocolClass [

	^ protocolClass
]

{ #category : 'connection-handling' }
AmqpConnection >> resetChannel: channelNumber [

	channels removeKey: channelNumber ifAbsent: [  ]
]

{ #category : 'connection-handling' }
AmqpConnection >> rpc: requestMethod onChannel: channelNumber [

	| ch |

	ch := self ensureChannel: channelNumber.
	self sendMethod: requestMethod onChannel: channelNumber.
	^ ch waitForReply: requestMethod acceptableResponseClasses
]

{ #category : 'connection-handling' }
AmqpConnection >> sendBodyFrameContaining: aByteArray startingAt: aStartingPosition onChannel: aChannelNumber [

	| length |

	length := aByteArray size min: parameters frameMax - 8.	"Seven bytes of header, plus one byte of footer."
	self
		sendFrame:
			( AmqpContentBodyFrame new
				frameType: protocolClass frameBody;
				channelNumber: aChannelNumber;
				fragment: ( aByteArray copyFrom: aStartingPosition to: aStartingPosition + length - 1 ) ).
	^ aStartingPosition + length
]

{ #category : 'connection-handling' }
AmqpConnection >> sendFrame: aFrame [

	aFrame encodeOn: codec.
	codec nextOctetPut: self protocolClass frameEnd
]

{ #category : 'connection-handling' }
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

{ #category : 'connection-handling' }
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

{ #category : 'private-opening' }
AmqpConnection >> sendProtocolHeader [

	codec nextPutAll: self protocolClass protocolHeader.
	codec flush
]

{ #category : 'accessing' }
AmqpConnection >> setChannel: aChannelNumber to: aChannelHandler [

	channels at: aChannelNumber put: aChannelHandler
]

{ #category : 'private-opening' }
AmqpConnection >> startConnection [

	| response |

	response := credentials responseFor: self nextFrame method.
	response
		ifNil: [ AmqpDisconnectedError
				signal: 'No acceptable SASL mechanism for the given credentials' ].
	self
		sendMethod:
			(self protocolClass connectionStartOkMethod new
				clientProperties:
					(Dictionary new
						at: 'product' put: 'RabbitMQ Smalltalk';
						yourself);
				mechanism: response key;
				response: response value)
		onChannel: 0.
	credentials := nil
]

{ #category : 'private-opening' }
AmqpConnection >> tuneConnection [

	parameters applyServerSettings: self nextFrame method.
	self
		sendMethod:
			(self protocolClass connectionTuneOkMethod new
				channelMax: parameters channelMax;
				frameMax: parameters frameMax;
				heartbeat: parameters heartbeat)
		onChannel: 0
]

{ #category : 'accessing' }
AmqpConnection >> virtualHost [

	^ virtualHost
]

{ #category : 'connection-handling' }
AmqpConnection >> waitForEvent [

	self ensureOpen.
	[ codec stream peek ]
		on: ConnectionTimedOut
		do: [  ].
	^ self processAsyncEvents
]

{ #category : 'connection-handling' }
AmqpConnection >> whenConnected: aBlock whenNot: anotherBlock [

	^socketConnectionStatus whenConnected: aBlock whenNot: anotherBlock
]
