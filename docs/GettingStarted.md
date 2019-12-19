# Getting started with Ansible

Let's start preparing our environment, the first thing we will do is install RabbitMQ. We have chosen RabbitMQ as our messaging server since it was designed with AMQP 0-9-1 as its central protocol.

## Installing RabbitMQ

To keep the installaton simple we'll use the docker image provided by the Rabbit team on [Docker Hub](https://hub.docker.com/_/rabbitmq). 

` docker run -p 5467:5467 rabbitmq:3-alpine`

This should start up a RabbitMQ server listening on the default port 5467. 

## Install Ansible

Now, on a Pharo image open a Playground and evaluate the following code to load Ansible

```smalltalk
Metacello new
	baseline: 'Ansible';
	repository: 'github://ba-st/Ansible:release-candidate/source';
	load.
```

See [Installation.md](Installation.md) to learn more about how install Ansible on your image or how to use it as dependency of your project.

Well, we have everything ready to do the tutorials!

AMQP is a programmable protocol and supports several communication schemes, let's illuestrate two of this schemas with simple examples:
- [Worker queue](WorkerQueue.md)
- [Publiser - Subscriber](PublisherSubscriber.md)
