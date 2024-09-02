Class {
	#name : 'AmqpExchangeDeclareBuilder',
	#superclass : 'Object',
	#instVars : [
		'name',
		'type',
		'durable',
		'passive',
		'arguments',
		'protocolVersion'
	],
	#category : 'Ansible-Protocol-Core',
	#package : 'Ansible-Protocol-Core'
}

{ #category : 'instance creation' }
AmqpExchangeDeclareBuilder class >> named: aName of: aType for: aProtocolVersion [

	^ self new initializeNamed: aName of: aType for: aProtocolVersion
]

{ #category : 'configuring' }
AmqpExchangeDeclareBuilder >> beDurable [

	durable := true
]

{ #category : 'configuring' }
AmqpExchangeDeclareBuilder >> bePassive [

	passive := true
]

{ #category : 'building' }
AmqpExchangeDeclareBuilder >> buildApplying: aBlock [

	aBlock value: self.

	^ protocolVersion exchangeDeclareMethod new
		exchange: name;
		type: type;
		passive: passive;
		durable: durable;
		arguments: arguments
]

{ #category : 'initialization' }
AmqpExchangeDeclareBuilder >> initializeNamed: aName of: aType for: aProtocolVersion [

	protocolVersion := aProtocolVersion.
	name := aName.
	type := aType.
	"Initialize default values."
	durable := false.
	passive := false.
	arguments := nil
]

{ #category : 'building' }
AmqpExchangeDeclareBuilder >> useAsArguments: aDictionary [

  arguments := aDictionary
]
