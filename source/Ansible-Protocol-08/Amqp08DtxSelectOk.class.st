Class {
	#name : #Amqp08DtxSelectOk,
	#superclass : #AmqpProtocolMethod,
	#category : #'Ansible-Protocol-08'
}

{ #category : #'AMQP codec' }
Amqp08DtxSelectOk >> acceptableResponseClasses [

	^ {}
]

{ #category : #'AMQP codec' }
Amqp08DtxSelectOk >> codecMethodId [

	^ 6553611
]

{ #category : #'AMQP codec' }
Amqp08DtxSelectOk >> decodeFrom: codec [

	| bitBuffer |

	
]

{ #category : #'AMQP codec' }
Amqp08DtxSelectOk >> encodeOn: codec [

	| bitBuffer |

	
]

{ #category : #'AMQP codec' }
Amqp08DtxSelectOk >> hasContents [

	^ false
]
