Class {
	#name : 'SocketConnectionStatus',
	#superclass : 'Object',
	#category : 'Ansible-Protocol-Core',
	#package : 'Ansible-Protocol-Core'
}

{ #category : 'evaluating' }
SocketConnectionStatus >> whenConnected: aBlock whenNot: anotherBlock [

	self subclassResponsibility
]
