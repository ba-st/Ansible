Class {
	#name : 'HealthyClosedSocketConnection',
	#superclass : 'SocketConnectionStatus',
	#instVars : [
		'error'
	],
	#category : 'Ansible-Protocol-Core',
	#package : 'Ansible-Protocol-Core'
}

{ #category : 'instance creation' }
HealthyClosedSocketConnection class >> dueTo: anError [

	^ self new initializeDueTo: anError
]

{ #category : 'initialization' }
HealthyClosedSocketConnection >> initializeDueTo: anError [

	error := anError
]

{ #category : 'initialization' }
HealthyClosedSocketConnection >> whenConnected: aBlock whenNot: anotherBlock [

	^ anotherBlock cull: error
]
