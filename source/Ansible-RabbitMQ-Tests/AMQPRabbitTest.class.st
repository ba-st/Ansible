Class {
	#name : 'AMQPRabbitTest',
	#superclass : 'TestCase',
	#category : 'Ansible-RabbitMQ-Tests',
	#package : 'Ansible-RabbitMQ-Tests'
}

{ #category : 'private' }
AMQPRabbitTest >> publish: aMessageCollection onQueueNamed: aQueueName [

  | publisher confirmationWasReceived queue |
  publisher := ( RabbitMQPublisher configuredBy: [  ] )
                 confirmMessagesPublicationWith: [ :command | confirmationWasReceived := true ]
                 andThoseNotProcessedWith: [ :command | self fail ];
                 yourself.

  confirmationWasReceived := false.

  publisher ensureChannelOpen.

  queue := publisher channel queueDeclare: aQueueName.
  publisher publish: aMessageCollection onQueueNamed: aQueueName.

  ( Delay forMilliseconds: 100 ) wait.
  queue := publisher channel queueDeclare: aQueueName.

  self
    assert: queue method messageCount equals: aMessageCollection size;
    assert: queue method consumerCount equals: 0;
    assert: confirmationWasReceived
]

{ #category : 'tests' }
AMQPRabbitTest >> testBasicConsumeUsingPublisherConfirmation [

  | channel queue worker queueName |
  queueName := 'tasks'.

  self publish: #( 'Do it!' ) onQueueNamed: queueName.

  worker := RabbitMQWorker
              configuredBy: [ :options |
                  options
                    at: #queueName put: queueName;
                    at: #queueDurable put: false
                ]
              processingMessagesWith: [ :messageReceived |
                  self
                    assert: messageReceived body asString equals: 'Do it!';
                    assert: messageReceived method exchange equals: '';
                    assert: messageReceived method routingKey equals: queueName;
                    deny: messageReceived method redelivered
                ].

  worker startConsumingFromQueue.
  [
    channel := worker channel.

    queue := channel queueDeclare: queueName.

    self
      assert: queue method messageCount equals: 0;
      assert: queue method consumerCount equals: 1
  ] ensure: [ worker stop ]
]
