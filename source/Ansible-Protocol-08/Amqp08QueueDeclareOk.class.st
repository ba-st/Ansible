Class {
	#name : #Amqp08QueueDeclareOk,
	#superclass : #AmqpProtocolMethod,
	#instVars : [
		'queue',
		'messageCount',
		'consumerCount'
	],
	#category : #'Ansible-Protocol-08'
}

{ #category : #'AMQP codec' }
Amqp08QueueDeclareOk >> acceptableResponseClasses [

	^ {}
]

{ #category : #'AMQP codec' }
Amqp08QueueDeclareOk >> codecMethodId [

	^ 3276811
]

{ #category : #accessing }
Amqp08QueueDeclareOk >> consumerCount [

	^ consumerCount
]

{ #category : #accessing }
Amqp08QueueDeclareOk >> consumerCount: aValue [

	consumerCount := aValue
]

{ #category : #'AMQP codec' }
Amqp08QueueDeclareOk >> decodeFrom: codec [

	| bitBuffer |

	queue := codec nextShortstr.
	messageCount := codec nextLong.
	consumerCount := codec nextLong
]

{ #category : #'AMQP codec' }
Amqp08QueueDeclareOk >> encodeOn: codec [

	| bitBuffer |

	codec nextShortstrPut: queue.
	codec nextLongPut: messageCount.
	codec nextLongPut: consumerCount
]

{ #category : #'AMQP codec' }
Amqp08QueueDeclareOk >> hasContents [

	^ false
]

{ #category : #accessing }
Amqp08QueueDeclareOk >> messageCount [

	^ messageCount
]

{ #category : #accessing }
Amqp08QueueDeclareOk >> messageCount: aValue [

	messageCount := aValue
]

{ #category : #accessing }
Amqp08QueueDeclareOk >> queue [

	^ queue
]

{ #category : #accessing }
Amqp08QueueDeclareOk >> queue: aValue [

	queue := aValue
]
