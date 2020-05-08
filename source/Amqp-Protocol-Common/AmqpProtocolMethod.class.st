Class {
	#name : #AmqpProtocolMethod,
	#superclass : #Object,
	#category : #'Amqp-Protocol-Common'
}

{ #category : #accessing }
AmqpProtocolMethod >> acceptableResponseClasses [

	self subclassResponsibility
]

{ #category : #accessing }
AmqpProtocolMethod >> codecMethodId [

	self subclassResponsibility
]

{ #category : #decoding }
AmqpProtocolMethod >> decodeFrom: codec [

	self subclassResponsibility
]

{ #category : #encoding }
AmqpProtocolMethod >> encodeOn: codec [

	self subclassResponsibility
]

{ #category : #testing }
AmqpProtocolMethod >> hasContents [

	self subclassResponsibility
]
