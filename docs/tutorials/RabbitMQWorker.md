# RabbitMQWorker 

This object will connect to an AMQP channel and knows how to consume messages from a specified queue for processing.

Accepts the following options: 

| Attribute name | Description | Optional/Mandatory | Default value |
| ---------------|-------------|--------------------|---------------|
| #hostname | Hostname of the rabbitmq broker | Optional | localhost |
| #port | Port numbre of the rabbitmq broker | Optional | 5672 |
| #username | Username of the rabbitmq broker | Optional | guest |
| #password | Username of the rabbitmq broker | Optional | guest |
| #maximumConnectionAttemps | Amount of retries when connecting to the broker fails | Optional | 3 |
| #timeSlotBetweenConnectionRetriesInMs | Time duration between retry attempts determined by using the exponential backoff algorithm | Optional | 3000 |
| #enableDebuggingLogs | A boolean indicating whether to log debugging events | Optional | false |
| #extraClientProperties | A dictionary with keys and values to set the (client properties)[https://www.rabbitmq.com/docs/connections#capabilities] | Optional | Empty |
| #retry | A block that can configure the internal `Retry` instance | Optional | `[]` |
| #queueName | Queue name where to consume from | Mandatory | |
| #queueDurable | When false sets the [queue durability](https://www.rabbitmq.com/docs/queues#durability) to transient, otherwise will be durable | Optional | true |
