Class {
	#name : #Amqp091ChannelFlowOk,
	#superclass : #AmqpProtocolMethod,
	#instVars : [
		'active'
	],
	#category : #'Ansible-Protocol-091'
}

{ #category : #'AMQP codec' }
Amqp091ChannelFlowOk >> acceptableResponseClasses [

	^ #()
]

{ #category : #accessing }
Amqp091ChannelFlowOk >> active [

	^ active
]

{ #category : #accessing }
Amqp091ChannelFlowOk >> active: aValue [

	active := aValue
]

{ #category : #'AMQP codec' }
Amqp091ChannelFlowOk >> codecMethodId [

	^ 1310741
]

{ #category : #'AMQP codec' }
Amqp091ChannelFlowOk >> decodeFrom: codec [

	| bitBuffer |

	bitBuffer := codec nextOctet.
	active := ( bitBuffer bitAnd: 1 ) ~= 0
]

{ #category : #'AMQP codec' }
Amqp091ChannelFlowOk >> encodeOn: codec [

	| bitBuffer |

	bitBuffer := 0.
	( active ifNil: [ false ] )
		ifTrue: [ bitBuffer := bitBuffer bitOr: 1 ].
	codec nextOctetPut: bitBuffer
]

{ #category : #'AMQP codec' }
Amqp091ChannelFlowOk >> hasContents [

	^ false
]
