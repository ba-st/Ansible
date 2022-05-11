"
The [AMQP 0-9-1 specification](https://www.rabbitmq.com/specification.html) defines the basic.reject method that allows clients to reject individual, delivered messages, instructing the broker to either discard them or requeue them. Unfortunately, basic.reject provides no support for negatively acknowledging messages in bulk. To solve this, RabbitMQ supports the basic.nack method that provides all the functionality of basic.reject whilst also allowing for bulk processing of messages.
"
Class {
	#name : #Amqp091BasicNack,
	#superclass : #AmqpProtocolMethod,
	#instVars : [
		'multiple',
		'deliveryTag',
		'requeue'
	],
	#category : #'Ansible-RabbitMQ'
}

{ #category : #accessing }
Amqp091BasicNack >> acceptableResponseClasses [

	^ #()
]

{ #category : #accessing }
Amqp091BasicNack >> codecMethodId [

	^ 3932280
]

{ #category : #decoding }
Amqp091BasicNack >> decodeFrom: codec [

	| bitBuffer |

	deliveryTag := codec nextLonglong.
	bitBuffer := codec nextOctet.
	multiple := ( bitBuffer bitAnd: 1 ) ~= 0.
	requeue := ( bitBuffer bitAnd: 2 ) ~= 0
]

{ #category : #accessing }
Amqp091BasicNack >> deliveryTag [

	^ deliveryTag
]

{ #category : #accessing }
Amqp091BasicNack >> deliveryTag: aValue [

	deliveryTag := aValue
]

{ #category : #encoding }
Amqp091BasicNack >> encodeOn: codec [

	| bitBuffer |

	codec nextLonglongPut: deliveryTag.
	bitBuffer := 0.
	(multiple ifNil: [false]) ifTrue: [bitBuffer := bitBuffer bitOr: 1].
	(requeue ifNil: [true]) ifTrue: [bitBuffer := bitBuffer bitOr: 2].
	codec nextOctetPut: bitBuffer
]

{ #category : #testing }
Amqp091BasicNack >> hasContents [

	^ false
]

{ #category : #accessing }
Amqp091BasicNack >> multiple [

	^ multiple
]

{ #category : #accessing }
Amqp091BasicNack >> multiple: aValue [

	multiple := aValue
]

{ #category : #accessing }
Amqp091BasicNack >> requeue [

	^requeue
]

{ #category : #accessing }
Amqp091BasicNack >> requeue: aValue [

	requeue := aValue
]
