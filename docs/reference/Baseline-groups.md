# Baseline Groups

Ansible includes the following groups in its Baseline that can be used as
loading targets:

- `Deployment-08` will load the packages for the AMQP protocol version 0.8
- `Deployment-091` will load the packages for the AMQP protocol version 0.9.1
- `RabbitMQ` will load packages including some RabbitMQ specific behavior
- `Deployment` will load all the packages needed in a deployed application
- `Tests` will load the test cases
- `Tools` will load the tool used for class generation based on the protocol spec
- `CI` is the group loaded in the continuous integration setup, in this
  particular case it is the same as `Tests`
- `Development` will load all the needed packages to develop and contribute to
   the project
