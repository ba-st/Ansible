Extension { #name : 'Amqp091BasicProperties' }

{ #category : '*Ansible-RabbitMQ' }
Amqp091BasicProperties >> bePersistent [

  self deliveryMode: 2
]
