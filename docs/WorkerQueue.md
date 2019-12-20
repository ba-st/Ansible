# Worker queue

Work queues allow to distribute time-consuming tasks between multiple workers to minimize the time the producer have to wait for it to complete. Task are encapsulated as messages and send to the broker. The broker enques them and perform a round-robin dispached to the workers.

For this tutorial we will model task as a dotted strings. Each dot represents a degree of complexity therefore, the longer the string, the longer it will take.

This schema is also know as producer/consumer.

## Spawning a bunch of minions

The first thing we will need to create a consumer is to stablish a connection to the broker 

````Smalltalk
connection := AmqpConnectionBuilder new
	hostname: 'localhost';
	build.
connection open.
````

Then we need to create a channel, since every operation performed by a client happens on a channel. 

````Smalltalk
channel := connection createChannel.
````
Channels are logical connections to the broker. Communication on a channel is isolated from communication on other channels sharing the same connection. 

On this channel we are gonna to create an exchange, a queue and binding between the two:

````Smalltalk
channel declareExchangeNamed: 'tasks' of: 'direct' applying: [:exchange | ].
result := channel declareQueueApplying: [ :queue | ].
channel queueBind: result method queue exchange: 'tasks' routingKey: ''.
````

We just bind the exchange, a known adress where the producer will send messages, to the queue from where the consumer will take out this messages. Now with the following collaboration we'll create a subscription to the queue registering a callback that will open an inspector on each received message.

````Smalltalk
channel 
	consumeFrom: result method queue
	applying: [ :messageReceived | messageReceived inspect ].	
````

Last we need to spawn a ~minion~ consumer by addding to the end of the script:
````Smalltalk
minion := Process
	forContext:
		[ [ [ connection waitForEvent ] repeat ] 
			ensure: [ connection close ] 
		] asContext priority: Processor activePriority.
	minion name: 'Minion'.
	
minion resume 
````

Here's the complete script, open an new image and on a playground evaluate:

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

At this point probably you noticed you could run this script multiple times in the same image by changing the process name, but try running it just one and use multiple images for simplicty.

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

The last line publishes a a message to the previously agreed exchange. Yes, we are creating the exchange again. Exchange creation operation will not create a new one if one with that name already exists.

## Running the example

First run the consumer script on at least two images and then inspect the producer script in another one and start sending messages on the channel using the inspector by sending `channel basicPublish: '.' utf8Encoded exchange: 'tasks' routingKey: ''.`

