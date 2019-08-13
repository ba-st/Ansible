Class {
	#name : #Amqp08TunnelRequest,
	#superclass : #AmqpProtocolMethod,
	#instVars : [
		'metaData'
	],
	#category : #'Amqp-Protocol-08'
}

{ #category : #'AMQP codec' }
Amqp08TunnelRequest >> acceptableResponseClasses [

	^ {}
]

{ #category : #'AMQP codec' }
Amqp08TunnelRequest >> codecMethodId [

	^ 7208970
]

{ #category : #'AMQP codec' }
Amqp08TunnelRequest >> decodeFrom: codec [

	| bitBuffer |

	metaData := codec nextTable
]

{ #category : #'AMQP codec' }
Amqp08TunnelRequest >> encodeOn: codec [

	| bitBuffer |

	codec nextTablePut: metaData
]

{ #category : #'AMQP codec' }
Amqp08TunnelRequest >> hasContents [

	^ true
]

{ #category : #accessing }
Amqp08TunnelRequest >> metaData [

	^ metaData
]

{ #category : #accessing }
Amqp08TunnelRequest >> metaData: aValue [

	metaData := aValue
]
