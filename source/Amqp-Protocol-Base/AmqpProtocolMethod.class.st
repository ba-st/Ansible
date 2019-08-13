Class {
	#name : #AmqpProtocolMethod,
	#superclass : #Object,
	#category : #'Amqp-Protocol-Base'
}

{ #category : #'as yet unclassified' }
AmqpProtocolMethod >> acceptableResponseClasses [

	self subclassResponsibility
]

{ #category : #'as yet unclassified' }
AmqpProtocolMethod >> codecMethodId [

	self subclassResponsibility
]

{ #category : #'as yet unclassified' }
AmqpProtocolMethod >> decodeFrom: codec [

	self subclassResponsibility
]

{ #category : #'as yet unclassified' }
AmqpProtocolMethod >> encodeOn: codec [

	self subclassResponsibility
]

{ #category : #'as yet unclassified' }
AmqpProtocolMethod >> hasContents [

	self subclassResponsibility
]
