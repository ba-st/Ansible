Class {
	#name : #Amqp091TxCommit,
	#superclass : #AmqpProtocolMethod,
	#category : #'Ansible-Protocol-091'
}

{ #category : #'AMQP codec' }
Amqp091TxCommit >> acceptableResponseClasses [

	^ {Amqp091TxCommitOk}
]

{ #category : #'AMQP codec' }
Amqp091TxCommit >> codecMethodId [

	^ 5898260
]

{ #category : #'AMQP codec' }
Amqp091TxCommit >> decodeFrom: codec [

	| bitBuffer |

	
]

{ #category : #'AMQP codec' }
Amqp091TxCommit >> encodeOn: codec [

	| bitBuffer |

	
]

{ #category : #'AMQP codec' }
Amqp091TxCommit >> hasContents [

	^ false
]
