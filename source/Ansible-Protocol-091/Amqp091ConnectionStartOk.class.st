Class {
	#name : #Amqp091ConnectionStartOk,
	#superclass : #AmqpProtocolMethod,
	#instVars : [
		'clientProperties',
		'mechanism',
		'response',
		'locale'
	],
	#category : #'Ansible-Protocol-091'
}

{ #category : #'AMQP codec' }
Amqp091ConnectionStartOk >> acceptableResponseClasses [

	^ {}
]

{ #category : #accessing }
Amqp091ConnectionStartOk >> clientProperties [

	^ clientProperties
]

{ #category : #accessing }
Amqp091ConnectionStartOk >> clientProperties: aValue [

	clientProperties := aValue
]

{ #category : #'AMQP codec' }
Amqp091ConnectionStartOk >> codecMethodId [

	^ 655371
]

{ #category : #'AMQP codec' }
Amqp091ConnectionStartOk >> decodeFrom: codec [

	| bitBuffer |

	clientProperties := codec nextTable.
	mechanism := codec nextShortstr.
	response := codec nextLongstr.
	locale := codec nextShortstr
]

{ #category : #'AMQP codec' }
Amqp091ConnectionStartOk >> encodeOn: codec [

	| bitBuffer |

	codec nextTablePut: clientProperties.
	codec nextShortstrPut: mechanism.
	codec nextLongstrPut: response.
	codec nextShortstrPut: locale
]

{ #category : #'AMQP codec' }
Amqp091ConnectionStartOk >> hasContents [

	^ false
]

{ #category : #accessing }
Amqp091ConnectionStartOk >> locale [

	^ locale
]

{ #category : #accessing }
Amqp091ConnectionStartOk >> locale: aValue [

	locale := aValue
]

{ #category : #accessing }
Amqp091ConnectionStartOk >> mechanism [

	^ mechanism
]

{ #category : #accessing }
Amqp091ConnectionStartOk >> mechanism: aValue [

	mechanism := aValue
]

{ #category : #accessing }
Amqp091ConnectionStartOk >> response [

	^ response
]

{ #category : #accessing }
Amqp091ConnectionStartOk >> response: aValue [

	response := aValue
]
