Class {
	#name : #Amqp091ChannelCloseOk,
	#superclass : #AmqpProtocolMethod,
	#category : #'Ansible-Protocol-091'
}

{ #category : #'AMQP codec' }
Amqp091ChannelCloseOk >> acceptableResponseClasses [

	^ #()
]

{ #category : #'AMQP codec' }
Amqp091ChannelCloseOk >> codecMethodId [

	^ 1310761
]

{ #category : #'AMQP codec' }
Amqp091ChannelCloseOk >> decodeFrom: codec [

	
]

{ #category : #'AMQP codec' }
Amqp091ChannelCloseOk >> encodeOn: codec [

	
]

{ #category : #'AMQP codec' }
Amqp091ChannelCloseOk >> hasContents [

	^ false
]
