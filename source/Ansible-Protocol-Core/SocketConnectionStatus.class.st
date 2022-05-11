Class {
	#name : #SocketConnectionStatus,
	#superclass : #Object,
	#category : #'Ansible-Protocol-Core'
}

{ #category : #evaluating }
SocketConnectionStatus >> whenConnected: aBlock whenNot: anotherBlock [

	self subclassResponsibility
]
