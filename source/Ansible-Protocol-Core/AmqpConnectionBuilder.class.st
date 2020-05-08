Class {
	#name : #AmqpConnectionBuilder,
	#superclass : #Object,
	#instVars : [
		'parameters',
		'hostname',
		'username',
		'password'
	],
	#category : #'Ansible-Protocol-Core'
}

{ #category : #building }
AmqpConnectionBuilder >> build [

	^ AmqpConnection
		to: hostname
		using: Amqp091
		with: self credentials
		parameterizedBy: parameters
]

{ #category : #building }
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
	"Initialize default values."
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
AmqpConnectionBuilder >> username: anUsername [

	username := anUsername
]
