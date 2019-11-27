Class {
	#name : #AmqpConnectionParameters,
	#superclass : #Object,
	#instVars : [
		'channelMax',
		'frameMax',
		'heartbeat'
	],
	#category : #'Amqp-Protocol'
}

{ #category : #accessing }
AmqpConnectionParameters >> applyServerSettings: aTune [

	channelMax := self combine: channelMax with: aTune channelMax.
	frameMax := self combine: frameMax with: aTune frameMax.
	heartbeat := self combine: heartbeat with: aTune heartbeat
]

{ #category : #accessing }
AmqpConnectionParameters >> channelMax [

	^ channelMax
]

{ #category : #accessing }
AmqpConnectionParameters >> channelMax: anObject [

	channelMax := anObject
]

{ #category : #accessing }
AmqpConnectionParameters >> combine: v1 with: v2 [

	v1 = 0
		ifTrue: [ ^ v2 ].
	v2 = 0
		ifTrue: [ ^ v1 ].
	^ v1 min: v2
]

{ #category : #accessing }
AmqpConnectionParameters >> frameMax [

	^ frameMax
]

{ #category : #accessing }
AmqpConnectionParameters >> frameMax: anObject [

	frameMax := anObject
]

{ #category : #accessing }
AmqpConnectionParameters >> heartbeat [

	^ heartbeat
]

{ #category : #accessing }
AmqpConnectionParameters >> heartbeat: anObject [

	heartbeat := anObject
]
