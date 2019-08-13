Class {
	#name : #Amqp091ChannelCloseOk,
	#superclass : #AmqpProtocolMethod,
	#category : #'Amqp-Protocol-091'
}

{ #category : #'AMQP codec' }
Amqp091ChannelCloseOk >> acceptableResponseClasses [

	^ {}
]

{ #category : #'AMQP codec' }
Amqp091ChannelCloseOk >> codecMethodId [

	^ 1310761
]

{ #category : #'AMQP codec' }
Amqp091ChannelCloseOk >> decodeFrom: codec [

	| bitBuffer |

	
]

{ #category : #'AMQP codec' }
Amqp091ChannelCloseOk >> encodeOn: codec [

	| bitBuffer |

	
]

{ #category : #'AMQP codec' }
Amqp091ChannelCloseOk >> hasContents [

	^ false
]
