Class {
	#name : #Amqp091ConnectionSecureOk,
	#superclass : #AmqpProtocolMethod,
	#instVars : [
		'response'
	],
	#category : #'Ansible-Protocol-091'
}

{ #category : #'AMQP codec' }
Amqp091ConnectionSecureOk >> acceptableResponseClasses [

	^ #()
]

{ #category : #'AMQP codec' }
Amqp091ConnectionSecureOk >> codecMethodId [

	^ 655381
]

{ #category : #'AMQP codec' }
Amqp091ConnectionSecureOk >> decodeFrom: codec [

	response := codec nextLongstr
]

{ #category : #'AMQP codec' }
Amqp091ConnectionSecureOk >> encodeOn: codec [

	codec nextLongstrPut: response
]

{ #category : #'AMQP codec' }
Amqp091ConnectionSecureOk >> hasContents [

	^ false
]

{ #category : #accessing }
Amqp091ConnectionSecureOk >> response [

	^ response
]

{ #category : #accessing }
Amqp091ConnectionSecureOk >> response: aValue [

	response := aValue
]
