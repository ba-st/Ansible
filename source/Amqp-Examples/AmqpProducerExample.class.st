Class {
	#name : #AmqpProducerExample,
	#superclass : #AmqpSimpleExampleBase,
	#category : #'Amqp-Examples'
}

{ #category : #'as yet unclassified' }
AmqpProducerExample >> initialize [

	super initialize.
	channel exchangeDeclare: self exampleExchange type: 'fanout'
]

{ #category : #'as yet unclassified' }
AmqpProducerExample >> mainloop [

	[ channel
		basicPublish: DateAndTime now asString utf8Encoded
		exchange: self exampleExchange
		routingKey: ''.
	( Delay forMilliseconds: 1000 ) wait
	] repeat
]
