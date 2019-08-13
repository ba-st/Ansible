Class {
	#name : #Amqp08ChannelFlowOk,
	#superclass : #AmqpProtocolMethod,
	#instVars : [
		'active'
	],
	#category : #'Amqp-Protocol-08'
}

{ #category : #'AMQP codec' }
Amqp08ChannelFlowOk >> acceptableResponseClasses [

	^ {}
]

{ #category : #accessing }
Amqp08ChannelFlowOk >> active [

	^ active
]

{ #category : #accessing }
Amqp08ChannelFlowOk >> active: aValue [

	active := aValue
]

{ #category : #'AMQP codec' }
Amqp08ChannelFlowOk >> codecMethodId [

	^ 1310741
]

{ #category : #'AMQP codec' }
Amqp08ChannelFlowOk >> decodeFrom: codec [

	| bitBuffer |

	bitBuffer := codec nextOctet.
	active := ( bitBuffer bitAnd: 1 ) ~= 0
]

{ #category : #'AMQP codec' }
Amqp08ChannelFlowOk >> encodeOn: codec [

	| bitBuffer |

	bitBuffer := 0.
	( active ifNil: [ false ] )
		ifTrue: [ bitBuffer := bitBuffer bitOr: 1 ].
	codec nextOctetPut: bitBuffer
]

{ #category : #'AMQP codec' }
Amqp08ChannelFlowOk >> hasContents [

	^ false
]
