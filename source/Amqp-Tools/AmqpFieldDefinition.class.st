Class {
	#name : #AmqpFieldDefinition,
	#superclass : #AmqpEntityDefinition,
	#instVars : [
		'container',
		'domain',
		'reserved'
	],
	#category : #'Amqp-Tools'
}

{ #category : #tranforming }
AmqpFieldDefinition >> asVariableName [
	
	 ^ name asMethodName
	
]

{ #category : #accessing }
AmqpFieldDefinition >> container [

	^ container
]

{ #category : #accessing }
AmqpFieldDefinition >> container: anObject [

	container := anObject
]

{ #category : #accessing }
AmqpFieldDefinition >> domain [

	^ domain
]

{ #category : #accessing }
AmqpFieldDefinition >> domain: anObject [

	domain := anObject
]

{ #category : #'as yet unclassified' }
AmqpFieldDefinition >> domainName [

	^ domain upperCamelCase
	
]

{ #category : #'as yet unclassified' }
AmqpFieldDefinition >> isReserved [

	^ reserved
]

{ #category : #'as yet unclassified' }
AmqpFieldDefinition >> loadFrom: anXmlNode [

	super loadFrom: anXmlNode.
	domain := xml
		attributeAt: #domain
		ifAbsent: [ xml attributeAt: #type ifAbsent: [ self error: 'field missing domain' ] ].
	reserved := ( xml attributeAt: #reserved ) = '1'
]

{ #category : #'as yet unclassified' }
AmqpFieldDefinition >> resolveUsing: spec [

	domain := spec resolveDomain: domain
]
