Class {
	#name : #Amqp08ConnectionStart,
	#superclass : #AmqpProtocolMethod,
	#instVars : [
		'versionMajor',
		'versionMinor',
		'serverProperties',
		'mechanisms',
		'locales'
	],
	#category : #'Amqp-Protocol-08'
}

{ #category : #'AMQP codec' }
Amqp08ConnectionStart >> acceptableResponseClasses [

	^ {Amqp08ConnectionStartOk}
]

{ #category : #'AMQP codec' }
Amqp08ConnectionStart >> codecMethodId [

	^ 655370
]

{ #category : #'AMQP codec' }
Amqp08ConnectionStart >> decodeFrom: codec [

	| bitBuffer |

	versionMajor := codec nextOctet.
	versionMinor := codec nextOctet.
	serverProperties := codec nextTable.
	mechanisms := codec nextLongstr.
	locales := codec nextLongstr
]

{ #category : #'AMQP codec' }
Amqp08ConnectionStart >> encodeOn: codec [

	| bitBuffer |

	codec nextOctetPut: versionMajor.
	codec nextOctetPut: versionMinor.
	codec nextTablePut: serverProperties.
	codec nextLongstrPut: mechanisms.
	codec nextLongstrPut: locales
]

{ #category : #'AMQP codec' }
Amqp08ConnectionStart >> hasContents [

	^ false
]

{ #category : #accessing }
Amqp08ConnectionStart >> locales [

	^ locales
]

{ #category : #accessing }
Amqp08ConnectionStart >> locales: aValue [

	locales := aValue
]

{ #category : #accessing }
Amqp08ConnectionStart >> mechanisms [

	^ mechanisms
]

{ #category : #accessing }
Amqp08ConnectionStart >> mechanisms: aValue [

	mechanisms := aValue
]

{ #category : #accessing }
Amqp08ConnectionStart >> serverProperties [

	^ serverProperties
]

{ #category : #accessing }
Amqp08ConnectionStart >> serverProperties: aValue [

	serverProperties := aValue
]

{ #category : #accessing }
Amqp08ConnectionStart >> versionMajor [

	^ versionMajor
]

{ #category : #accessing }
Amqp08ConnectionStart >> versionMajor: aValue [

	versionMajor := aValue
]

{ #category : #accessing }
Amqp08ConnectionStart >> versionMinor [

	^ versionMinor
]

{ #category : #accessing }
Amqp08ConnectionStart >> versionMinor: aValue [

	versionMinor := aValue
]
