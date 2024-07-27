Class {
	#name : 'SuccesfulSocketConnection',
	#superclass : 'SocketConnectionStatus',
	#category : 'Ansible-Protocol-Core',
	#package : 'Ansible-Protocol-Core'
}

{ #category : 'evaluating' }
SuccesfulSocketConnection >> whenConnected: aBlock whenNot: anotherBlock [

	^aBlock value
]
