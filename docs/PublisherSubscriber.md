# Publish-Subscribe
(based on the [offical python tutorial](https://www.rabbitmq.com/tutorials/tutorial-three-python.html))

Let's create an example of an publish-subscribe communication pattern. We will use two images, the first one will emit log events acting as publisher and in the second one will spawn a couple of subscribers recibing the logs and print them on the transcript.


For more information on the pattern see [publish-subsribe](https://www.enterpriseintegrationpatterns.com/patterns/messaging/PublishSubscribeChannel.html) 

In our logging system every running copy of the receiver program will get the messages. That way we'll be able to run one receiver and direct the logs to disk; and at the same time we'll be able to run another receiver and see the logs on the screen.

Essentially, published log messages are going to be broadcast to all the receivers.


## Introducing the exchange 

The setting up of subscriber looks a lot like the worker in the previous example

Let's review AMQP concepts by inspecting a consumer setup step-by-step.

```Smalltalk
connection := AmqpConnectionBuilder new
	hostname: 'localhost';
	build.
connection open.

channel := connection createChannel.
```

On this channel you´re going to create an exchange, a queue, and a binding between the two.

````Smalltalk
channel declareExchangeNamed: 'logs' of: 'direct' applying: [:exchange | ].
result := channel declareQueueApplying: [ :queue | ].
channel queueBind: result method queue exchange: 'logs' routingKey: ''.
````

Binding the exchange can be interpreted as a known address where the producer will send messages, to the queue from where the consumer will take out the messages. Now with the following collaboration, you'll create a subscription to the queue registering a callback that will open an inspector on each received message by the consumer.

One important thing to notice is that the declared exchange is of type `direct`. This configures the exchange to send messages to the queues whose binding key exactly matches the routing key of the message.

````Smalltalk
channel 
	consumeFrom: result method queue
	applying: [ :messageReceived | messageReceived inspect ].	
````

## Subscriber

The subscriber code

```Smalltalk
| connection  channel queue | 

connection := AmqpConnectionBuilder new
	hostname: 'localhost';
	build.
connection open.

	channel := connection createChannel.
	channel declareExchangeNamed: 'billy' of: 'fanout' applying: [:a | ].

	queue := channel declareQueueApplying: [ :builder | builder beExclusive ].
	channel queueBind: queue method queue exchange: 'billy' routingKey: ''.

	channel
				consumeFrom: queue method queue
				applying: [ :messageReceived | messageReceived inspect ].	
	
"] ensure: [ connection close ]"
```

## Setting up the publisher

On the publisher image open a Playground and run the following code.


```smalltalk
| connection |

connection := AmqpConnectionBuilder new
	hostname: 'localhost';
	build.
connection open.

[ | channel queue | 
	channel := connection createChannel.
	channel declareExchangeNamed: 'billy' of: 'fanout' applying: [:b | ].
	"channel exchangeDeclare: 'billy' type: 'fanout'."

	channel basicPublish: 'de los smashing pumkins' utf8Encoded exchange: 'billy' routingKey: ''.	
	
] ensure: [ connection close ]
```


## Running the example



## Next
