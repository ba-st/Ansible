Class {
	#name : #AmqpContentBodyFrame,
	#superclass : #AmqpFrame,
	#instVars : [
		'fragment'
	],
	#category : #'Ansible-Protocol-Core'
}

{ #category : #accessing }
AmqpContentBodyFrame >> encodeBodyOn: codec [

	"do nothing."

	
]

{ #category : #accessing }
AmqpContentBodyFrame >> encodedBody [

	^ fragment
]

{ #category : #accessing }
AmqpContentBodyFrame >> fragment [

	^ fragment
]

{ #category : #accessing }
AmqpContentBodyFrame >> fragment: anObject [

	fragment := anObject
]

{ #category : #accessing }
AmqpContentBodyFrame >> readFrom: conn length: length [

	fragment := conn codec stream next: length
]
