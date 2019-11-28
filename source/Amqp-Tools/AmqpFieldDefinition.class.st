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

{ #category : #accessing }
AmqpFieldDefinition >> domainName [

	^ domain name
	
]

{ #category : #accessing }
AmqpFieldDefinition >> domainType [

	^ domain type
]

{ #category : #accessing }
AmqpFieldDefinition >> isReserved [

	^ reserved
]

{ #category : #building }
AmqpFieldDefinition >> loadFrom: anXmlNode [

	super loadFrom: anXmlNode.
	domain := xml
		attributeAt: #domain
		ifAbsent: [ xml attributeAt: #type ifAbsent: [ self error: 'field missing domain' ] ].
	reserved := ( xml attributeAt: #reserved ) = '1'
]

{ #category : #building }
AmqpFieldDefinition >> resolveDomainUsing: aSpec [

	domain := aSpec resolveDomainUsing: domain
]
