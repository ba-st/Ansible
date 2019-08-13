Class {
	#name : #AmqpProtocolMismatchError,
	#superclass : #AmqpError,
	#instVars : [
		'serverProtocolHeader'
	],
	#category : #'Amqp-Protocol'
}

{ #category : #accessing }
AmqpProtocolMismatchError >> serverProtocolHeader [

	^ serverProtocolHeader
]

{ #category : #accessing }
AmqpProtocolMismatchError >> serverProtocolHeader: anObject [

	serverProtocolHeader := anObject
]
