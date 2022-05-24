Class {
	#name : #AmqpHeartbeatSender,
	#superclass : #Object,
	#instVars : [
		'connection',
		'process',
		'isStarted'
	],
	#category : #'Ansible-Protocol-Core'
}

{ #category : #'instance creation' }
AmqpHeartbeatSender class >> keepingOpen: anAmqpConnection [

	^ self new initializeKeepingOpen: anAmqpConnection
]

{ #category : #accessing }
AmqpHeartbeatSender >> heartbeatFrame [

	^ AmqpHeartbeatFrame new
		frameType: connection protocolClass frameHeartbeat;
		channelNumber: 0;
		yourself
]

{ #category : #initialization }
AmqpHeartbeatSender >> initializeKeepingOpen: anAmqpConnection [

	connection := anAmqpConnection.
	isStarted := false 
]

{ #category : #accessing }
AmqpHeartbeatSender >> spawnProcessSendingHeartbeatEvery: aTimeInterval [

	^ ( Process
			forContext: [ 
				[ 
					[ 
						( Delay forSeconds: aTimeInterval ) wait.
						connection sendFrame: self heartbeatFrame.
						connection codec flush
					] repeat
				] ensure: [ process terminate ]
			] asContext
		priority: Processor userBackgroundPriority )
		name: 'Heartbeat sender';
		yourself
]

{ #category : #'startup-shutdown' }
AmqpHeartbeatSender >> startBeatingEvery: aTimeInterval [

	aTimeInterval ~= 0
		ifTrue: [ process := self spawnProcessSendingHeartbeatEvery: aTimeInterval.
			process resume.
			isStarted := true
			]
]

{ #category : #'startup-shutdown' }
AmqpHeartbeatSender >> stop [

	process terminate
]
