Class {
	#name : #AmqpSimpleExampleBase,
	#superclass : #Object,
	#instVars : [
		'conn',
		'proc',
		'channel'
	],
	#category : #'Amqp-Examples'
}

{ #category : #'as yet unclassified' }
AmqpSimpleExampleBase >> close [

	conn close
]

{ #category : #'as yet unclassified' }
AmqpSimpleExampleBase >> exampleExchange [

	^ 'smalltalk-test'
]

{ #category : #'as yet unclassified' }
AmqpSimpleExampleBase >> exampleHost [

	^ 'localhost'
]

{ #category : #'as yet unclassified' }
AmqpSimpleExampleBase >> initialize [

	super initialize.

	conn := AmqpConnectionBuilder new
		hostname: self exampleHost;
		username: 'guest';
		password: 'guest';
		build.
	conn protocolClass: Amqp091.
	conn open.

	channel := conn createChannel
]

{ #category : #'as yet unclassified' }
AmqpSimpleExampleBase >> start [

	proc ifNotNil: [ self stop ].
	proc := [ self mainloop ] fork
]

{ #category : #'as yet unclassified' }
AmqpSimpleExampleBase >> stop [

	proc
		ifNotNil: [ proc terminate.
			proc := nil
			]
]
