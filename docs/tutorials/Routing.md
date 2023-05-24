# Routing

> Based on the [official Python tutorial](https://www.rabbitmq.com/tutorials/tutorial-four-python.html)

This communication pattern allows sending messages to a specific route.

![Diagram of routing](routing.png)

In this tutorial, you'll refine the logging example you did [previously](PublishSubscribe.md)
 by selectively sending some log messages to a specific error logger.

Log messages have a severity: `info`, `warning` or `error`.

## Direct exchange

At the code level changes are minor, you will create an exchange of type
 `direct` instead of `fanout`. A direct exchange sends messages to the queues
 whose binding key is equal to the routing key of the message.

```smalltalk
channel declareExchangeNamed: 'better_logs' of: 'direct' applying: [:exchange | ].
result := channel declareQueueApplying: [ :queue | ].
channel queueBind: result method queue exchange: 'better_logs' routingKey: 'error'.
```

You'll be using the severity labels as binding keys.

## Logging to the Transcript

This is the complete code for spawning a logger that will post every message
 to the Transcript

```smalltalk
| connection channel result logger |

connection := AmqpConnectionBuilder new
  hostname: 'localhost';
  build.
connection open.

channel := connection createChannel.
channel declareExchangeNamed: 'better_logs' of: 'direct' applying: [:exchange | ].
result := channel declareQueueApplying: [ :queue | ].

#('info' 'warning' 'error') do: [ :severity |
  channel queueBind: result method queue exchange: 'better_logs' routingKey: severity.
].

channel
  consumeFrom: result method queue
  applying: [ :messageReceived |
    Transcript show: ('<2s> [<1s>]<n>'
    expandMacrosWith: messageReceived method routingKey
    with: messageReceived body utf8Decoded)
 ].

logger := Process
    forContext:
     [ [ [  connection waitForEvent ] repeat ]
      ensure: [ connection close ]
     ] asContext
    priority: Processor activePriority.
logger name: 'Transcript logger'.

logger resume
```

Notice that the queue was bound to every severity

```smalltalk
#('info' 'warning' 'error') do: [ :severity |
 channel queueBind: result method queue exchange: 'better_logs' routingKey: severity.
]
```

## Building an error notifier

This is the complete code for spawning a process that will pop up a toast
 notification on every error message sent. You can see that just after creating
 the queue, the only change is a binding to the `error` key. Only that one.

```smalltalk
| connection channel result logger |

connection := AmqpConnectionBuilder new
  hostname: 'localhost';
  build.
connection open.

channel := connection createChannel.
channel declareExchangeNamed: 'better_logs' of: 'direct' applying: [:exchange | ].
result := channel declareQueueApplying: [ :queue | ].
channel queueBind: result method queue exchange: 'better_logs' routingKey: 'error'.

channel
 consumeFrom: result method queue
 applying: [ :messageReceived |
  GrowlMorph
   openWithLabel: 'Error'
   contents: 'A log message has arrived!'
   backgroundColor: Color red
   labelColor: Color black ].

logger := Process
    forContext:
     [ [ [  connection waitForEvent ] repeat ]
      ensure: [ connection close ]
     ] asContext
    priority: Processor activePriority.
logger name: 'Error notifier'.

logger resume
```

## Producing logs

This is the script to produce log entries, do not forget to add the severity
 as routing key

```smalltalk
| connection channel result |

connection := AmqpConnectionBuilder new
 hostname: 'localhost';
 build.
connection open.

channel := connection createChannel.
channel declareExchangeNamed: 'better_logs' of: 'direct' applying: [:exchange | ].

channel
  basicPublish: '2014-10-31 13:11:10.8458 Service started up' utf8Encoded
  exchange: 'better_logs'
  routingKey: 'info'.
channel
```

## Running the example

Evaluate the scripts in two different Pharo images. On the subscriber image evaluate,
 in different Playgrounds, the scripts for the Transcript logger and error notifier.
 Open the Transcript.

In the image acting as producer, open a Playground and inspect the script to
 produce log messages, use the inspector to send more messages sending the
 `#basicPublish:exchange:routingKey` message to the inspected channel.

While sending messages the subscriber's Transcript will look like this

![Logger in action](routing_transcript_logger.gif)

And every time you send a message with `error` routing key you also will see
 this notification

![Error notification](routing_error_notifier.png)
