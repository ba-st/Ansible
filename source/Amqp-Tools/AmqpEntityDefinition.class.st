Class {
	#name : #AmqpEntityDefinition,
	#superclass : #Object,
	#instVars : [
		'name',
		'xml',
		'index'
	],
	#category : #'Amqp-Tools'
}

{ #category : #accessing }
AmqpEntityDefinition >> index [

	^ index
]

{ #category : #accessing }
AmqpEntityDefinition >> index: anObject [

	index := anObject
]

{ #category : #'as yet unclassified' }
AmqpEntityDefinition >> installOn: aDictionary [

	aDictionary at: name put: self
]

{ #category : #'as yet unclassified' }
AmqpEntityDefinition >> loadFrom: anXmlNode [

	xml := anXmlNode.
	name := AmqpSpecification normalizeName: ( xml attributeAt: #name ).
	index := xml attributeAt: #index ifAbsent: [ nil ].
	index ifNotNil: [ index := index asInteger ]
]

{ #category : #accessing }
AmqpEntityDefinition >> methodName [

	^ AmqpSpecCompiler methodNameFor: name
]

{ #category : #accessing }
AmqpEntityDefinition >> name [

	^ name
]

{ #category : #accessing }
AmqpEntityDefinition >> name: anObject [

	name := anObject
]

{ #category : #'as yet unclassified' }
AmqpEntityDefinition >> printOn: aStream [

	super printOn: aStream.
	aStream
		space;
		nextPutAll: name;
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
