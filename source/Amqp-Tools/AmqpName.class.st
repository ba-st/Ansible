Class {
	#name : #AmqpName,
	#superclass : #Object,
	#instVars : [
		'name'
	],
	#category : #'Amqp-Tools'
}

{ #category : #'instance creation' }
AmqpName class >> from: aString [ 
	
	^ self new initializeFrom: aString
]

{ #category : #comparing }
AmqpName >> = anObject [

	^ self class = anObject class and: [ self name = anObject name ]
]

{ #category : #comparing }
AmqpName >> hash [

	^ name hash 
]

{ #category : #initialization }
AmqpName >> initializeFrom: aString [ 
	
	name := aString
]

{ #category : #transforming }
AmqpName >> lowerCamelCased [

	^ String
		streamContents: [ :stream | 
			| parts |

			parts := self parts.
			stream nextPutAll: parts first.
			parts allButFirstDo: [ :part | stream nextPutAll: part capitalized ]
			]
]

{ #category : #accessing }
AmqpName >> name [

	^ name
]

{ #category : #accessing }
AmqpName >> parts [ 

	| string |

	string := name asLowercase.
	string := string copyReplaceAll: '-' with: ' '.
	string := string copyReplaceAll: '_' with: ' '.
	^ string substrings
]

{ #category : #printing }
AmqpName >> printOn: aStream [

	aStream nextPutAll: name
]

{ #category : #transforming }
AmqpName >> upperCamelCased [

	^ String
		streamContents:
			[ :stream | self parts collect: #capitalized thenDo: [ :capitalizedPart | stream nextPutAll: capitalizedPart ] ]
]
