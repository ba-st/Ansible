Class {
	#name : #AmqpConnectionBuilder,
	#superclass : #Object,
	#instVars : [
		'parameters',
		'hostname',
		'username',
		'password',
		'protocol'
	],
	#category : #'Ansible-Protocol-Core'
}

{ #category : #building }
AmqpConnectionBuilder >> build [

	protocol ifNil: [ Error signal: 'Protocol must be configured' ].

	^ AmqpConnection
		to: hostname
		using: protocol
		with: self credentials
		parameterizedBy: parameters
]

{ #category : #'private-accessing' }
AmqpConnectionBuilder >> credentials [

	^ AmqpPlainCredentials new
		username: username;
		password: password
]

{ #category : #configuring }
AmqpConnectionBuilder >> hostname: aHostname [
	
	hostname := aHostname 
]

{ #category : #initialization }
AmqpConnectionBuilder >> initialize [

	super initialize.
	
	username := 'guest'.
	password := 'guest'.
	hostname := 'localhost'.
	parameters := AmqpConnectionParameters new
		channelMax: 0;
		frameMax: 131072;
		heartbeat: 0
]

{ #category : #configuring }
AmqpConnectionBuilder >> password: aPassword [

	password := aPassword
]

{ #category : #configuring }
AmqpConnectionBuilder >> protocol: aProtocol [

	protocol := aProtocol
]

{ #category : #configuring }
AmqpConnectionBuilder >> username: anUsername [

	username := anUsername
]
