Class {
	#name : #Amqp091ConnectionOpen,
	#superclass : #AmqpProtocolMethod,
	#instVars : [
		'virtualHost'
	],
	#category : #'Ansible-Protocol-091'
}

{ #category : #'AMQP codec' }
Amqp091ConnectionOpen >> acceptableResponseClasses [

	^ Array with: Amqp091ConnectionOpenOk
]

{ #category : #'AMQP codec' }
Amqp091ConnectionOpen >> codecMethodId [

	^ 655400
]

{ #category : #'AMQP codec' }
Amqp091ConnectionOpen >> decodeFrom: codec [

	| bitBuffer |

	virtualHost := codec nextShortstr.
	codec nextShortstr.
	bitBuffer := codec nextOctet
]

{ #category : #'AMQP codec' }
Amqp091ConnectionOpen >> encodeOn: codec [

	| bitBuffer |

	codec nextShortstrPut: virtualHost.
	codec nextShortstrPut: nil.
	bitBuffer := 0.
	codec nextOctetPut: bitBuffer
]

{ #category : #'AMQP codec' }
Amqp091ConnectionOpen >> hasContents [

	^ false
]

{ #category : #accessing }
Amqp091ConnectionOpen >> virtualHost [

	^ virtualHost
]

{ #category : #accessing }
Amqp091ConnectionOpen >> virtualHost: aValue [

	virtualHost := aValue
]
