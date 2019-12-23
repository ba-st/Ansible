# Worker queue
(based on the [offical python tutorial](https://www.rabbitmq.com/tutorials/tutorial-two-python.html))

![Diagram of producer/consumer](pc.png)

Work queues allow distributing time-consuming tasks between multiple workers to minimize the time the producer has to wait for it to complete. Tasks are encapsulated as messages and send to the broker. The broker enqueues them and performs a round-robin dispatched to the workers.

For this tutorial, we will model the task as a dotted string. Each dot represents a degree of complexity therefore, the longer the string, the longer it will take.

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

The `channel prefetchCount: 1` implies that RabbitMQ will wait for a worker's previous message ackwoledge before sending it another one. Without this the broker just sends the messages as soon as it recevies them.

Now with the following collaboration, you'll create a subscription to the queue registering a callback that will simulate processing a task by creating a delay of `n` seconds, where `n` is the number of dots in the message. Then it will open a toast inspector on each received message by the consumer. Finally it will send the acknowledge to the broker.

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
If the broker does not receive the acklodge it will requeue the message after ?. Timeout?

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
channel declareExchangeNamed: 'tasks' of: 'direct' applying: [:exchange | ].
channel basicPublish: '.' utf8Encoded exchange: 'tasks' routingKey: ''.
channel
````

The last line publishes a message to the previously agreed exchange. Yes, we are creating the exchange again. Exchange creation operation will not create a new one if one with that name already exists. The same applies to other AMQP entities such as queues and bindings. 

## Running the example

First, run the consumer script on at least two images and then inspect the producer script in another one and start sending messages on the channel using the inspector by sending `#basicPublish:exchange:routingKey:`

