Class {
	#name : #Amqp091ChannelOpenOk,
	#superclass : #AmqpProtocolMethod,
	#category : #'Ansible-Protocol-091'
}

{ #category : #'AMQP codec' }
Amqp091ChannelOpenOk >> acceptableResponseClasses [

	^ #()
]

{ #category : #'AMQP codec' }
Amqp091ChannelOpenOk >> codecMethodId [

	^ 1310731
]

{ #category : #'AMQP codec' }
Amqp091ChannelOpenOk >> decodeFrom: codec [

	codec nextLongstr
]

{ #category : #'AMQP codec' }
Amqp091ChannelOpenOk >> encodeOn: codec [

	codec nextLongstrPut: nil
]

{ #category : #'AMQP codec' }
Amqp091ChannelOpenOk >> hasContents [

	^ false
]
