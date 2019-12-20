# Worker queue

Work queues allow distributing time-consuming tasks between multiple workers to minimize the time the producer has to wait for it to complete. Tasks are encapsulated as messages and send to the broker. The broker enqueues them and performs a round-robin dispatched to the workers.

For this tutorial, we will model the task as a dotted string. Each dot represents a degree of complexity therefore, the longer the string, the longer it will take.

This schema is also known as [producer/consumer](https://en.wikipedia.org/wiki/Producer%E2%80%93consumer_problem).

## Spawning a bunch of minions

The first thing you need to do is to stablish a connection to the broker

````Smalltalk
connection := AmqpConnectionBuilder new
	hostname: 'localhost';
	build.
connection open.
````

Then you need to create a channel since every operation performed by a client happens on a channel.

````Smalltalk
channel := connection createChannel.
````

Channels are logical connections to the broker. Communication on a channel is isolated from communication on other channels sharing the same connection. 

On this channel you´re going to create an exchange, a queue, and a binding between this two:

````Smalltalk
channel declareExchangeNamed: 'tasks' of: 'direct' applying: [:exchange | ].
result := channel declareQueueApplying: [ :queue | ].
channel queueBind: result method queue exchange: 'tasks' routingKey: ''.
````

You just bind the exchange, think of it as a known address where the producer will send messages, to the queue from where the consumer will take out the messages. Now with the following collaboration, you'll create a subscription to the queue registering a callback that will open an inspector on each received message by the consumer.

````Smalltalk
channel 
	consumeFrom: result method queue
	applying: [ :messageReceived | messageReceived inspect ].	
````

The last collaboration spawns a ~minion~ consumer by addding to the end of the script:

````Smalltalk
minion := Process
	forContext:
		[ [ [ connection waitForEvent ] repeat ] 
			ensure: [ connection close ] 
		] asContext priority: Processor activePriority.
	minion name: 'Minion'.
	
minion resume 
````

Here's the complete script, open a new image and on a playground evaluate:

````Smalltalk
| connection channel result minion |

connection := AmqpConnectionBuilder new
	hostname: 'localhost';
	build.
connection open.

channel := connection createChannel.
channel declareExchangeNamed: 'tasks' of: 'direct' applying: [:exchange | ].
result := channel declareQueueApplying: [ :queue | ].
channel queueBind: result method queue exchange: 'tasks' routingKey: ''.
channel 
	consumeFrom: result method queue
	applying: [ :messageReceived | messageReceived inspect ].	

minion := Process
				forContext:
					[ [ [ connection waitForEvent ] repeat ]
						ensure: [ connection close ]
					] asContext
				priority: Processor activePriority.
	minion name: 'Minion'.
	
minion resume 
````

At this point probably you noticed you could run this script multiple times in the same image by changing the process name, but try running it just one and use multiple images for simplicity.

## Setting up the producer

Open another image with Ansible loaded and in a Playground evaluate the following code:

````Smalltalk
| connection channel |
connection := AmqpConnectionBuilder new
	hostname: 'localhost';
	build.
connection open.

channel := connection createChannel.
channel declareExchangeNamed: 'tasks' of: 'direct' applying: [:exchange | ].
channel basicPublish: '.' utf8Encoded exchange: 'tasks' routingKey: ''.
channel
````

The last line publishes a message to the previously agreed exchange. Yes, we are creating the exchange again. Exchange creation operation will not create a new one if one with that name already exists.

## Running the example

First, run the consumer script on at least two images and then inspect the producer script in another one and start sending messages on the channel using the inspector by sending `#basicPublish:exchange:routingKey:`

