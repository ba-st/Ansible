Class {
	#name : #AmqpMethodFrame,
	#superclass : #AmqpFrame,
	#instVars : [
		'methodId',
		'method'
	],
	#category : #'Amqp-Protocol'
}

{ #category : #'as yet unclassified' }
AmqpMethodFrame >> encodeBodyOn: codec [

	codec nextLongPut: methodId.
	method encodeOn: codec
]

{ #category : #accessing }
AmqpMethodFrame >> method [

	^ method
]

{ #category : #accessing }
AmqpMethodFrame >> method: anObject [

	method := anObject
]

{ #category : #accessing }
AmqpMethodFrame >> methodId [

	^ methodId
]

{ #category : #accessing }
AmqpMethodFrame >> methodId: anObject [

	methodId := anObject
]

{ #category : #'as yet unclassified' }
AmqpMethodFrame >> readFrom: conn length: length [

	| codec |

	codec := conn codec.
	methodId := codec nextLong.
	method := ( conn protocolClass methodForId: methodId ) new.
	method decodeFrom: codec
]
