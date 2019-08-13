Class {
	#name : #Amqp08TxSelect,
	#superclass : #AmqpProtocolMethod,
	#category : #'Amqp-Protocol-08'
}

{ #category : #'AMQP codec' }
Amqp08TxSelect >> acceptableResponseClasses [

	^ {Amqp08TxSelectOk}
]

{ #category : #'AMQP codec' }
Amqp08TxSelect >> codecMethodId [

	^ 5898250
]

{ #category : #'AMQP codec' }
Amqp08TxSelect >> decodeFrom: codec [

	| bitBuffer |

	
]

{ #category : #'AMQP codec' }
Amqp08TxSelect >> encodeOn: codec [

	| bitBuffer |

	
]

{ #category : #'AMQP codec' }
Amqp08TxSelect >> hasContents [

	^ false
]
