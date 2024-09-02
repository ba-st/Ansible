Class {
	#name : 'AmqpChannel',
	#superclass : 'Object',
	#instVars : [
		'handler',
		'callbacks',
		'protocolVersion'
	],
	#category : 'Ansible-Protocol-Core',
	#package : 'Ansible-Protocol-Core'
}

{ #category : 'instance creation' }
AmqpChannel class >> using: anAmqpChannelHandler [ 
	
	^self new initializeUsing: anAmqpChannelHandler 
]

{ #category : 'AMQP receiving messages' }
AmqpChannel >> basicAck: anInteger [

	self basicAck: anInteger multiple: false 
]

{ #category : 'AMQP receiving messages' }
AmqpChannel >> basicAck: anInteger multiple: aBoolean [

	self
		rpc:
			( protocolVersion basicAckMethod new
				deliveryTag: anInteger;
				multiple: aBoolean )
]

{ #category : 'AMQP receiving messages' }
AmqpChannel >> basicGet: aString [

	^ self basicGet: aString noAck: false
]

{ #category : 'AMQP receiving messages' }
AmqpChannel >> basicGet: aString noAck: aBoolean [

	"If noAck is set the server does not expect acknowledgements for messages. That is, when a message is delivered to the client the server assumes the delivery will succeed and immediately dequeues it. This functionality may increase performance but at the cost of reliability. Messages can get lost if a client dies before they are delivered to the application."

	| result |

	result := self
		rpc:
			( protocolVersion basicGetMethod new
				queue: aString;
				noAck: aBoolean ).
	( result method isKindOf: protocolVersion basicGetOkMethod )
		ifFalse: [ ( result method isKindOf: protocolVersion basicGetEmptyMethod )
				ifFalse: [ ^ nil ]
			].
	^ result
]

{ #category : 'AMQP sending messages' }
AmqpChannel >> basicPublish: aByteArray exchange: exchangeName routingKey: routingKey [

	^ self
		basicPublish: aByteArray
		exchange: exchangeName
		routingKey: routingKey
		properties: protocolVersion basicPropertiesClass new
]

{ #category : 'AMQP sending messages' }
AmqpChannel >> basicPublish: aByteArray exchange: exchangeName routingKey: routingKey properties: aBasicProperties [

	^ self
		basicPublish: aByteArray
		exchange: exchangeName
		routingKey: routingKey
		properties: aBasicProperties
		mandatory: false
		immediate: false
]

{ #category : 'AMQP sending messages' }
AmqpChannel >> basicPublish: aByteArray exchange: exchangeName routingKey: routingKey properties: aBasicProperties mandatory: mandatory immediate: immediate [

	handler connection
		sendMethod:
			( protocolVersion basicPublishMethod new
				exchange: exchangeName;
				routingKey: routingKey;
				mandatory: mandatory;
				immediate: immediate )
		properties: aBasicProperties
		body: aByteArray
		onChannel: handler channelNumber
]

{ #category : 'AMQP receiving messages' }
AmqpChannel >> basicRecover [

	^ self basicRecover: false
]

{ #category : 'AMQP receiving messages' }
AmqpChannel >> basicRecover: shouldRequeue [

	^ self rpc: ( protocolVersion basicRecoverMethod new requeue: shouldRequeue )
]

{ #category : 'AMQP receiving messages' }
AmqpChannel >> basicReject: anInteger requeue: aBoolean [

	self
		rpc:
			( protocolVersion basicRejectMethod new
				deliveryTag: anInteger;
				requeue: aBoolean )
]

{ #category : 'AMQP receiving messages' }
AmqpChannel >> cancelConsumer: consumerTag [

	self rpc: ( protocolVersion basicCancelMethod new consumerTag: consumerTag ).
	callbacks removeKey: consumerTag ifAbsent: [  ]
]

{ #category : 'AMQP closing' }
AmqpChannel >> close [

	| c |

	handler closeReason
		ifNil: [ c := protocolVersion channelCloseMethod new
				replyCode: protocolVersion replySuccess;
				replyText: 'Normal close';
				classId: 0;
				methodId: 0.
			handler rpc: c.
			handler internalClose: c
			]
]

{ #category : 'AMQP closing' }
AmqpChannel >> closeReason [

	^ handler closeReason
]

{ #category : 'Ansible receiving messages' }
AmqpChannel >> consumeFrom: aQueueName applying: aBlock [
	
	^ self consumeFrom: aQueueName callback: aBlock selector: #value:

]

{ #category : 'AMQP receiving messages' }
AmqpChannel >> consumeFrom: queue callback: anObject selector: aSymbol [

	^ self
		consumeFrom: queue
		callback: anObject
		selector: aSymbol
		noAck: false
		exclusive: false
		consumerTag: ''
]

{ #category : 'AMQP receiving messages' }
AmqpChannel >> consumeFrom: queue callback: anObject selector: aSymbol noAck: noAck [

	^ self
		consumeFrom: queue
		callback: anObject
		selector: aSymbol
		noAck: noAck
		exclusive: false
		consumerTag: ''
]

{ #category : 'AMQP receiving messages' }
AmqpChannel >> consumeFrom: queue callback: anObject selector: aSymbol noAck: noAck exclusive: exclusive consumerTag: aString [

	| result |

	result := self
		rpc:
			( protocolVersion basicConsumeMethod new
				queue: queue;
				consumerTag: aString;
				noAck: noAck;
				exclusive: exclusive ).
	callbacks at: result method consumerTag put: anObject -> aSymbol.
	^ result method consumerTag
]

{ #category : 'AMQP receiving messages' }
AmqpChannel >> consumeFrom: queue callback: anObject selector: aSymbol noAck: noAck exclusive: exclusive consumerTag: aString arguments: aDictionary [

	| result |

	result := self
		rpc:
			( protocolVersion basicConsumeMethod new
				queue: queue;
				consumerTag: aString;
				noAck: noAck;
				exclusive: exclusive;
				arguments: aDictionary ).
	callbacks at: result method consumerTag put: anObject -> aSymbol.
	^ result method consumerTag
]

{ #category : 'Ansible exchange management' }
AmqpChannel >> declareExchangeNamed: aName of: aType applying: aBlock [

	| builder |

	builder := AmqpExchangeDeclareBuilder named: aName of: aType for: protocolVersion.
	^ self rpc: ( builder buildApplying: aBlock )
]

{ #category : 'Ansible queue building' }
AmqpChannel >> declareQueueApplying: aBlock [

	| builder |

	builder := AmqpQueueDeclareBuilder for: protocolVersion.
	^ self rpc: ( builder buildApplying: aBlock )
]

{ #category : 'AMQP exchange management' }
AmqpChannel >> exchangeDelete: exchangeName [

	^ self exchangeDelete: exchangeName ifUnused: false
]

{ #category : 'AMQP exchange management' }
AmqpChannel >> exchangeDelete: exchangeName ifUnused: aBoolean [

	^ self
		rpc:
			( protocolVersion exchangeDeleteMethod new
				exchange: exchangeName;
				ifUnused: aBoolean )
]

{ #category : 'AMQP server-generated events' }
AmqpChannel >> handleBasicDeliver: cmd [

	| a |

	a := callbacks at: cmd method consumerTag.
	a key perform: a value with: cmd
]

{ #category : 'AMQP server-generated events' }
AmqpChannel >> handleChannelClose: cmd [

	handler internalClose: cmd method.
	handler connection
		sendMethod: protocolVersion channelCloseOkMethod new
		onChannel: handler channelNumber	"TODO: notify callbacks of closure"
]

{ #category : 'initialization' }
AmqpChannel >> initializeUsing: aChannelHandler [

	handler := aChannelHandler.
	handler addDependent: self.
	callbacks := Dictionary new.
	protocolVersion := handler connection protocolClass.
	self mapEventHandlers.
	
	self rpc: protocolVersion channelOpenMethod new
]

{ #category : 'initialization' }
AmqpChannel >> mapEventHandlers [

	handler mapEvent: protocolVersion channelCloseMethod to: self selector: #handleChannelClose:.
	handler mapEvent: protocolVersion basicDeliverMethod to: self selector: #handleBasicDeliver:
]

{ #category : 'AMQP receiving messages' }
AmqpChannel >> prefetchCount: prefetchCount [

	^ self prefetchCount: prefetchCount prefetchSize: 0 global: false
]

{ #category : 'AMQP receiving messages' }
AmqpChannel >> prefetchCount: prefetchCount prefetchSize: prefetchSize global: aBoolean [

	^ self
		rpc:
			( protocolVersion basicQosMethod new
				prefetchSize: prefetchSize;
				prefetchCount: prefetchCount;
				global: aBoolean )
]

{ #category : 'AMQP receiving messages' }
AmqpChannel >> printOn: aStream [

	aStream nextPutAll: ( 'AMPQ Channel <1p> on <2p> (<3s>)'
			  expandMacrosWith: handler channelNumber
			  with: handler connection
			  with:
			  ( self
				    whenOpenDo: [ 'Open' ]
				    whenClosedDo: [ :reason | 'Closed due <1p>' expandMacrosWith: reason ] ) )
]

{ #category : 'AMQP private' }
AmqpChannel >> protocolClass [

	^ protocolVersion
]

{ #category : 'AMQP binding management' }
AmqpChannel >> queueBind: queue exchange: exchange routingKey: routingKey [

	^ self
		queueBind: queue
		exchange: exchange
		routingKey: routingKey
		arguments: nil
]

{ #category : 'AMQP binding management' }
AmqpChannel >> queueBind: queue exchange: exchange routingKey: routingKey arguments: aDictionary [

	^ self
		rpc:
			( protocolVersion queueBindMethod new
				queue: queue;
				exchange: exchange;
				routingKey: routingKey;
				arguments: aDictionary )
]

{ #category : 'AMQP queue management' }
AmqpChannel >> queueDelete: queueName [

	^ self queueDelete: queueName ifUnused: false ifEmpty: false
]

{ #category : 'AMQP queue management' }
AmqpChannel >> queueDelete: queueName ifUnused: ifUnused ifEmpty: ifEmpty [

	^ self
		rpc:
			( protocolVersion queueDeleteMethod new
				queue: queueName;
				ifUnused: ifUnused;
				ifEmpty: ifEmpty )
]

{ #category : 'AMQP queue management' }
AmqpChannel >> queuePurge: queue [

	^ self rpc: ( protocolVersion queuePurgeMethod new queue: queue )
]

{ #category : 'AMQP binding management' }
AmqpChannel >> queueUnbind: queue exchange: exchange routingKey: routingKey [

	^ self
		queueUnbind: queue
		exchange: exchange
		routingKey: routingKey
		arguments: nil
]

{ #category : 'AMQP binding management' }
AmqpChannel >> queueUnbind: queue exchange: exchange routingKey: routingKey arguments: aDictionary [

	^ self
		rpc:
			( protocolVersion queueUnbindMethod new
				queue: queue;
				exchange: exchange;
				routingKey: routingKey;
				arguments: aDictionary )
]

{ #category : 'AMQP private' }
AmqpChannel >> rpc: requestMethod [

	^ handler rpc: requestMethod
]

{ #category : 'AMQP local transactions' }
AmqpChannel >> txCommit [

	^ self rpc: protocolVersion txCommitMethod new
]

{ #category : 'AMQP local transactions' }
AmqpChannel >> txRollback [

	^ self rpc: protocolVersion txRollbackMethod new
]

{ #category : 'AMQP local transactions' }
AmqpChannel >> txSelect [

	^ self rpc: protocolVersion txSelectMethod new
]

{ #category : 'AMQP private' }
AmqpChannel >> update: aSymbol [

	aSymbol == #channelHandlerClosed
		ifTrue: [ self changed: #channelClosed ].
	^ super update: aSymbol
]

{ #category : 'accessing' }
AmqpChannel >> whenOpenDo: aBlock whenClosedDo: aClosedHandler [

	^handler whenOpenDo: aBlock whenClosedDo: aClosedHandler


]
