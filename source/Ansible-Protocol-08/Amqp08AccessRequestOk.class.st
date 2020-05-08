Class {
	#name : #Amqp08AccessRequestOk,
	#superclass : #AmqpProtocolMethod,
	#instVars : [
		'ticket'
	],
	#category : #'Ansible-Protocol-08'
}

{ #category : #'AMQP codec' }
Amqp08AccessRequestOk >> acceptableResponseClasses [

	^ {}
]

{ #category : #'AMQP codec' }
Amqp08AccessRequestOk >> codecMethodId [

	^ 1966091
]

{ #category : #'AMQP codec' }
Amqp08AccessRequestOk >> decodeFrom: codec [

	| bitBuffer |

	ticket := codec nextShort
]

{ #category : #'AMQP codec' }
Amqp08AccessRequestOk >> encodeOn: codec [

	| bitBuffer |

	codec nextShortPut: ticket
]

{ #category : #'AMQP codec' }
Amqp08AccessRequestOk >> hasContents [

	^ false
]

{ #category : #accessing }
Amqp08AccessRequestOk >> ticket [

	^ ticket
]

{ #category : #accessing }
Amqp08AccessRequestOk >> ticket: aValue [

	ticket := aValue
]
