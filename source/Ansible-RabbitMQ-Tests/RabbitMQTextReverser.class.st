Class {
	#name : 'RabbitMQTextReverser',
	#superclass : 'RabbitMQWorker',
	#instVars : [
		'testCase'
	],
	#category : 'Ansible-RabbitMQ-Tests',
	#package : 'Ansible-RabbitMQ-Tests'
}

{ #category : 'instance creation' }
RabbitMQTextReverser class >> workingWith: aTestCase [

	^self new initializeWorkingWith: aTestCase
]

{ #category : 'private' }
RabbitMQTextReverser >> configureConnection: builder [

	
]

{ #category : 'initialization' }
RabbitMQTextReverser >> initializeWorkingWith: aTestCase [

	testCase := aTestCase.
	self initializeConnection
]

{ #category : 'private' }
RabbitMQTextReverser >> process: payload [

	testCase storeText: payload utf8Decoded reversed
]

{ #category : 'accessing' }
RabbitMQTextReverser >> queueName [

	^ testCase queueName
]
