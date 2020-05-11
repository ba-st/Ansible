Class {
	#name : #Amqp08BasicGetEmpty,
	#superclass : #AmqpProtocolMethod,
	#instVars : [
		'clusterId'
	],
	#category : #'Ansible-Protocol-08'
}

{ #category : #'AMQP codec' }
Amqp08BasicGetEmpty >> acceptableResponseClasses [

	^ {}
]

{ #category : #accessing }
Amqp08BasicGetEmpty >> clusterId [

	^ clusterId
]

{ #category : #accessing }
Amqp08BasicGetEmpty >> clusterId: aValue [

	clusterId := aValue
]

{ #category : #'AMQP codec' }
Amqp08BasicGetEmpty >> codecMethodId [

	^ 3932232
]

{ #category : #'AMQP codec' }
Amqp08BasicGetEmpty >> decodeFrom: codec [

	| bitBuffer |

	clusterId := codec nextShortstr
]

{ #category : #'AMQP codec' }
Amqp08BasicGetEmpty >> encodeOn: codec [

	| bitBuffer |

	codec nextShortstrPut: clusterId
]

{ #category : #'AMQP codec' }
Amqp08BasicGetEmpty >> hasContents [

	^ false
]
