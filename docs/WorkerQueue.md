# Worker queue

Work queues allow to distribute time-consuming tasks between multiple workers to minimize the time the producer have to wait for it to complete. Task are encapsulated as messages and send to the broker. The broker enques them and perform a round-robin dispached to the workers.

For this tutorial we will model task as a dotted strings. Each dot represents a degree of complexity therefore, the longer the string, the longer it will take.

This schema is also know as producer/consumer.

## A bunch of minions

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


## Setting up the producer

Let's open and image with Ansible loaded and in a Playground evaluate the following code

````Smalltalk
| connection |
connection := AmqpConnectionBuilder new
	hostname: 'localhost';
	build.
connection open.
[ | channel result | 
	
	channel := connection createChannel.
	channel declareExchangeNamed: 'tasks' of: 'direct' applying: [:exchange | ].
"	result := channel declareQueueApplying: [ :queue | ].
	channel queueBind: result method queue exchange: 'tasks' routingKey: ''."
	
	channel basicPublish: '.' utf8Encoded exchange: 'tasks' routingKey: ''.	

] ensure: [ connection close ]
````






## 
