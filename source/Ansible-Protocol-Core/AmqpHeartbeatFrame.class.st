Class {
	#name : 'AmqpHeartbeatFrame',
	#superclass : 'AmqpFrame',
	#category : 'Ansible-Protocol-Core',
	#package : 'Ansible-Protocol-Core'
}

{ #category : 'accessing' }
AmqpHeartbeatFrame >> encodeBodyOn: codec [

	"do nothing."

	
]

{ #category : 'accessing' }
AmqpHeartbeatFrame >> readFrom: connection length: length [

	length = 0
		ifFalse: [ AmqpProtocolSyntaxError signal: 'Illegal heartbeat frame from server' ]
]
