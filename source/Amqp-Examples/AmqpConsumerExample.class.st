Class {
	#name : #AmqpConsumerExample,
	#superclass : #AmqpSimpleExampleBase,
	#instVars : [
		'queueName',
		'consumerTag'
	],
	#category : #'Amqp-Examples'
}

{ #category : #'as yet unclassified' }
AmqpConsumerExample >> handleDelivery: delivery [

	| str |

	str := [ delivery body utf8Decoded ]
		on: ZnInvalidUTF8
		do: [ delivery body printString ].

	Transcript
		cr;
		nextPutAll: 'Received delivery: ';
		nextPutAll: str;
		flush.

	channel basicAck: delivery method deliveryTag
]

{ #category : #'as yet unclassified' }
AmqpConsumerExample >> initialize [

	super initialize.
	channel exchangeDeclare: self exampleExchange type: 'fanout'.
	queueName := ( channel
		queueDeclare: ''
		durable: false
		exclusive: true
		autoDelete: true
		passive: false
		arguments: nil ) method queue.
	channel queueBind: queueName exchange: self exampleExchange routingKey: ''.
	consumerTag := channel consumeFrom: queueName callback: self selector: #handleDelivery:
]

{ #category : #'as yet unclassified' }
AmqpConsumerExample >> mainloop [

	[ conn waitForEvent ] repeat
]
