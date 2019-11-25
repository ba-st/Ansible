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
			| substrings |

			substrings := self name1 substrings.
			stream nextPutAll: substrings first.
			substrings allButFirstDo: [ :substring | stream nextPutAll: substring capitalized ]
			]
]

{ #category : #accessing }
AmqpName >> name [

	^ name
]

{ #category : #accessing }
AmqpName >> name1 [

	| s |

	s := name asLowercase.
	s := s copyReplaceAll: '-' with: ' '.
	s := s copyReplaceAll: '_' with: ' '.
	^ s
]

{ #category : #printing }
AmqpName >> printOn: aStream [

	aStream nextPutAll: name
]

{ #category : #transforming }
AmqpName >> upperCamelCased [

	^ String
		streamContents:
			[ :stream | self name1 substrings collect: #capitalized thenDo: [ :capitalized | stream nextPutAll: capitalized ] ]
]
