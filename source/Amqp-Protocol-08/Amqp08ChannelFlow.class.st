Class {
	#name : #Amqp08ChannelFlow,
	#superclass : #AmqpProtocolMethod,
	#instVars : [
		'active'
	],
	#category : #'Amqp-Protocol-08'
}

{ #category : #'AMQP codec' }
Amqp08ChannelFlow >> acceptableResponseClasses [

	^ {Amqp08ChannelFlowOk}
]

{ #category : #accessing }
Amqp08ChannelFlow >> active [

	^ active
]

{ #category : #accessing }
Amqp08ChannelFlow >> active: aValue [

	active := aValue
]

{ #category : #'AMQP codec' }
Amqp08ChannelFlow >> codecMethodId [

	^ 1310740
]

{ #category : #'AMQP codec' }
Amqp08ChannelFlow >> decodeFrom: codec [

	| bitBuffer |

	bitBuffer := codec nextOctet.
	active := ( bitBuffer bitAnd: 1 ) ~= 0
]

{ #category : #'AMQP codec' }
Amqp08ChannelFlow >> encodeOn: codec [

	| bitBuffer |

	bitBuffer := 0.
	( active ifNil: [ false ] )
		ifTrue: [ bitBuffer := bitBuffer bitOr: 1 ].
	codec nextOctetPut: bitBuffer
]

{ #category : #'AMQP codec' }
Amqp08ChannelFlow >> hasContents [

	^ false
]
