Class {
	#name : #Amqp08ConnectionRedirect,
	#superclass : #AmqpProtocolMethod,
	#instVars : [
		'host',
		'knownHosts'
	],
	#category : #'Ansible-Protocol-08'
}

{ #category : #'AMQP codec' }
Amqp08ConnectionRedirect >> acceptableResponseClasses [

	^ {}
]

{ #category : #'AMQP codec' }
Amqp08ConnectionRedirect >> codecMethodId [

	^ 655410
]

{ #category : #'AMQP codec' }
Amqp08ConnectionRedirect >> decodeFrom: codec [

	| bitBuffer |

	host := codec nextShortstr.
	knownHosts := codec nextShortstr
]

{ #category : #'AMQP codec' }
Amqp08ConnectionRedirect >> encodeOn: codec [

	| bitBuffer |

	codec nextShortstrPut: host.
	codec nextShortstrPut: knownHosts
]

{ #category : #'AMQP codec' }
Amqp08ConnectionRedirect >> hasContents [

	^ false
]

{ #category : #accessing }
Amqp08ConnectionRedirect >> host [

	^ host
]

{ #category : #accessing }
Amqp08ConnectionRedirect >> host: aValue [

	host := aValue
]

{ #category : #accessing }
Amqp08ConnectionRedirect >> knownHosts [

	^ knownHosts
]

{ #category : #accessing }
Amqp08ConnectionRedirect >> knownHosts: aValue [

	knownHosts := aValue
]
