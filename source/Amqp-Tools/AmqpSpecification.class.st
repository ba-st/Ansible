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

{ #category : #'as yet unclassified' }
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

{ #category : #'as yet unclassified' }
AmqpSpecification class >> official08 [

	^ self
		loadFrom: 'http://jira.amqp.org/confluence/download/attachments/720900/amqp0-8.stripped.xml?version=1'
]

{ #category : #'as yet unclassified' }
AmqpSpecification class >> official091 [

	^ self
		loadFrom: 'http://jira.amqp.org/confluence/download/attachments/720900/amqp0-9-1.stripped.xml?version=1'
]

{ #category : #accessing }
AmqpSpecification >> allMethods [

	^ ( classDefinitions values collect: [ :each | each methods values ] ) concatenation
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

	d := XMLDOMParser parseDocumentFrom: aStream.
	a := d firstTagNamed: #amqp.

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
		tagsNamed: #constant
		childrenDo: [ :each | 
			constants
				at: ( AmqpSpecification normalizeName: ( each attributeAt: #name ) )
				put: ( each attributeAt: #value ) asInteger
			].

	domains := Dictionary new.
	self insertBaseDomains.
	a
		tagsNamed: #domain
		childrenDo: [ :each | 
			domains
				at: ( AmqpSpecification normalizeName: ( each attributeAt: #name ) )
				put: ( AmqpSpecification normalizeName: ( each attributeAt: #type ) )
			].

	classDefinitions := Dictionary new.
	a
		tagsNamed: #class
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

	^ domains at: ( AmqpSpecification normalizeName: aString )
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
