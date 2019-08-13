Class {
	#name : #Amqp08TestContent,
	#superclass : #AmqpProtocolMethod,
	#category : #'Amqp-Protocol-08'
}

{ #category : #'AMQP codec' }
Amqp08TestContent >> acceptableResponseClasses [

	^ {Amqp08TestContentOk}
]

{ #category : #'AMQP codec' }
Amqp08TestContent >> codecMethodId [

	^ 7864360
]

{ #category : #'AMQP codec' }
Amqp08TestContent >> decodeFrom: codec [

	| bitBuffer |

	
]

{ #category : #'AMQP codec' }
Amqp08TestContent >> encodeOn: codec [

	| bitBuffer |

	
]

{ #category : #'AMQP codec' }
Amqp08TestContent >> hasContents [

	^ true
]
