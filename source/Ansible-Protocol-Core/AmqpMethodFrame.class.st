Class {
	#name : 'AmqpMethodFrame',
	#superclass : 'AmqpFrame',
	#instVars : [
		'methodId',
		'method'
	],
	#category : 'Ansible-Protocol-Core',
	#package : 'Ansible-Protocol-Core'
}

{ #category : 'accessing' }
AmqpMethodFrame >> encodeBodyOn: codec [

	codec nextLongPut: methodId.
	method encodeOn: codec
]

{ #category : 'accessing' }
AmqpMethodFrame >> method [

	^ method
]

{ #category : 'accessing' }
AmqpMethodFrame >> method: anObject [

	method := anObject
]

{ #category : 'accessing' }
AmqpMethodFrame >> methodId [

	^ methodId
]

{ #category : 'accessing' }
AmqpMethodFrame >> methodId: anObject [

	methodId := anObject
]

{ #category : 'accessing' }
AmqpMethodFrame >> readFrom: connection length: length [

	| codec |

	codec := connection codec.
	methodId := codec nextLong.
	method := ( connection protocolClass methodForId: methodId ) new.
	method decodeFrom: codec
]
