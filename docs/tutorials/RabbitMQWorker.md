# RabbitMQWorker

This object will connect to an AMQP channel and knows how to consume messages
from a specified queue for processing.

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
| #extraClientProperties | A dictionary with keys and values to set the [client properties](https://www.rabbitmq.com/docs/connections#capabilities)| Optional | Empty |
| #retry | A block that can configure the internal `Retry` instance | Optional | `[]` |
| #queueName | Queue name where to consume from | Mandatory | |
| #queueDurable | When false sets the [queue durability](https://www.rabbitmq.com/docs/queues#durability) to transient, otherwise will be durable | Optional | true |

## Usage

You need to instantiate the worker with the options above.

```smalltalk
| worker |
worker := RabbitMQWorker configuredBy: [ :options |
    options
        at: #hostname put: 'localhost';
        at: #queueName put: aQueueName;
        at: #extraClientProperties put: (
            Dictionary new
                at: 'process' put: 'aName';
                yourself )
    ]
    processingPayloadWith: [:message | message inspect ].
```

Before sending `#start`, you need to consider [bind the queue](https://www.rabbitmq.com/tutorials/tutorial-four-python#bindings) to an exchange if necessary.

```smalltalk
worker bindQueueTo: 'an-exchange-name' routedBy: 'a-routing-key'.
```

The #start method will block the socket, waiting for any new event, so it's recommended to fork the process and ensure that, before terminating, you unbind the queue and close the connection properly.

```smalltalk
workerProcess := [
    [ worker start ] ensure: [
        worker unbindQueueTo: 'an-exchange-name' routedBy: 'a-routing-key'.
        worker stop
        ]
] fork
```
