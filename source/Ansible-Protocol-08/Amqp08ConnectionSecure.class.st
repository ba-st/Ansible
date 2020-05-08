Class {
	#name : #Amqp08ConnectionSecure,
	#superclass : #AmqpProtocolMethod,
	#instVars : [
		'challenge'
	],
	#category : #'Ansible-Protocol-08'
}

{ #category : #'AMQP codec' }
Amqp08ConnectionSecure >> acceptableResponseClasses [

	^ {Amqp08ConnectionSecureOk}
]

{ #category : #accessing }
Amqp08ConnectionSecure >> challenge [

	^ challenge
]

{ #category : #accessing }
Amqp08ConnectionSecure >> challenge: aValue [

	challenge := aValue
]

{ #category : #'AMQP codec' }
Amqp08ConnectionSecure >> codecMethodId [

	^ 655380
]

{ #category : #'AMQP codec' }
Amqp08ConnectionSecure >> decodeFrom: codec [

	| bitBuffer |

	challenge := codec nextLongstr
]

{ #category : #'AMQP codec' }
Amqp08ConnectionSecure >> encodeOn: codec [

	| bitBuffer |

	codec nextLongstrPut: challenge
]

{ #category : #'AMQP codec' }
Amqp08ConnectionSecure >> hasContents [

	^ false
]
