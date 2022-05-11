Class {
	#name : #AmqpChannelTest,
	#superclass : #TestCase,
	#instVars : [
		'connection'
	],
	#category : #'Ansible-Protocol-Tests'
}

{ #category : #running }
AmqpChannelTest >> setUp [

	super setUp.
	connection := AmqpConnectionBuilder usingAMQP091Protocol build.
	connection open
]

{ #category : #running }
AmqpChannelTest >> tearDown [

	connection ifNotNil: #close.
	super tearDown
]

{ #category : #tests }
AmqpChannelTest >> testDeclareQueue [

	| channel result |

	channel := connection createChannel.
	result := channel declareQueueApplying: [ :builder | builder beExclusive ].

	self
		assert: result body isNil;
		assert: result method messageCount equals: 0;
		assert: result method consumerCount equals: 0;
		assert: result properties isNil
]
