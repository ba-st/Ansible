Class {
	#name : #Amqp08ConnectionOpenOk,
	#superclass : #AmqpProtocolMethod,
	#instVars : [
		'knownHosts'
	],
	#category : #'Amqp-Protocol-08'
}

{ #category : #'AMQP codec' }
Amqp08ConnectionOpenOk >> acceptableResponseClasses [

	^ {}
]

{ #category : #'AMQP codec' }
Amqp08ConnectionOpenOk >> codecMethodId [

	^ 655401
]

{ #category : #'AMQP codec' }
Amqp08ConnectionOpenOk >> decodeFrom: codec [

	| bitBuffer |

	knownHosts := codec nextShortstr
]

{ #category : #'AMQP codec' }
Amqp08ConnectionOpenOk >> encodeOn: codec [

	| bitBuffer |

	codec nextShortstrPut: knownHosts
]

{ #category : #'AMQP codec' }
Amqp08ConnectionOpenOk >> hasContents [

	^ false
]

{ #category : #accessing }
Amqp08ConnectionOpenOk >> knownHosts [

	^ knownHosts
]

{ #category : #accessing }
Amqp08ConnectionOpenOk >> knownHosts: aValue [

	knownHosts := aValue
]
