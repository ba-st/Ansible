# RabbitMQPublisher

This object will connect to an AMQP channel and knows how to publish messages
to the specified queue for further processing.

Accepts the following options:

<!-- markdownlint-disable MD013 -->
| Attribute name | Description | Optional/Mandatory | Default value |
| ---------------|-------------|--------------------|---------------|
| #hostname | Hostname of the rabbitmq broker | Optional | localhost |
| #port | Port numbre of the rabbitmq broker | Optional | 5672 |
| #username | Username of the rabbitmq broker | Optional | guest |
| #password | Username of the rabbitmq broker | Optional | guest |
| #maximumConnectionAttemps | Amount of retries when connecting to the broker fails | Optional | 3 |
| #timeSlotBetweenConnectionRetriesInMs | Time duration between retry attempts determined by using the exponential backoff algorithm | Optional | 3000 |
| #enableDebuggingLogs | A boolean indicating whether to log debugging events | Optional | false |
| #extraClientProperties | A dictionary with keys and values to set the [client properties](https://www.rabbitmq.com/docs/connections#capabilities) |Optional | Empty |
| #retry | A block that can configure the internal `Retry` instance | Optional | `[]` |

## Usage

You need to instantiate the publisher with the options above and then send `#start` to ensure the [channel](https://www.rabbitmq.com/docs/channels) is open.

```smalltalk
| publisher | 
publisher := RabbitMQPublisher configuredBy: [ :options | 
    options
        at: #username put: 'guest';
        at: #password put: 'guest';
        at: #hostname put: 'localhost'
].

publisher start.
```

Once the publisher is started, you can use its protocol to send messages.

* Publish directly to a specific queue using the [default exchange](https://www.rabbitmq.com/tutorials/amqp-concepts#exchange-default).

```smalltalk
publisher publish: 'The message' to: 'the-queue'. 
```

* Publish to a routing key through a [direct](https://www.rabbitmq.com/tutorials/amqp-concepts#exchange-direct) or [topic](https://www.rabbitmq.com/tutorials/amqp-concepts#exchange-topic) exchange.

```smalltalk
publisher publish: 'The message' to: 'a-routing-key' through: 'the-exchange'.
```

* Publish to all queues bound to a [fanout exchange](https://www.rabbitmq.com/tutorials/amqp-concepts#exchange-fanout).

```smalltalk
publisher broadcast: 'The message' toAllQueuesBindedTo: 'a-fanout-exchange'.
```

For proper shutdown and connection closure, you need to run:

```smalltalk
publisher stop.
```
