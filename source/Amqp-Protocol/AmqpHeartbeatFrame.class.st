Class {
	#name : #AmqpHeartbeatFrame,
	#superclass : #AmqpFrame,
	#category : #'Amqp-Protocol'
}

{ #category : #accessing }
AmqpHeartbeatFrame >> encodeBodyOn: codec [

	"do nothing."

	
]

{ #category : #accessing }
AmqpHeartbeatFrame >> readFrom: conn length: length [

	length = 0
		ifFalse: [ AmqpProtocolSyntaxError signal: 'Illegal heartbeat frame from server' ]
]
