Class {
	#name : #AmqpDomainDefinition,
	#superclass : #Object,
	#instVars : [
		'name',
		'type'
	],
	#category : #'Amqp-Tools'
}

{ #category : #'instance creation' }
AmqpDomainDefinition class >> named: aName of: aType [

	^ self new initializeNamed: aName of: aType
]

{ #category : #comparing }
AmqpDomainDefinition >> = anObject [

	^ self class = anObject class and: [ self name = anObject name ]
]

{ #category : #comparing }
AmqpDomainDefinition >> hash [

	^ name hash 
]

{ #category : #initialization }
AmqpDomainDefinition >> initializeNamed: aName of: aType [

	name := AmqpName from: aName.
	type := aType
]

{ #category : #accessing }
AmqpDomainDefinition >> name [

	^ name
]

{ #category : #printing }
AmqpDomainDefinition >> printOn: aStream [

	aStream
		nextPutAll: name asString;
		space;
		nextPut: $-;
		nextPut: $>;
		space;
		nextPutAll: type
]

{ #category : #accessing }
AmqpDomainDefinition >> type [

	^ type
]
