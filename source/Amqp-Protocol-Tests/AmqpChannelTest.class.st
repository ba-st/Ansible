Class {
	#name : #AmqpChannelTest,
	#superclass : #TestCase,
	#instVars : [
		'connection'
	],
	#category : #'Amqp-Protocol-Tests'
}

{ #category : #running }
AmqpChannelTest >> setUp [

	connection := AmqpConnectionBuilder new
		hostname: 'localhost';
		build.
	connection open
]

{ #category : #running }
AmqpChannelTest >> tearDown [

	connection close
]

{ #category : #tests }
AmqpChannelTest >> testDeclareQueue [

	| channel result |

	channel := connection createChannel.
	result := channel declareQueue: [ :builder | builder beExclusive ].

	self
		assert: result body isNil;
		assert: result method messageCount equals: 0;
		assert: result method consumerCount equals: 0;
		assert: result properties isNil
]
