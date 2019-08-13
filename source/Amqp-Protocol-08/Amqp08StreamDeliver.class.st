Class {
	#name : #Amqp08StreamDeliver,
	#superclass : #AmqpProtocolMethod,
	#instVars : [
		'consumerTag',
		'deliveryTag',
		'exchange',
		'queue'
	],
	#category : #'Amqp-Protocol-08'
}

{ #category : #'AMQP codec' }
Amqp08StreamDeliver >> acceptableResponseClasses [

	^ {}
]

{ #category : #'AMQP codec' }
Amqp08StreamDeliver >> codecMethodId [

	^ 5242940
]

{ #category : #accessing }
Amqp08StreamDeliver >> consumerTag [

	^ consumerTag
]

{ #category : #accessing }
Amqp08StreamDeliver >> consumerTag: aValue [

	consumerTag := aValue
]

{ #category : #'AMQP codec' }
Amqp08StreamDeliver >> decodeFrom: codec [

	| bitBuffer |

	consumerTag := codec nextShortstr.
	deliveryTag := codec nextLonglong.
	exchange := codec nextShortstr.
	queue := codec nextShortstr
]

{ #category : #accessing }
Amqp08StreamDeliver >> deliveryTag [

	^ deliveryTag
]

{ #category : #accessing }
Amqp08StreamDeliver >> deliveryTag: aValue [

	deliveryTag := aValue
]

{ #category : #'AMQP codec' }
Amqp08StreamDeliver >> encodeOn: codec [

	| bitBuffer |

	codec nextShortstrPut: consumerTag.
	codec nextLonglongPut: deliveryTag.
	codec nextShortstrPut: exchange.
	codec nextShortstrPut: queue
]

{ #category : #accessing }
Amqp08StreamDeliver >> exchange [

	^ exchange
]

{ #category : #accessing }
Amqp08StreamDeliver >> exchange: aValue [

	exchange := aValue
]

{ #category : #'AMQP codec' }
Amqp08StreamDeliver >> hasContents [

	^ true
]

{ #category : #accessing }
Amqp08StreamDeliver >> queue [

	^ queue
]

{ #category : #accessing }
Amqp08StreamDeliver >> queue: aValue [

	queue := aValue
]
