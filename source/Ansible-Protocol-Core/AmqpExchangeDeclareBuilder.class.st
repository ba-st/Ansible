Class {
	#name : #AmqpExchangeDeclareBuilder,
	#superclass : #Object,
	#instVars : [
		'name',
		'type',
		'durable',
		'autoDelete',
		'passive',
		'arguments',
		'protocolVersion'
	],
	#category : #'Ansible-Protocol-Core'
}

{ #category : #'instance creation' }
AmqpExchangeDeclareBuilder class >> named: aName of: aType for: aProtocolVersion [

	^ self new initializeNamed: aName of: aType for: aProtocolVersion
]

{ #category : #building }
AmqpExchangeDeclareBuilder >> buildApplying: aBlock [

	aBlock value: self.

	^ protocolVersion exchangeDeclareMethod new
		exchange: name;
		type: type;
		passive: passive;
		durable: durable;
		autoDelete: autoDelete;
		arguments: arguments
]

{ #category : #initialization }
AmqpExchangeDeclareBuilder >> initializeNamed: aName of: aType for: aProtocolVersion [

	protocolVersion := aProtocolVersion.
	name := aName.
	type := aType.
	"Initialize default values."
	durable := false.
	autoDelete := false.
	passive := false.
	arguments := nil
]
