Class {
	#name : #Amqp08ChannelCloseOk,
	#superclass : #AmqpProtocolMethod,
	#category : #'Amqp-Protocol-08'
}

{ #category : #'AMQP codec' }
Amqp08ChannelCloseOk >> acceptableResponseClasses [

	^ {}
]

{ #category : #'AMQP codec' }
Amqp08ChannelCloseOk >> codecMethodId [

	^ 1310761
]

{ #category : #'AMQP codec' }
Amqp08ChannelCloseOk >> decodeFrom: codec [

	| bitBuffer |

	
]

{ #category : #'AMQP codec' }
Amqp08ChannelCloseOk >> encodeOn: codec [

	| bitBuffer |

	
]

{ #category : #'AMQP codec' }
Amqp08ChannelCloseOk >> hasContents [

	^ false
]
