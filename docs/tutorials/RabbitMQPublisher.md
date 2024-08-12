# RabbitMQPublisher 

This object will connect to an AMQP channel and knows how to publish messages to the specified queue for further processing.

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