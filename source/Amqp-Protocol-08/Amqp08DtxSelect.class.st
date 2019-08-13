Class {
	#name : #Amqp08DtxSelect,
	#superclass : #AmqpProtocolMethod,
	#category : #'Amqp-Protocol-08'
}

{ #category : #'AMQP codec' }
Amqp08DtxSelect >> acceptableResponseClasses [

	^ {Amqp08DtxSelectOk}
]

{ #category : #'AMQP codec' }
Amqp08DtxSelect >> codecMethodId [

	^ 6553610
]

{ #category : #'AMQP codec' }
Amqp08DtxSelect >> decodeFrom: codec [

	| bitBuffer |

	
]

{ #category : #'AMQP codec' }
Amqp08DtxSelect >> encodeOn: codec [

	| bitBuffer |

	
]

{ #category : #'AMQP codec' }
Amqp08DtxSelect >> hasContents [

	^ false
]
