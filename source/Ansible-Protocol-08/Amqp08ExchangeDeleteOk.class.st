Class {
	#name : #Amqp08ExchangeDeleteOk,
	#superclass : #AmqpProtocolMethod,
	#category : #'Ansible-Protocol-08'
}

{ #category : #'AMQP codec' }
Amqp08ExchangeDeleteOk >> acceptableResponseClasses [

	^ {}
]

{ #category : #'AMQP codec' }
Amqp08ExchangeDeleteOk >> codecMethodId [

	^ 2621461
]

{ #category : #'AMQP codec' }
Amqp08ExchangeDeleteOk >> decodeFrom: codec [

	| bitBuffer |

	
]

{ #category : #'AMQP codec' }
Amqp08ExchangeDeleteOk >> encodeOn: codec [

	| bitBuffer |

	
]

{ #category : #'AMQP codec' }
Amqp08ExchangeDeleteOk >> hasContents [

	^ false
]
