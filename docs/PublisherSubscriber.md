# Publisher/Subscriber

Let's create an example of an publisher/subscriber communication pattern. We will use two images, the first one will emit log events acting as producer and the second one will act as a subscriber recibing the logs and print them on the transcript.

In our logging system every running copy of the receiver program will get the messages. That way we'll be able to run one receiver and direct the logs to disk; and at the same time we'll be able to run another receiver and see the logs on the screen.

Essentially, published log messages are going to be broadcast to all the receivers.

On both images you will need to load the project

```smalltalk
Metacello new
	baseline: 'Lepus';
	repository: 'github://fortizpenaloza/Lepus:<DEFAULT_BRANCH>/source';
	load.
```

For more detail read [Installation](Installation.md) docs.


## Publisher

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


## Subscriber

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
