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

{ #category : 'accessing' }
RabbitMQTextReverser >> channel [

	^ channel
]

{ #category : 'initialization' }
RabbitMQTextReverser >> initializeWorkingWith: aTestCase [

  testCase := aTestCase.
  self initializeConfiguredBy: ( Dictionary new
        at: #hostname put: 'localhost';
        yourself )
]

{ #category : 'private' }
RabbitMQTextReverser >> process: payload [

	testCase storeText: payload utf8Decoded reversed
]

{ #category : 'accessing' }
RabbitMQTextReverser >> queueName [

	^ testCase queueName
]
