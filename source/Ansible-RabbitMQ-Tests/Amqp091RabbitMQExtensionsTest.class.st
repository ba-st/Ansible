Class {
	#name : 'Amqp091RabbitMQExtensionsTest',
	#superclass : 'TestCase',
	#category : 'Ansible-RabbitMQ-Tests',
	#package : 'Ansible-RabbitMQ-Tests'
}

{ #category : 'tests' }
Amqp091RabbitMQExtensionsTest >> testBasicNackMethod [

	self assert: Amqp091 basicNackMethod equals: Amqp091BasicNack
]

{ #category : 'tests' }
Amqp091RabbitMQExtensionsTest >> testConfirmSelectMethod [

	self assert: Amqp091 confirmSelectMethod equals: Amqp091ConfirmSelect
]
