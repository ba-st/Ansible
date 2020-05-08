Class {
	#name : #Amqp08TestStringOk,
	#superclass : #AmqpProtocolMethod,
	#instVars : [
		'result'
	],
	#category : #'Ansible-Protocol-08'
}

{ #category : #'AMQP codec' }
Amqp08TestStringOk >> acceptableResponseClasses [

	^ {}
]

{ #category : #'AMQP codec' }
Amqp08TestStringOk >> codecMethodId [

	^ 7864341
]

{ #category : #'AMQP codec' }
Amqp08TestStringOk >> decodeFrom: codec [

	| bitBuffer |

	result := codec nextLongstr
]

{ #category : #'AMQP codec' }
Amqp08TestStringOk >> encodeOn: codec [

	| bitBuffer |

	codec nextLongstrPut: result
]

{ #category : #'AMQP codec' }
Amqp08TestStringOk >> hasContents [

	^ false
]

{ #category : #accessing }
Amqp08TestStringOk >> result [

	^ result
]

{ #category : #accessing }
Amqp08TestStringOk >> result: aValue [

	result := aValue
]
