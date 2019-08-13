Class {
	#name : #Amqp091ChannelOpenOk,
	#superclass : #AmqpProtocolMethod,
	#category : #'Amqp-Protocol-091'
}

{ #category : #'AMQP codec' }
Amqp091ChannelOpenOk >> acceptableResponseClasses [

	^ {}
]

{ #category : #'AMQP codec' }
Amqp091ChannelOpenOk >> codecMethodId [

	^ 1310731
]

{ #category : #'AMQP codec' }
Amqp091ChannelOpenOk >> decodeFrom: codec [

	| bitBuffer |

	codec nextLongstr
]

{ #category : #'AMQP codec' }
Amqp091ChannelOpenOk >> encodeOn: codec [

	| bitBuffer |

	codec nextLongstrPut: nil
]

{ #category : #'AMQP codec' }
Amqp091ChannelOpenOk >> hasContents [

	^ false
]
