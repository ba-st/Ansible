Class {
	#name : #Amqp08ConnectionSecureOk,
	#superclass : #AmqpProtocolMethod,
	#instVars : [
		'response'
	],
	#category : #'Amqp-Protocol-08'
}

{ #category : #'AMQP codec' }
Amqp08ConnectionSecureOk >> acceptableResponseClasses [

	^ {}
]

{ #category : #'AMQP codec' }
Amqp08ConnectionSecureOk >> codecMethodId [

	^ 655381
]

{ #category : #'AMQP codec' }
Amqp08ConnectionSecureOk >> decodeFrom: codec [

	| bitBuffer |

	response := codec nextLongstr
]

{ #category : #'AMQP codec' }
Amqp08ConnectionSecureOk >> encodeOn: codec [

	| bitBuffer |

	codec nextLongstrPut: response
]

{ #category : #'AMQP codec' }
Amqp08ConnectionSecureOk >> hasContents [

	^ false
]

{ #category : #accessing }
Amqp08ConnectionSecureOk >> response [

	^ response
]

{ #category : #accessing }
Amqp08ConnectionSecureOk >> response: aValue [

	response := aValue
]
