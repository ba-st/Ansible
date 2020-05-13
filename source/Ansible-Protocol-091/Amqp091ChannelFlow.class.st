Class {
	#name : #Amqp091ChannelFlow,
	#superclass : #AmqpProtocolMethod,
	#instVars : [
		'active'
	],
	#category : #'Ansible-Protocol-091'
}

{ #category : #'AMQP codec' }
Amqp091ChannelFlow >> acceptableResponseClasses [

	^ Array with: Amqp091ChannelFlowOk
]

{ #category : #accessing }
Amqp091ChannelFlow >> active [

	^ active
]

{ #category : #accessing }
Amqp091ChannelFlow >> active: aValue [

	active := aValue
]

{ #category : #'AMQP codec' }
Amqp091ChannelFlow >> codecMethodId [

	^ 1310740
]

{ #category : #'AMQP codec' }
Amqp091ChannelFlow >> decodeFrom: codec [

	| bitBuffer |

	bitBuffer := codec nextOctet.
	active := ( bitBuffer bitAnd: 1 ) ~= 0
]

{ #category : #'AMQP codec' }
Amqp091ChannelFlow >> encodeOn: codec [

	| bitBuffer |

	bitBuffer := 0.
	( active ifNil: [ false ] )
		ifTrue: [ bitBuffer := bitBuffer bitOr: 1 ].
	codec nextOctetPut: bitBuffer
]

{ #category : #'AMQP codec' }
Amqp091ChannelFlow >> hasContents [

	^ false
]
