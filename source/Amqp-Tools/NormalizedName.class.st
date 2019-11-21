Class {
	#name : #NormalizedName,
	#superclass : #Object,
	#instVars : [
		'name'
	],
	#category : #'Amqp-Tools'
}

{ #category : #'instance creation' }
NormalizedName class >> from: aString [ 
	
	^ self new initializeFrom: aString
]

{ #category : #comparing }
NormalizedName >> = anObject [

	^ self class = anObject class and: [ self name = anObject name ]
]

{ #category : #comparing }
NormalizedName >> hash [

	^ name hash 
]

{ #category : #initialization }
NormalizedName >> initializeFrom: aString [ 
	
	name := aString
]

{ #category : #accessing }
NormalizedName >> name [

	| s |

	s := name asLowercase.
	s := s copyReplaceAll: '-' with: ' '.
	s := s copyReplaceAll: '_' with: ' '.
	^ s
]

{ #category : #printing }
NormalizedName >> printOn: aStream [

	aStream nextPutAll: name
]
