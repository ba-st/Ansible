Class {
	#name : #Amqp091ConnectionStart,
	#superclass : #AmqpProtocolMethod,
	#instVars : [
		'versionMajor',
		'versionMinor',
		'serverProperties',
		'mechanisms',
		'locales'
	],
	#category : #'Amqp-Protocol-091'
}

{ #category : #'AMQP codec' }
Amqp091ConnectionStart >> acceptableResponseClasses [

	^ {Amqp091ConnectionStartOk}
]

{ #category : #'AMQP codec' }
Amqp091ConnectionStart >> codecMethodId [

	^ 655370
]

{ #category : #'AMQP codec' }
Amqp091ConnectionStart >> decodeFrom: codec [

	versionMajor := codec nextOctet.
	versionMinor := codec nextOctet.
	serverProperties := codec nextTable.
	mechanisms := codec nextLongstr.
	locales := codec nextLongstr
]

{ #category : #'AMQP codec' }
Amqp091ConnectionStart >> encodeOn: codec [

	| bitBuffer |

	codec nextOctetPut: versionMajor.
	codec nextOctetPut: versionMinor.
	codec nextTablePut: serverProperties.
	codec nextLongstrPut: mechanisms.
	codec nextLongstrPut: locales
]

{ #category : #'AMQP codec' }
Amqp091ConnectionStart >> hasContents [

	^ false
]

{ #category : #accessing }
Amqp091ConnectionStart >> locales [

	^ locales
]

{ #category : #accessing }
Amqp091ConnectionStart >> locales: aValue [

	locales := aValue
]

{ #category : #accessing }
Amqp091ConnectionStart >> mechanisms [

	^ mechanisms
]

{ #category : #accessing }
Amqp091ConnectionStart >> mechanisms: aValue [

	mechanisms := aValue
]

{ #category : #accessing }
Amqp091ConnectionStart >> serverProperties [

	^ serverProperties
]

{ #category : #accessing }
Amqp091ConnectionStart >> serverProperties: aValue [

	serverProperties := aValue
]

{ #category : #accessing }
Amqp091ConnectionStart >> versionMajor [

	^ versionMajor
]

{ #category : #accessing }
Amqp091ConnectionStart >> versionMajor: aValue [

	versionMajor := aValue
]

{ #category : #accessing }
Amqp091ConnectionStart >> versionMinor [

	^ versionMinor
]

{ #category : #accessing }
Amqp091ConnectionStart >> versionMinor: aValue [

	versionMinor := aValue
]
