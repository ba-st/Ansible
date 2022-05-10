"
An Amqp091Test is a test class for testing the behavior of Amqp091
"
Class {
	#name : #Amqp091Test,
	#superclass : #TestCase,
	#category : #'Ansible-Protocol-091-Tests'
}

{ #category : #tests }
Amqp091Test >> testBasicNackMethod [

	self assert: Amqp091 basicNackMethod equals: Amqp091BasicNack
]

{ #category : #tests }
Amqp091Test >> testBasicReturnMethod [

	self assert: Amqp091 basicReturnMethod equals: Amqp091BasicReturn
]

{ #category : #tests }
Amqp091Test >> testChannelFlowMethod [

	self assert: Amqp091 channelFlowMethod equals: Amqp091ChannelFlow
]

{ #category : #tests }
Amqp091Test >> testConfirmSelectMethod [

	self assert: Amqp091 confirmSelectMethod equals: Amqp091ConfirmSelect
]
