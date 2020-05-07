# Getting started with Ansible

**Ansible** implements two of the major versions of the [AMQP](http://www.amqp.org) messaging prototol: AMQP 0-8 and AMQP 0-9-0.

AMQP is a programmable protocol allowing several messaging patterns, you'll learn some of those patterns with a set of tutorials.

Let's start preparing our environment, the first thing you'll do is install RabbitMQ. We have chosen RabbitMQ as our messaging broker since it was designed with AMQP 0-9-1 as its central protocol.

## Installing RabbitMQ

To keep the installation simple use the docker image provided by the RabbitMQ team on [Docker Hub](https://hub.docker.com/_/rabbitmq). You have to make sure you have [docker installed(https://docs.docker.com/install/), open a console and execute the following command:

` docker run -p 5672:5672 rabbitmq:3-alpine`

This starts up a RabbitMQ server listening on the default port.

## Installing Ansible

Now, on a Pharo image open a Playground and evaluate the following code to load Ansible

```smalltalk
Metacello new
	baseline: 'Ansible';
	repository: 'github://ba-st/Ansible:release-candidate/source';
	load.
```

Save and close this image, you'll use it to perform the tutorials. 

See [Installation.md](Installation.md) to learn more about how install **Ansible** on your image or how to use it as dependency of your project.

That's it! You are ready to start with the tutorials.

## Tutorials

The tutorials are intended to be read in order and are inspired by those in the [Get Started](https://www.rabbitmq.com/getstarted.html) of the official documentation. They are not a rewrite but rather my interpretation. 

1. [Worker queue](WorkerQueue.md)
2. [Publish - Subscribe](PublishSubscribe.md)
3. [Routing](Routing.md)

**Note:** The [official documentation](https://www.rabbitmq.com/documentation.html) is very good and covers each of these topics in great detail. We recommend reading it to get a complete understanding. They also provide this [great tool](http://tryrabbitmq.com) to help you explore diferent messaging patterns.

