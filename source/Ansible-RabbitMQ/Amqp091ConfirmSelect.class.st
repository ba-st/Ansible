"
Using standard AMQP 0-9-1, the only way to guarantee that a message isn't lost is by using transactions -- make the channel transactional then for each message or set of messages publish, commit. In this case, transactions are unnecessarily heavyweight and decrease throughput by a factor of 250. To remedy this, a confirmation mechanism was introduced. It mimics the consumer acknowledgements mechanism already present in the protocol.

See [Publisher confirms](https://www.rabbitmq.com/confirms.html#publisher-confirms)
"
Class {
	#name : 'Amqp091ConfirmSelect',
	#superclass : 'AmqpProtocolMethod',
	#instVars : [
		'noWait'
	],
	#category : 'Ansible-RabbitMQ',
	#package : 'Ansible-RabbitMQ'
}

{ #category : 'accessing' }
Amqp091ConfirmSelect >> acceptableResponseClasses [

	^ Array with: Amqp091ConfirmSelectOk
]

{ #category : 'accessing' }
Amqp091ConfirmSelect >> codecMethodId [

	^ 5570570
]

{ #category : 'decoding' }
Amqp091ConfirmSelect >> decodeFrom: codec [

	| bitBuffer |

	bitBuffer := codec nextOctet.
	noWait := (bitBuffer bitAnd: 1) ~= 0
]

{ #category : 'encoding' }
Amqp091ConfirmSelect >> encodeOn: codec [

	| bitBuffer |

	bitBuffer := 0.
	(noWait ifNil: [false]) ifTrue: [bitBuffer := bitBuffer bitOr: 1].
	codec nextOctetPut: bitBuffer
]

{ #category : 'testing' }
Amqp091ConfirmSelect >> hasContents [

	^false
]

{ #category : 'accessing' }
Amqp091ConfirmSelect >> noWait [

	^ noWait
]

{ #category : 'accessing' }
Amqp091ConfirmSelect >> noWait: aValue [

	noWait := aValue
]
