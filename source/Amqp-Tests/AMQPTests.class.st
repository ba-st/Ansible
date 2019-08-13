Class {
	#name : #AMQPTests,
	#superclass : #TestCase,
	#category : #'Amqp-Tests'
}

{ #category : #tests }
AMQPTests >> testHelloWorld [

	| messageReceived connection channel queue |

	connection := AmqpConnectionBuilder new
		hostname: 'localhost';
		build.
	connection open.

	channel := connection createChannel.
	queue := channel queueDeclare: 'hello'.

	channel basicPublish: 'Hello world!' utf8Encoded exchange: '' routingKey: queue method queue.

	messageReceived := channel basicGet: queue method queue.

	self
		assert: messageReceived body asString equals: 'Hello world!';
		assert: messageReceived method exchange equals: '';
		assert: messageReceived method routingKey equals: 'hello';
		deny: messageReceived method redelivered;
		assert: messageReceived method messageCount equals: 0.

	channel queueDelete: queue method queue.
	connection close
]

{ #category : #tests }
AMQPTests >> testHelloWorldWithExplicitAcknowledge [

	| messageReceived connection channel queue |

	connection := AmqpConnectionBuilder new
		hostname: 'localhost';
		build.
	connection open.

	channel := connection createChannel.
	queue := channel queueDeclare: 'hello'.

	channel basicPublish: 'Hello world!' utf8Encoded exchange: '' routingKey: queue method queue.

	messageReceived := channel basicGet: queue method queue.

	self
		assert: messageReceived body asString equals: 'Hello world!';
		assert: messageReceived method exchange equals: '';
		assert: messageReceived method routingKey equals: 'hello';
		deny: messageReceived method redelivered;
		assert: messageReceived method messageCount equals: 0.

	channel basicAck: messageReceived method deliveryTag.
	
	messageReceived := channel basicGet: queue method queue.
	self assert: messageReceived body isNil.
	 
	channel queueDelete: queue method queue.	
	connection close
]

{ #category : #tests }
AMQPTests >> testHelloWorldWithImplicitAcknowledge [

	| messagesReceived connection channel queue |

	connection := AmqpConnectionBuilder new
		hostname: 'localhost';
		build.
	connection open.

	channel := connection createChannel.
	queue := channel queueDeclare: 'hello'.

	channel basicPublish: 'Hello world!' utf8Encoded exchange: '' routingKey: queue method queue.

	messagesReceived := channel basicGet: queue method queue noAck: true.

	self
		assert: messagesReceived body asString equals: 'Hello world!';
		assert: messagesReceived method exchange equals: '';
		assert: messagesReceived method routingKey equals: 'hello';
		deny: messagesReceived method redelivered;
		assert: messagesReceived method messageCount equals: 0.
		
	self assert: (channel basicGet: queue method queue) body isNil.
	channel queueDelete: queue method queue.
	connection close
]
