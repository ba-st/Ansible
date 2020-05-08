Class {
	#name : #Amqp08DtxStartOk,
	#superclass : #AmqpProtocolMethod,
	#category : #'Ansible-Protocol-08'
}

{ #category : #'AMQP codec' }
Amqp08DtxStartOk >> acceptableResponseClasses [

	^ {}
]

{ #category : #'AMQP codec' }
Amqp08DtxStartOk >> codecMethodId [

	^ 6553621
]

{ #category : #'AMQP codec' }
Amqp08DtxStartOk >> decodeFrom: codec [

	| bitBuffer |

	
]

{ #category : #'AMQP codec' }
Amqp08DtxStartOk >> encodeOn: codec [

	| bitBuffer |

	
]

{ #category : #'AMQP codec' }
Amqp08DtxStartOk >> hasContents [

	^ false
]
