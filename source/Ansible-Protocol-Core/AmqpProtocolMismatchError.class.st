Class {
	#name : 'AmqpProtocolMismatchError',
	#superclass : 'AmqpError',
	#instVars : [
		'serverProtocolHeader'
	],
	#category : 'Ansible-Protocol-Core',
	#package : 'Ansible-Protocol-Core'
}

{ #category : 'accessing' }
AmqpProtocolMismatchError >> serverProtocolHeader [

	^ serverProtocolHeader
]

{ #category : 'accessing' }
AmqpProtocolMismatchError >> serverProtocolHeader: anObject [

	serverProtocolHeader := anObject
]
