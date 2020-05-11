Class {
	#name : #Amqp08ChannelOpen,
	#superclass : #AmqpProtocolMethod,
	#instVars : [
		'outOfBand'
	],
	#category : #'Ansible-Protocol-08'
}

{ #category : #'AMQP codec' }
Amqp08ChannelOpen >> acceptableResponseClasses [

	^ {Amqp08ChannelOpenOk}
]

{ #category : #'AMQP codec' }
Amqp08ChannelOpen >> codecMethodId [

	^ 1310730
]

{ #category : #'AMQP codec' }
Amqp08ChannelOpen >> decodeFrom: codec [

	| bitBuffer |

	outOfBand := codec nextShortstr
]

{ #category : #'AMQP codec' }
Amqp08ChannelOpen >> encodeOn: codec [

	| bitBuffer |

	codec nextShortstrPut: outOfBand
]

{ #category : #'AMQP codec' }
Amqp08ChannelOpen >> hasContents [

	^ false
]

{ #category : #accessing }
Amqp08ChannelOpen >> outOfBand [

	^ outOfBand
]

{ #category : #accessing }
Amqp08ChannelOpen >> outOfBand: aValue [

	outOfBand := aValue
]
