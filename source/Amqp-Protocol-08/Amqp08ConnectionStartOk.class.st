Class {
	#name : #Amqp08ConnectionStartOk,
	#superclass : #AmqpProtocolMethod,
	#instVars : [
		'clientProperties',
		'mechanism',
		'response',
		'locale'
	],
	#category : #'Amqp-Protocol-08'
}

{ #category : #'AMQP codec' }
Amqp08ConnectionStartOk >> acceptableResponseClasses [

	^ {}
]

{ #category : #accessing }
Amqp08ConnectionStartOk >> clientProperties [

	^ clientProperties
]

{ #category : #accessing }
Amqp08ConnectionStartOk >> clientProperties: aValue [

	clientProperties := aValue
]

{ #category : #'AMQP codec' }
Amqp08ConnectionStartOk >> codecMethodId [

	^ 655371
]

{ #category : #'AMQP codec' }
Amqp08ConnectionStartOk >> decodeFrom: codec [

	| bitBuffer |

	clientProperties := codec nextTable.
	mechanism := codec nextShortstr.
	response := codec nextLongstr.
	locale := codec nextShortstr
]

{ #category : #'AMQP codec' }
Amqp08ConnectionStartOk >> encodeOn: codec [

	| bitBuffer |

	codec nextTablePut: clientProperties.
	codec nextShortstrPut: mechanism.
	codec nextLongstrPut: response.
	codec nextShortstrPut: locale
]

{ #category : #'AMQP codec' }
Amqp08ConnectionStartOk >> hasContents [

	^ false
]

{ #category : #accessing }
Amqp08ConnectionStartOk >> locale [

	^ locale
]

{ #category : #accessing }
Amqp08ConnectionStartOk >> locale: aValue [

	locale := aValue
]

{ #category : #accessing }
Amqp08ConnectionStartOk >> mechanism [

	^ mechanism
]

{ #category : #accessing }
Amqp08ConnectionStartOk >> mechanism: aValue [

	mechanism := aValue
]

{ #category : #accessing }
Amqp08ConnectionStartOk >> response [

	^ response
]

{ #category : #accessing }
Amqp08ConnectionStartOk >> response: aValue [

	response := aValue
]
