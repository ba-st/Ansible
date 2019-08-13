Class {
	#name : #AmqpConnectionBuilder,
	#superclass : #Object,
	#instVars : [
		'credentials',
		'parameters',
		'hostname'
	],
	#category : #'Amqp-Protocol'
}

{ #category : #building }
AmqpConnectionBuilder >> build [
	
	^AmqpConnection to: hostname using: Amqp091.
]

{ #category : #configuring }
AmqpConnectionBuilder >> hostname: aHostname [
	
	hostname := aHostname 
]

{ #category : #initialization }
AmqpConnectionBuilder >> initialize [

	super initialize.
	credentials := AmqpPlainCredentials new
		username: 'guest';
		password: 'guest'.
	parameters := AmqpConnectionParameters new
		channelMax: 0;
		frameMax: 131072;
		heartbeat: 0
]
