Class {
	#name : #AmqpCommand,
	#superclass : #Object,
	#instVars : [
		'method',
		'properties',
		'body'
	],
	#category : #'Ansible-Protocol-Core'
}

{ #category : #accessing }
AmqpCommand >> body [

	^ body
]

{ #category : #accessing }
AmqpCommand >> body: anObject [

	body := anObject
]

{ #category : #accessing }
AmqpCommand >> method [

	^ method
]

{ #category : #accessing }
AmqpCommand >> method: anObject [

	method := anObject
]

{ #category : #accessing }
AmqpCommand >> properties [

	^ properties
]

{ #category : #accessing }
AmqpCommand >> properties: anObject [

	properties := anObject
]
