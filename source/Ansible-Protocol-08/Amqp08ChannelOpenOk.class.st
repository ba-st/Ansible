Class {
	#name : #Amqp08ChannelOpenOk,
	#superclass : #AmqpProtocolMethod,
	#category : #'Ansible-Protocol-08'
}

{ #category : #'AMQP codec' }
Amqp08ChannelOpenOk >> acceptableResponseClasses [

	^ {}
]

{ #category : #'AMQP codec' }
Amqp08ChannelOpenOk >> codecMethodId [

	^ 1310731
]

{ #category : #'AMQP codec' }
Amqp08ChannelOpenOk >> decodeFrom: codec [

	| bitBuffer |

	
]

{ #category : #'AMQP codec' }
Amqp08ChannelOpenOk >> encodeOn: codec [

	| bitBuffer |

	
]

{ #category : #'AMQP codec' }
Amqp08ChannelOpenOk >> hasContents [

	^ false
]
