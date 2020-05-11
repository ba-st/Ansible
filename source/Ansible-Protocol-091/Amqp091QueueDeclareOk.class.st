Class {
	#name : #Amqp091QueueDeclareOk,
	#superclass : #AmqpProtocolMethod,
	#instVars : [
		'queue',
		'messageCount',
		'consumerCount'
	],
	#category : #'Ansible-Protocol-091'
}

{ #category : #'AMQP codec' }
Amqp091QueueDeclareOk >> acceptableResponseClasses [

	^ {}
]

{ #category : #'AMQP codec' }
Amqp091QueueDeclareOk >> codecMethodId [

	^ 3276811
]

{ #category : #accessing }
Amqp091QueueDeclareOk >> consumerCount [

	^ consumerCount
]

{ #category : #accessing }
Amqp091QueueDeclareOk >> consumerCount: aValue [

	consumerCount := aValue
]

{ #category : #'AMQP codec' }
Amqp091QueueDeclareOk >> decodeFrom: codec [

	| bitBuffer |

	queue := codec nextShortstr.
	messageCount := codec nextLong.
	consumerCount := codec nextLong
]

{ #category : #'AMQP codec' }
Amqp091QueueDeclareOk >> encodeOn: codec [

	| bitBuffer |

	codec nextShortstrPut: queue.
	codec nextLongPut: messageCount.
	codec nextLongPut: consumerCount
]

{ #category : #'AMQP codec' }
Amqp091QueueDeclareOk >> hasContents [

	^ false
]

{ #category : #accessing }
Amqp091QueueDeclareOk >> messageCount [

	^ messageCount
]

{ #category : #accessing }
Amqp091QueueDeclareOk >> messageCount: aValue [

	messageCount := aValue
]

{ #category : #accessing }
Amqp091QueueDeclareOk >> queue [

	^ queue
]

{ #category : #accessing }
Amqp091QueueDeclareOk >> queue: aValue [

	queue := aValue
]
