# Routing 

On this tutorial you'll refine the logging example you did on [PublishSubscribe.md] by sending selectively some of the log messages to an specific error logger. Not all receivers will receive all the messages.

## Consumer

On this channel you´re going to create an exchange, a queue, and a binding between the two.

````Smalltalk
channel declareExchangeNamed: 'tasks' of: 'direct' applying: [:exchange | ].
result := channel declareQueueApplying: [ :queue | ].
channel queueBind: result method queue exchange: 'tasks' routingKey: ''.
````

Binding the exchange can be interpreted as a known address where the producer will send messages, to the queue from where the consumer will take out the messages. Now with the following collaboration, you'll create a subscription to the queue registering a callback that will open an inspector on each received message by the consumer.

One important thing to notice is that the declared exchange is of type `direct`. This configures the exchange to send messages to the queues whose binding key exactly matches the routing key of the message.

````Smalltalk
channel 
	consumeFrom: result method queue
	applying: [ :messageReceived | messageReceived inspect ].	
````


You just bind the exchange, think of it as a known address where the producer will send messages, to the queue from where the consumer will take out the messages. Now with the following collaboration, you'll create a subscription to the queue registering a callback that will open an inspector on each received message by the consumer.

One important thing to notice is that the declare exchange is of type `direct`. This configures the exchange to send messages to the queues whose binding key exactly matches the routing key of the message.

````Smalltalk
channel 
	consumeFrom: result method queue
	applying: [ :messageReceived | messageReceived inspect ].	
````

*Note:* The [official documentation](https://www.rabbitmq.com/documentation.html) is very good and covers each of these topics in great detail. We recommend that you read it if you want to have a better understanding. 
