Class {
	#name : 'RabbitMQTextReverser',
	#superclass : 'Object',
	#instVars : [
		'testCase',
		'worker'
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

	^ worker channel
]

{ #category : 'initialization' }
RabbitMQTextReverser >> initializeWorkingWith: aTestCase [

  worker := RabbitMQWorker
              configuredBy: [ :options |
                  options
                    at: #hostname put: 'localhost';
                    at: #queueName put: aTestCase queueName
                ]
              processingMessagesWith: [ :payload | aTestCase storeText: payload utf8Decoded reversed ]
]

{ #category : 'accessing' }
RabbitMQTextReverser >> start [

  ^ worker start
]

{ #category : 'accessing' }
RabbitMQTextReverser >> stop [

  ^ worker stop
]
