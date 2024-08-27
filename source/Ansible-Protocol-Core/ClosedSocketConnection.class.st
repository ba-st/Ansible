Class {
	#name : 'ClosedSocketConnection',
	#superclass : 'SocketConnectionStatus',
	#instVars : [
		'error'
	],
	#category : 'Ansible-Protocol-Core',
	#package : 'Ansible-Protocol-Core'
}

{ #category : 'instance creation' }
ClosedSocketConnection class >> dueTo: anError [

	^ self new initializeDueTo: anError
]

{ #category : 'initialization' }
ClosedSocketConnection >> initializeDueTo: anError [

	error := anError
]

{ #category : 'initialization' }
ClosedSocketConnection >> whenConnected: aBlock whenNot: anotherBlock [

	^ anotherBlock cull: error
]
