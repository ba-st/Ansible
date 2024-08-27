Class {
	#name : 'AmqpQueueDeclareBuilder',
	#superclass : 'Object',
	#instVars : [
		'protocolVersion',
		'queueName',
		'passive',
		'durable',
		'exclusive',
		'autoDelete',
		'arguments'
	],
	#category : 'Ansible-Protocol-Core',
	#package : 'Ansible-Protocol-Core'
}

{ #category : 'instance creation' }
AmqpQueueDeclareBuilder class >> for: aProtocolVersion [
	
	^ self new initializeFor: aProtocolVersion 
]

{ #category : 'configuring' }
AmqpQueueDeclareBuilder >> autoDelete [

	autoDelete := true
]

{ #category : 'configuring' }
AmqpQueueDeclareBuilder >> beDurable [
	
	durable := true
]

{ #category : 'configuring' }
AmqpQueueDeclareBuilder >> beExclusive [
	
	exclusive := true
]

{ #category : 'configuring' }
AmqpQueueDeclareBuilder >> bePassive [
	
	passive := true
]

{ #category : 'building' }
AmqpQueueDeclareBuilder >> buildApplying: aBlock [

	aBlock value: self.

	^ protocolVersion queueDeclareMethod new
		queue: queueName;
		durable: durable;
		exclusive: exclusive;
		autoDelete: autoDelete;		
		passive: passive;
		arguments: arguments
]

{ #category : 'initialization' }
AmqpQueueDeclareBuilder >> initializeFor: aProtocolVersion [

	protocolVersion := aProtocolVersion.
	"Initialize default values."
	queueName := ''.
	durable := false.
	exclusive := false.
	autoDelete := false.
	passive := false.
	arguments := nil
]

{ #category : 'configuring' }
AmqpQueueDeclareBuilder >> name: aQueueName [ 
	
	queueName := aQueueName
]

{ #category : 'configuring' }
AmqpQueueDeclareBuilder >> useAsArguments: aDictionary [

  arguments := aDictionary
]
