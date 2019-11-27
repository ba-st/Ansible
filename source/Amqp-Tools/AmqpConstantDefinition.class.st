Class {
	#name : #AmqpConstantDefinition,
	#superclass : #Object,
	#instVars : [
		'name',
		'value'
	],
	#category : #'Amqp-Tools'
}

{ #category : #'instance creation' }
AmqpConstantDefinition class >> named: aName holding: aValue [

	^ self new initializeNamed: aName holding: aValue
]

{ #category : #initialization }
AmqpConstantDefinition >> initializeNamed: aName holding: aValue [

	name := AmqpName from: aName.
	value := aValue
]

{ #category : #accessing }
AmqpConstantDefinition >> name [

	^ name
]

{ #category : #accessing }
AmqpConstantDefinition >> value [ 
	
	^ value 
]
