# Publish-Subscribe
(based on the [offical python tutorial](https://www.rabbitmq.com/tutorials/tutorial-three-python.html))

This communication pattern allows sending the same message to more than one receiver. 

![Diagram of publish-subscribe](publish_subscribe.png)

For this tutorial you'll set up a logging system with two subscribers, one will receive the log messages and print them on the Transcript and the other one will open a toast indicating that a new log message arrived.

For more information on the pattern see [publish-subsribe](https://www.enterpriseintegrationpatterns.com/patterns/messaging/PublishSubscribeChannel.html) 

## Introducing the exchange 

Configuring the connection is very similar to the previous example but we will make some changes that we will explain in detail. From the subscriber code, after creating the channel

````Smalltalk
channel declareExchangeNamed: 'logs' of: 'fanout' applying: [:exchange | ].
queue := channel declareQueueApplying: [ :builder | builder beExclusive ].
channel queueBind: queue method queue exchange: 'logs' routingKey: ''.
````
In order, these collaborations will create an exchange named `logs`, a queue, and a binding between the two.

Binding the exchange can be interpreted as a known address where the producer will send messages, to the queue from where the consumer will take out the messages. One important thing to notice is that the declared exchange is of type `fanout`. Essentially, published messages are going to be broadcast to all the binded queues.

## Spawning loggers

This is the complete code for spawning a logger

```Smalltalk
| loggerName connection channel result logger |

loggerName := 'File logger #1'.

connection := AmqpConnectionBuilder new
	hostname: 'localhost';
	build.
connection open.

channel := connection createChannel.
channel declareExchangeNamed: 'logs' of: 'fanout' applying: [:exchange | ].
result := channel declareQueueApplying: [ :queue | ].
channel queueBind: result method queue exchange: 'logs' routingKey: ''.
channel 
	consumeFrom: result method queue
	applying: [ :messageReceived | Transcript show: ('<1s> just received <2p><n>' expandMacrosWith: loggerName with: messageReceived body utf8Decoded) ].	

logger := Process
	forContext:
		[ [ [  connection waitForEvent ] repeat ]
			ensure: [ connection close ]
		] asContext
	priority: Processor activePriority.
logger name: loggerName.
	
logger resume 
```

You could spawn as many as you want, but change the `loggerName` contents to follow the messaging. 

## Setting up the publisher

On the publisher image open a Playground and copy the following script

```smalltalk
| connection channel result |

connection := AmqpConnectionBuilder new
	hostname: 'localhost';
	build.
connection open.

channel := connection createChannel.
channel declareExchangeNamed: 'logs' of: 'fanout' applying: [:exchange | ].

channel basicPublish: 'Message #1' utf8Encoded exchange: 'logs' routingKey: ''.	
channel
```

## Running the example

## Next
