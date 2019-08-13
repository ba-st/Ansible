Class {
	#name : #AmqpClassDefinition,
	#superclass : #AmqpEntityDefinition,
	#instVars : [
		'methods',
		'contentProperties'
	],
	#category : #'Amqp-Tools'
}

{ #category : #accessing }
AmqpClassDefinition >> contentProperties [

	^ contentProperties
]

{ #category : #'as yet unclassified' }
AmqpClassDefinition >> hasProperties [

	^ self contentProperties isEmpty not
]

{ #category : #'as yet unclassified' }
AmqpClassDefinition >> loadFrom: anXmlNode [

	super loadFrom: anXmlNode.
	methods := Dictionary new.
	xml
		tagsNamed: #method
		do: [ :each | 
			AmqpMethodDefinition new
				loadFrom: each;
				classDef: self;
				installOn: methods
			].

	contentProperties := OrderedCollection new.
	xml
		tagsNamed: #field
		childrenDo: [ :each | 
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

{ #category : #'as yet unclassified' }
AmqpClassDefinition >> propertiesName [

	^ self name , ' properties'
]

{ #category : #accessing }
AmqpClassDefinition >> resolveUsing: spec [

	methods valuesDo: [ :each | each resolveUsing: spec ].
	contentProperties do: [ :each | each resolveUsing: spec ]
]
