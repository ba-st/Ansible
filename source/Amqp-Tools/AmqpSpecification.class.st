Class {
	#name : #AmqpSpecification,
	#superclass : #Object,
	#instVars : [
		'classDefinitions',
		'majorVersion',
		'minorVersion',
		'revision',
		'portNumber',
		'domainDefinitions',
		'constantDefinitions'
	],
	#category : #'Amqp-Tools'
}

{ #category : #'instance creation' }
AmqpSpecification class >> loadFrom: aUrl [

	^ self new initializeLoadFromXml: aUrl asUrl retrieveContents contents readStream
]

{ #category : #'instance creation' }
AmqpSpecification class >> official08 [

	^ self
		loadFrom: 'https://raw.githubusercontent.com/fortizpenaloza/Lepus/release-candidate/assets/specs/amqp0-8.stripped.xml'

]

{ #category : #'instance creation' }
AmqpSpecification class >> official091 [

	^ self
		loadFrom: 'https://raw.githubusercontent.com/fortizpenaloza/Lepus/release-candidate/assets/specs/amqp0-9-1.stripped.xml'
]

{ #category : #'as yet unclassified' }
AmqpSpecification >> addElementaryDomains [

	"For the benefit of the 0-8 spec, which is missing these ground definitions."

	#('octet' 'shortstr' 'longstr' 'short' 'long' 'longlong' 'bit' 'table' 'timestamp')
		do:
			[ :elementaryType | domainDefinitions add: ( AmqpDomainDefinition named: elementaryType of: elementaryType ) ]
]

{ #category : #accessing }
AmqpSpecification >> allMethods [

	^ ( classDefinitions values collect: [ :each | each methods values ] ) flattened
]

{ #category : #accessing }
AmqpSpecification >> classDefinitions [

	^ classDefinitions
]

{ #category : #accessing }
AmqpSpecification >> constants [

	^ constantDefinitions
]

{ #category : #accessing }
AmqpSpecification >> domains [

	^ domainDefinitions
]

{ #category : #initialization }
AmqpSpecification >> initializeClassDefinitionsFrom: root [

	classDefinitions := Dictionary new.
	root
		elementsAt: #class
		do: [ :each | 
			AmqpClassDefinition new
				loadFrom: each;
				installOn: classDefinitions
			]
]

{ #category : #initialization }
AmqpSpecification >> initializeConstantsFrom: root [

	constantDefinitions := OrderedCollection new.
	root
		allElementsNamed: #constant
		do: [ :constant | 
			constantDefinitions
				add:
					( AmqpConstantDefinition
						named: ( constant attributeAt: #name )
						holding: ( constant attributeAt: #value ) asInteger )
			]
]

{ #category : #initialization }
AmqpSpecification >> initializeDomainsFrom: root [

	domainDefinitions := Set new.

	self addElementaryDomains.
	root
		allElementsNamed: #domain
		do: [ :domain | 
			domainDefinitions
				add: ( AmqpDomainDefinition named: ( domain attributeAt: #name ) of: ( domain attributeAt: #type ) )
			]
]

{ #category : #initialization }
AmqpSpecification >> initializeLoadFromXml: aStream [

	| document root |

	document := XMLDOMParser parse: aStream.
	root := document findElementNamed: #amqp.
	self
		initializeVersionFrom: root;
		initializePortNumberFrom: root;
		initializeConstantsFrom: root;
		initializeDomainsFrom: root;
		initializeClassDefinitionsFrom: root;
		resolve
]

{ #category : #initialization }
AmqpSpecification >> initializePortNumberFrom: root [

	portNumber := ( root attributeAt: #port ) asInteger
]

{ #category : #initialization }
AmqpSpecification >> initializeVersionFrom: root [

	majorVersion := ( root attributeAt: #major ) asInteger.
	minorVersion := ( root attributeAt: #minor ) asInteger.
	revision := ( root attributeAt: #revision ifAbsent: [ 0 ] ) asInteger.	"Special-case a mistake in the 0-8 XML."
		
	( majorVersion = 8 and: [ minorVersion = 0 ] )
		ifTrue: [ majorVersion := 0.
			minorVersion := 8
			]
]

{ #category : #'as yet unclassified' }
AmqpSpecification >> isObsoleteProtocolVariant [

	^ majorVersion = 0 and: [ minorVersion < 9 ]
]

{ #category : #accessing }
AmqpSpecification >> majorVersion [

	^ majorVersion
]

{ #category : #accessing }
AmqpSpecification >> minorVersion [

	^ minorVersion
]

{ #category : #accessing }
AmqpSpecification >> portNumber [

	^ portNumber
]

{ #category : #'as yet unclassified' }
AmqpSpecification >> resolve [

	classDefinitions valuesDo: [ :each | each resolveDomainUsing: self ]
]

{ #category : #accessing }
AmqpSpecification >> resolveDomainUsing: aDomainName [

	^ domainDefinitions detect: [ :domain | domain name = ( AmqpName from: aDomainName ) ]
]

{ #category : #accessing }
AmqpSpecification >> revision [

	^ revision
]

{ #category : #'as yet unclassified' }
AmqpSpecification >> versionString [

	^ majorVersion asString , minorVersion asString
		,
			( revision > 0
				ifTrue: [ revision asString ]
				ifFalse: [ '' ] )
]
