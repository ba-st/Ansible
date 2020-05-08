Class {
	#name : #Amqp08QueueBindOk,
	#superclass : #AmqpProtocolMethod,
	#category : #'Ansible-Protocol-08'
}

{ #category : #'AMQP codec' }
Amqp08QueueBindOk >> acceptableResponseClasses [

	^ {}
]

{ #category : #'AMQP codec' }
Amqp08QueueBindOk >> codecMethodId [

	^ 3276821
]

{ #category : #'AMQP codec' }
Amqp08QueueBindOk >> decodeFrom: codec [

	| bitBuffer |

	
]

{ #category : #'AMQP codec' }
Amqp08QueueBindOk >> encodeOn: codec [

	| bitBuffer |

	
]

{ #category : #'AMQP codec' }
Amqp08QueueBindOk >> hasContents [

	^ false
]
