# Getting started with Ansible

Let's start preparing our environment, the first thing you'll do is install RabbitMQ. We have chosen RabbitMQ as our messaging broker since it was designed with AMQP 0-9-1 as its central protocol.

## Installing RabbitMQ

To keep the installation simple use the docker image provided by the RabbitMQ team on [Docker Hub](https://hub.docker.com/_/rabbitmq). Be sure of having docker installed, open a console and execute the following command:

` docker run -p 5467:5467 rabbitmq:3-alpine`

This should have started up a RabbitMQ server listening on the default port.

## Installing Ansible

Now, on a Pharo image open a Playground and evaluate the following code to load Ansible

```smalltalk
Metacello new
	baseline: 'Ansible';
	repository: 'github://ba-st/Ansible:release-candidate/source';
	load.
```

Save and close this image, we will be using it 

See [Installation.md](Installation.md) to learn more about how install Ansible on your image or how to use it as dependency of your project.

Well, we have everything ready to do the tutorials!

## Tutorials

The tutorials are intended to be read in order and are inspired by those in the [official documentation](https://www.rabbitmq.com/documentation.html). They are not a rewrite but rather my interpretation. Moreover, we strongly recommend that you read it as it has much more depth in each of the topics.

*Note:* The [official documentation](https://www.rabbitmq.com/documentation.html) is very good and covers each of these topics in great detail. We recommend that read it to get a complete understanding. 

AMQP is a programmable protocol and supports several communication schemes, we'll illustrate two of these schemas with simple examples:

1. [Worker queue](WorkerQueue.md)
2. [Publisher - Subscriber](PublisherSubscriber.md)
3. [Routing](Routing.md)

## Final words

