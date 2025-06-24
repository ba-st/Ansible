Class {
	#name : 'AmqpChannelHandler',
	#superclass : 'Object',
	#instVars : [
		'connection',
		'channelNumber',
		'inbound',
		'closeReason',
		'asyncMap',
		'nextFrameHandler',
		'commandBuilder'
	],
	#category : 'Ansible-Protocol-Core',
	#package : 'Ansible-Protocol-Core'
}

{ #category : 'instance creation' }
AmqpChannelHandler class >> on: aConnection [

  ^ self new initializeOn: aConnection
]

{ #category : 'handling' }
AmqpChannelHandler >> assertChannelOpen [

	closeReason notNil
		ifTrue: [ AmqpDisconnectedError signal: 'Channel closed' ]
]

{ #category : 'accessing' }
AmqpChannelHandler >> channelNumber [

	^ channelNumber
]

{ #category : 'accessing' }
AmqpChannelHandler >> checkBodyCompletion [

  commandBuilder
    withCommandDo: [ :command | self dispatchCommand: command ]
    ifUncompletedDo: [ nextFrameHandler := #handleBodyFrame: ]
]

{ #category : 'accessing' }
AmqpChannelHandler >> closeReason [

	^ closeReason
]

{ #category : 'accessing' }
AmqpChannelHandler >> connection [

	^ connection
]

{ #category : 'handling' }
AmqpChannelHandler >> dispatchCommand: aCommand [

  asyncMap
    at: aCommand method class
    ifPresent: [ :messageSend | messageSend value: aCommand ]
    ifAbsent: [ inbound add: aCommand ].

  self resetState
]

{ #category : 'handling - frames' }
AmqpChannelHandler >> handleBodyFrame: frame [

  commandBuilder appendBodyFrame: frame.

  self checkBodyCompletion
]

{ #category : 'handling - frames' }
AmqpChannelHandler >> handleFrame: frame [

  frame beHandledBy: self
]

{ #category : 'handling - frames' }
AmqpChannelHandler >> handleMethodFrame: frame [

  commandBuilder := AmqpCommandBuilder new.
  commandBuilder setMethodFrame: frame.

  commandBuilder
    withCommandDo: [ :command | self dispatchCommand: command ]
    ifUncompletedDo: [ nextFrameHandler := #handlePropertiesFrame: ]
]

{ #category : 'handling - frames' }
AmqpChannelHandler >> handlePropertiesFrame: frame [

  commandBuilder setHeaderFrame: frame.

  self checkBodyCompletion
]

{ #category : 'accessing' }
AmqpChannelHandler >> initializeOn: aConnection [

  super initialize.
  connection := aConnection.
  channelNumber := connection nextChannel.
  connection setChannel: channelNumber to: self.
  asyncMap := Dictionary new.
  closeReason := nil.
  inbound := OrderedCollection new.
  self resetState
]

{ #category : 'handling' }
AmqpChannelHandler >> internalClose: method [

	closeReason
		ifNil: [ closeReason := method.
			connection resetChannel: channelNumber.
			self changed: #channelHandlerClosed
			]
]

{ #category : 'handling' }
AmqpChannelHandler >> mapEvent: evtClass to: receiver selector: aSymbol [

  asyncMap at: evtClass put: ( MessageSend receiver: receiver selector: aSymbol )
]

{ #category : 'handling' }
AmqpChannelHandler >> resetState [

  nextFrameHandler := #handleMethodFrame:.
  commandBuilder := AmqpCommandBuilder new
]

{ #category : 'handling' }
AmqpChannelHandler >> rpc: requestMethod [

	^ connection rpc: requestMethod onChannel: channelNumber
]

{ #category : 'handling' }
AmqpChannelHandler >> waitForReply: acceptableReplies [

	| i |

	acceptableReplies ifNil: [ ^ nil ].
	acceptableReplies ifEmpty: [ ^ nil ].

	i := 1.
	[
	[ i > inbound size ] whileTrue: [
		| currentConnection |

		self assertChannelOpen.
		currentConnection := connection mainLoopCycle.
		currentConnection
			whenConnected: [  ]
			whenNot: [ :error | AmqpDisconnectedError signal: error ]
		].
	[ i <= inbound size ] whileTrue: [
		| cmd |

		cmd := inbound at: i.
		( acceptableReplies includes: cmd method class ) ifTrue: [
			inbound removeAt: i.
			^ cmd
			].
		i := i + 1
		]
	] repeat
]

{ #category : 'accessing' }
AmqpChannelHandler >> whenOpenDo: aBlock whenClosedDo: aClosedHandler [

	^ closeReason
		  ifNil: [ connection whenConnected: aBlock whenNot: aClosedHandler ]
		  ifNotNil: aClosedHandler
]
