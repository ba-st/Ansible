Class {
	#name : #AmqpHeartbeatFrame,
	#superclass : #AmqpFrame,
	#category : #'Amqp-Protocol'
}

{ #category : #'as yet unclassified' }
AmqpHeartbeatFrame >> encodedBody [

	^ ByteArray new
]

{ #category : #'as yet unclassified' }
AmqpHeartbeatFrame >> readFrom: conn length: length [

	length = 0
		ifFalse: [ AmqpProtocolSyntaxError signal: 'Illegal heartbeat frame from server' ]
]
