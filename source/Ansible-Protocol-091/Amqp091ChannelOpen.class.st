Class {
	#name : #Amqp091ChannelOpen,
	#superclass : #AmqpProtocolMethod,
	#category : #'Ansible-Protocol-091'
}

{ #category : #'AMQP codec' }
Amqp091ChannelOpen >> acceptableResponseClasses [

	^ {Amqp091ChannelOpenOk}
]

{ #category : #'AMQP codec' }
Amqp091ChannelOpen >> codecMethodId [

	^ 1310730
]

{ #category : #'AMQP codec' }
Amqp091ChannelOpen >> decodeFrom: codec [

	| bitBuffer |

	codec nextShortstr
]

{ #category : #'AMQP codec' }
Amqp091ChannelOpen >> encodeOn: codec [

	| bitBuffer |

	codec nextShortstrPut: nil
]

{ #category : #'AMQP codec' }
Amqp091ChannelOpen >> hasContents [

	^ false
]
