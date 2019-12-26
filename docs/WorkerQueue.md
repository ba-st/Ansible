# Worker queue
(based on the [offical python tutorial](https://www.rabbitmq.com/tutorials/tutorial-two-python.html))

Work queues allow distributing time-consuming tasks between multiple workers to minimize the time the producer has to wait for it to complete. Tasks are encapsulated as messages and send to the broker. The broker enqueues them and performs a round-robin dispatched to the workers.

![Diagram of producer/consumer](pc.png)

For this tutorial, you'll model tasks as a dotted string, where each dot represents a degree of complexity, therefore the longer the string, the longer it will take (i.e `'...'` is a task taking 3 seconds to complete).

This schema is also known as [CompetingConsumers](https://www.enterpriseintegrationpatterns.com/patterns/messaging/CompetingConsumers.html)

## A brief review of concepts 
## Establishing a connection 

Let's review AMQP concepts by inspecting a consumer setup step-by-step. The first thing you need to do is stablish a connection to the broker

````Smalltalk
connection := AmqpConnectionBuilder new
	hostname: 'localhost';
	build.
connection open.
````

Then you need to create a channel since every operation performed by a client happens on it.

````Smalltalk
channel := connection createChannel.
````

Channels are logical connections to the broker. Channels allow sharing a connection by multiplexing the messages through them; this means communication on a channel is isolated from communication on other channels sharing the same connection. 

On this channel you´re going to create a queue named `task_queue`

````Smalltalk
channel declareQueueApplying: [ :queue | queue name: 'task_queue' ].
channel prefetchCount: 1.
````

The `channel prefetchCount: 1` directs RabbitMQ to wait for a worker's acknowledge before sending it another one. Without this, the broker just sends the messages as soon as it receives them without taking into account if the worker ended with the last one.

Now you'll create a subscription to the queue registering a callback that will simulate running a task by creating a delay of `n` seconds, where `n` is the amount of dots in the message. It will open a toast message for each received message by the consumer showing the time it took, and it will send the acknowledge to the broker

````Smalltalk
channel 
	consumeFrom: 'task_queue'
	applying: [ :messageReceived | | elapsedTime |
	
	elapsedTime :=  messageReceived body utf8Decoded count: [ :char | char = $. ].
	
	(Delay forSeconds: elapsedTime) wait.
	self inform: ('<1s> just finished a new task for <2p> seconds'expandMacrosWith: workerName with: elapsedTime).
	channel basicAck: messageReceived method deliveryTag
].	
````

If the broker does not receive the acknowledge it will wait eternally, there is no timeout. If the connection dies RabbitMQ will re-queue the message and try to send it again.


## Spawning workers

You need to add this last collaboration to spawn a ~minion~ worker to the end of the script:

````Smalltalk
worker := Process
		forContext:
			[ [ [  connection waitForEvent ] repeat ]
				ensure: [ connection close ]
			] asContext
		priority: Processor activePriority.

worker name: workerName.	
worker resume 
````

Here's the complete script, open a new Pharo image and evaluate it on a Playground

```Smalltalk
| workerName connection channel worker |

workerName := 'Minion #1'.

connection := AmqpConnectionBuilder new
	hostname: 'localhost';
	build.
connection open.

channel := connection createChannel.
channel declareQueueApplying: [ :queue | queue name: 'task_queue' ].
channel prefetchCount: 1.

channel 
	consumeFrom: 'task_queue'
	applying: [ :messageReceived | | elapsedTime |
	
	elapsedTime :=  messageReceived body utf8Decoded count: [ :char | char = $. ].
	
	(Delay forSeconds: elapsedTime) wait.
	self inform: ('<1s> just finished a new task for <2p> seconds'expandMacrosWith: workerName with: elapsedTime).
	channel basicAck: messageReceived method deliveryTag
].	

worker := Process
				forContext:
					[ [ [  connection waitForEvent ] repeat ]
						ensure: [ connection close ]
					] asContext
				priority: Processor activePriority.

worker name: workerName.	
worker resume 
````

At this point probably you noticed you could run this script multiple times in the same image by changing the process name,  but try running it just once and use multiple images for simplicity.

## Setting up the producer

Open another image with Ansible loaded and in a Playground evaluate the following code

````Smalltalk
| connection channel |
connection := AmqpConnectionBuilder new
	hostname: 'localhost';
	build.
connection open.

channel := connection createChannel.
channel declareQueueApplying: [ :queue | queue name: 'task_queue' ].
channel basicPublish: '.' utf8Encoded exchange: 'tasks' routingKey: ''.
channel
````

The last line publishes a message to the `task_queue`. Yes, we are creating the queue again. Queue creation operation will not create a new one if one with that name already exists. The same applies to other AMQP entities such as exchanges and bindings. 

## Running the example

First, run the consumer script on at least two images and then inspect the producer script in another one and start sending messages on the channel using the inspector by sending `#basicPublish:exchange:routingKey:`

