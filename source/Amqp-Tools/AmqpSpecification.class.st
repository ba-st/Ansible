Class {
	#name : #AmqpSpecification,
	#superclass : #Object,
	#instVars : [
		'classDefinitions',
		'domains',
		'majorVersion',
		'minorVersion',
		'revision',
		'constants',
		'portNumber'
	],
	#category : #'Amqp-Tools'
}

{ #category : #'instance creation' }
AmqpSpecification class >> loadFrom: aUrl [

	^ self new loadFromXml: aUrl asUrl retrieveContents contents readStream
]

{ #category : #'as yet unclassified' }
AmqpSpecification class >> normalizeName: aString [

	| s |

	s := aString asLowercase.
	s := s copyReplaceAll: '-' with: ' '.
	s := s copyReplaceAll: '_' with: ' '.
	^ s
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

{ #category : #accessing }
AmqpSpecification >> allMethods [

	^ ( classDefinitions values collect: [ :each | each methods values ] ) flattened
]

{ #category : #accessing }
AmqpSpecification >> class: className method: methodName [

	^ ( self classAt: className ) methods at: methodName
]

{ #category : #accessing }
AmqpSpecification >> classAt: className [

	^ classDefinitions at: className
]

{ #category : #accessing }
AmqpSpecification >> classDefinitions [

	^ classDefinitions
]

{ #category : #accessing }
AmqpSpecification >> classDefinitions: anObject [

	classDefinitions := anObject
]

{ #category : #accessing }
AmqpSpecification >> constants [

	^ constants
]

{ #category : #accessing }
AmqpSpecification >> constants: anObject [

	constants := anObject
]

{ #category : #accessing }
AmqpSpecification >> domains [

	^ domains
]

{ #category : #accessing }
AmqpSpecification >> domains: anObject [

	domains := anObject
]

{ #category : #'as yet unclassified' }
AmqpSpecification >> insertBaseDomains [

	"For the benefit of the 0-8 spec, which is missing these ground definitions."

	#('octet' 'shortstr' 'longstr' 'short' 'long' 'longlong' 'bit' 'table' 'timestamp')
		do: [ :d | domains at: d put: d ]
]

{ #category : #'as yet unclassified' }
AmqpSpecification >> isObsoleteProtocolVariant [

	^ majorVersion = 0 and: [ minorVersion < 9 ]
]

{ #category : #'as yet unclassified' }
AmqpSpecification >> loadFromXml: aStream [

	| d a |

	d := XMLDOMParser parse: aStream.
	a := d findElementNamed: #amqp.

	majorVersion := ( a attributeAt: #major ) asInteger.
	minorVersion := ( a attributeAt: #minor ) asInteger.
	revision := ( a attributeAt: #revision ifAbsent: [ 0 ] ) asInteger.	"Special-case a mistake in the 0-8 XML."
	( majorVersion = 8 and: [ minorVersion = 0 ] )
		ifTrue: [ majorVersion := 0.
			minorVersion := 8
			].

	portNumber := ( a attributeAt: #port ) asInteger.

	constants := Dictionary new.

	a
		allElementsNamed: #constant
		do: [ :constant | 
			constants
				at: ( self class normalizeName: ( constant attributeAt: #name ) )
				put: ( constant attributeAt: #value ) asInteger
			].


	domains := Dictionary new.
	self insertBaseDomains.
	a
		allElementsNamed: #domain
		do: [ :domain | 
			domains
				at: ( self class normalizeName: ( domain attributeAt: #name ) )
				put: ( self class normalizeName: ( domain attributeAt: #type ) )
			].

	classDefinitions := Dictionary new.
	a
		elementsAt: #class
		do: [ :each | 
			AmqpClassDefinition new
				loadFrom: each;
				installOn: classDefinitions
			].

	self resolve
]

{ #category : #accessing }
AmqpSpecification >> majorVersion [

	^ majorVersion
]

{ #category : #accessing }
AmqpSpecification >> majorVersion: anObject [

	majorVersion := anObject
]

{ #category : #accessing }
AmqpSpecification >> minorVersion [

	^ minorVersion
]

{ #category : #accessing }
AmqpSpecification >> minorVersion: anObject [

	minorVersion := anObject
]

{ #category : #accessing }
AmqpSpecification >> portNumber [

	^ portNumber
]

{ #category : #accessing }
AmqpSpecification >> portNumber: anObject [

	portNumber := anObject
]

{ #category : #'as yet unclassified' }
AmqpSpecification >> resolve [

	classDefinitions valuesDo: [ :each | each resolveUsing: self ]
]

{ #category : #accessing }
AmqpSpecification >> resolveDomain: aString [

	^ domains at: ( self class normalizeName: aString )
]

{ #category : #accessing }
AmqpSpecification >> revision [

	^ revision
]

{ #category : #accessing }
AmqpSpecification >> revision: anObject [

	revision := anObject
]

{ #category : #'as yet unclassified' }
AmqpSpecification >> versionString [

	^ majorVersion asString , minorVersion asString
		,
			( revision > 0
				ifTrue: [ revision asString ]
				ifFalse: [ '' ] )
]
