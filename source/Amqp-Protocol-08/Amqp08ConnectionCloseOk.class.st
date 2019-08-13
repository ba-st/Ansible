Class {
	#name : #Amqp08ConnectionCloseOk,
	#superclass : #AmqpProtocolMethod,
	#category : #'Amqp-Protocol-08'
}

{ #category : #'AMQP codec' }
Amqp08ConnectionCloseOk >> acceptableResponseClasses [

	^ {}
]

{ #category : #'AMQP codec' }
Amqp08ConnectionCloseOk >> codecMethodId [

	^ 655421
]

{ #category : #'AMQP codec' }
Amqp08ConnectionCloseOk >> decodeFrom: codec [

	| bitBuffer |

	
]

{ #category : #'AMQP codec' }
Amqp08ConnectionCloseOk >> encodeOn: codec [

	| bitBuffer |

	
]

{ #category : #'AMQP codec' }
Amqp08ConnectionCloseOk >> hasContents [

	^ false
]
