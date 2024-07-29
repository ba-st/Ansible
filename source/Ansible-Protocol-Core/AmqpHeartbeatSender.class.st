Class {
	#name : 'AmqpHeartbeatSender',
	#superclass : 'Object',
	#instVars : [
		'connection',
		'process',
		'isStarted'
	],
	#category : 'Ansible-Protocol-Core',
	#package : 'Ansible-Protocol-Core'
}

{ #category : 'instance creation' }
AmqpHeartbeatSender class >> keepingOpen: anAmqpConnection [

	^ self new initializeKeepingOpen: anAmqpConnection
]

{ #category : 'accessing' }
AmqpHeartbeatSender >> connectivityErrors [

  ^ NetworkError , ConnectionClosed , AmqpDisconnectedError
]

{ #category : 'accessing' }
AmqpHeartbeatSender >> heartbeatFrame [

	^ AmqpHeartbeatFrame new
		frameType: connection protocolClass frameHeartbeat;
		channelNumber: 0;
		yourself
]

{ #category : 'initialization' }
AmqpHeartbeatSender >> initializeKeepingOpen: anAmqpConnection [

	connection := anAmqpConnection.
	isStarted := false 
]

{ #category : 'accessing' }
AmqpHeartbeatSender >> mainKeepAliveCycleEvery: aTimeInterval [

  ^ [
      [
        ( Delay forSeconds: aTimeInterval ) wait.
        [
          connection sendFrame: self heartbeatFrame.
          connection codec flush
        ]
          on: self connectivityErrors
          do: [ :signal |
              LogRecord emitError:
                ( 'AMQP Heartbeat failed unexpectedly (<1s>).' expandMacrosWith: signal messageText ).
              connection hardCloseDescribedWith: signal messageText.
              ^ self
            ]
      ] repeat
    ] ensure: [ self stop ]
]

{ #category : 'accessing' }
AmqpHeartbeatSender >> spawnProcessSendingHeartbeatEvery: aTimeInterval [

  ^ ( Process
        forContext: [ self mainKeepAliveCycleEvery: aTimeInterval ] asContext
        priority: Processor userBackgroundPriority )
      name: 'Heartbeat sender';
      yourself
]

{ #category : 'startup-shutdown' }
AmqpHeartbeatSender >> startBeatingEvery: aTimeInSeconds [

  ( aTimeInSeconds strictlyPositive and: [ isStarted not ] ) then: [
      process := self spawnProcessSendingHeartbeatEvery: aTimeInSeconds.
      process resume.
      isStarted := true
    ]
]

{ #category : 'startup-shutdown' }
AmqpHeartbeatSender >> stop [

  isStarted then: [
      process ifNotNil: #terminate.
      isStarted := false
    ]
]
