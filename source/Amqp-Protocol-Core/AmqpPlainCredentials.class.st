Class {
	#name : #AmqpPlainCredentials,
	#superclass : #Object,
	#instVars : [
		'username',
		'password'
	],
	#category : #'Amqp-Protocol-Core-Amqp-Protocol-Core'
}

{ #category : #accessing }
AmqpPlainCredentials >> password [

	^ password
]

{ #category : #accessing }
AmqpPlainCredentials >> password: anObject [

	password := anObject
]

{ #category : #accessing }
AmqpPlainCredentials >> responseFor: aMethod [

	| s |

	( aMethod mechanisms substrings includes: 'PLAIN' )
		ifFalse: [ ^ nil ].
	s := WriteStream with: ByteArray new.
	s
		nextPut: 0;
		nextPutAll: username asByteArray.
	s
		nextPut: 0;
		nextPutAll: password asByteArray.
	^ 'PLAIN' -> s contents
]

{ #category : #accessing }
AmqpPlainCredentials >> username [

	^ username
]

{ #category : #accessing }
AmqpPlainCredentials >> username: anObject [

	username := anObject
]
