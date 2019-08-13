Class {
	#name : #Amqp08FileStage,
	#superclass : #AmqpProtocolMethod,
	#category : #'Amqp-Protocol-08'
}

{ #category : #'AMQP codec' }
Amqp08FileStage >> acceptableResponseClasses [

	^ {}
]

{ #category : #'AMQP codec' }
Amqp08FileStage >> codecMethodId [

	^ 4587570
]

{ #category : #'AMQP codec' }
Amqp08FileStage >> decodeFrom: codec [

	| bitBuffer |

	
]

{ #category : #'AMQP codec' }
Amqp08FileStage >> encodeOn: codec [

	| bitBuffer |

	
]

{ #category : #'AMQP codec' }
Amqp08FileStage >> hasContents [

	^ true
]
