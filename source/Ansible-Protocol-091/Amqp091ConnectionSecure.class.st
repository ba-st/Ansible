Class {
	#name : #Amqp091ConnectionSecure,
	#superclass : #AmqpProtocolMethod,
	#instVars : [
		'challenge'
	],
	#category : #'Ansible-Protocol-091'
}

{ #category : #'AMQP codec' }
Amqp091ConnectionSecure >> acceptableResponseClasses [

	^ {Amqp091ConnectionSecureOk}
]

{ #category : #accessing }
Amqp091ConnectionSecure >> challenge [

	^ challenge
]

{ #category : #accessing }
Amqp091ConnectionSecure >> challenge: aValue [

	challenge := aValue
]

{ #category : #'AMQP codec' }
Amqp091ConnectionSecure >> codecMethodId [

	^ 655380
]

{ #category : #'AMQP codec' }
Amqp091ConnectionSecure >> decodeFrom: codec [

	| bitBuffer |

	challenge := codec nextLongstr
]

{ #category : #'AMQP codec' }
Amqp091ConnectionSecure >> encodeOn: codec [

	| bitBuffer |

	codec nextLongstrPut: challenge
]

{ #category : #'AMQP codec' }
Amqp091ConnectionSecure >> hasContents [

	^ false
]
