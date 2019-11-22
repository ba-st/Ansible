Class {
	#name : #AmqpMethodDefinition,
	#superclass : #AmqpEntityDefinition,
	#instVars : [
		'classDef',
		'fields',
		'hasContents',
		'serverMethod',
		'clientMethod',
		'synchronous',
		'responses'
	],
	#category : #'Amqp-Tools'
}

{ #category : #accessing }
AmqpMethodDefinition >> classDef [

	^ classDef
]

{ #category : #accessing }
AmqpMethodDefinition >> classDef: anObject [

	classDef := anObject
]

{ #category : #accessing }
AmqpMethodDefinition >> fields [

	^ fields
]

{ #category : #accessing }
AmqpMethodDefinition >> hasContents [

	^ hasContents
]

{ #category : #accessing }
AmqpMethodDefinition >> isClientMethod [

	^ clientMethod
]

{ #category : #accessing }
AmqpMethodDefinition >> isServerMethod [

	^ serverMethod
]

{ #category : #accessing }
AmqpMethodDefinition >> isSynchronous [

	^ synchronous
]

{ #category : #accessing }
AmqpMethodDefinition >> loadFrom: anXmlNode [

	super loadFrom: anXmlNode.
	fields := OrderedCollection new.
	xml
		elementsAt: #field
		do: [ :each | 
			fields
				add:
					( AmqpFieldDefinition new
						loadFrom: each;
						container: self )
			].
	hasContents := ( xml attributeAt: #content ) = '1'.
	synchronous := ( xml attributeAt: #synchronous ) = '1'.
	xml
		elementsAt: #chassis
		do: [ :each | 
			( each attributeAt: #name ) = 'server'
				ifTrue: [ serverMethod := true ].
			( each attributeAt: #name ) = 'client'
				ifTrue: [ clientMethod := true ]
			].
	responses := Set new.
	xml
		elementsAt: #response
		do: [ :each | responses add: ( NormalizedName from: ( each attributeAt: #name ) ) ]
]

{ #category : #'as yet unclassified' }
AmqpMethodDefinition >> methodId [

	^ ( self classDef index bitShift: 16 ) bitOr: self index
]

{ #category : #accessing }
AmqpMethodDefinition >> resolveUsing: spec [

	fields do: [ :each | each resolveUsing: spec ]
]

{ #category : #accessing }
AmqpMethodDefinition >> responses [

	^ responses
]
