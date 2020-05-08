Class {
	#name : #AmqpClassDefinition,
	#superclass : #AmqpEntityDefinition,
	#instVars : [
		'methods',
		'contentProperties'
	],
	#category : #'Ansible-Tools'
}

{ #category : #accessing }
AmqpClassDefinition >> contentProperties [

	^ contentProperties
]

{ #category : #accessing }
AmqpClassDefinition >> hasProperties [

	^ self contentProperties isNotEmpty
]

{ #category : #building }
AmqpClassDefinition >> loadFrom: anXmlNode [

	super loadFrom: anXmlNode.
	methods := Dictionary new.
	xml
		elementsAt: #method
		do: [ :each | 
			AmqpMethodDefinition new
				loadFrom: each;
				classDef: self;
				installOn: methods
			].

	contentProperties := OrderedCollection new.
	xml
		elementsAt: #field
		do: [ :each |  
			contentProperties
				add:
					( AmqpFieldDefinition new
						loadFrom: each;
						container: self )
			] 
]

{ #category : #accessing }
AmqpClassDefinition >> methods [

	^ methods
]

{ #category : #accessing }
AmqpClassDefinition >> propertiesAndMasksDo: aBlock [

	| i bitIndex bitMask |

	i := 0.
	contentProperties
		do: [ :prop | 
			( i rem: 16 ) = 15
				ifTrue: [ i := i + 1 ].
			bitIndex := i // 16 * 16 + ( 15 - ( i rem: 16 ) ).
			i := i + 1.
			bitMask := 1 bitShift: bitIndex.
			aBlock value: prop value: bitMask
			]
]

{ #category : #accessing }
AmqpClassDefinition >> resolveDomainUsing: spec [

	methods valuesDo: [ :each | each resolveDomainUsing: spec ].
	contentProperties do: [ :each | each resolveDomainUsing: spec ]
]
