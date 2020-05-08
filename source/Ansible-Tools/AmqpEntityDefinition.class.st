Class {
	#name : #AmqpEntityDefinition,
	#superclass : #Object,
	#instVars : [
		'name',
		'xml',
		'index'
	],
	#category : #'Ansible-Tools'
}

{ #category : #accessing }
AmqpEntityDefinition >> index [

	^ index
]

{ #category : #accessing }
AmqpEntityDefinition >> index: anObject [

	index := anObject
]

{ #category : #building }
AmqpEntityDefinition >> installOn: aDictionary [

	aDictionary at: name put: self
]

{ #category : #building }
AmqpEntityDefinition >> loadFrom: anXmlNode [

	xml := anXmlNode.
	name := AmqpName from: ( xml attributeAt: #name ).
	index := xml attributeAt: #index ifAbsent: [ nil ].
	index ifNotNil: [ index := index asInteger ]
]

{ #category : #accessing }
AmqpEntityDefinition >> name [

	^ name
]

{ #category : #accessing }
AmqpEntityDefinition >> name: anObject [

	name := anObject
]

{ #category : #printing }
AmqpEntityDefinition >> printOn: aStream [

	super printOn: aStream.
	aStream
		space;
		nextPutAll: name asString;
		nextPut: $(;
		nextPutAll: index asString;
		nextPut: $)
]

{ #category : #accessing }
AmqpEntityDefinition >> xml [

	^ xml
]

{ #category : #accessing }
AmqpEntityDefinition >> xml: anObject [

	xml := anObject
]
