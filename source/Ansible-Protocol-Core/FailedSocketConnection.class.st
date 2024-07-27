Class {
	#name : 'FailedSocketConnection',
	#superclass : 'SocketConnectionStatus',
	#instVars : [
		'error'
	],
	#category : 'Ansible-Protocol-Core',
	#package : 'Ansible-Protocol-Core'
}

{ #category : 'instance creation' }
FailedSocketConnection class >> dueTo: anError [

	^ self new initializeDueTo: anError
]

{ #category : 'initialization' }
FailedSocketConnection >> initializeDueTo: anError [

	error := anError
]

{ #category : 'evaluating' }
FailedSocketConnection >> whenConnected: aBlock whenNot: anotherBlock [

	^anotherBlock cull: error
]
