Class {
	#name : #Amqp091,
	#superclass : #AmqpProtocol,
	#category : #'Ansible-Protocol-091'
}

{ #category : #'AMQP protocol constants' }
Amqp091 class >> accessRefused [

	^ 403
]

{ #category : #'AMQP methods' }
Amqp091 class >> basicAckMethod [

	^ Amqp091BasicAck
]

{ #category : #'AMQP methods' }
Amqp091 class >> basicCancelMethod [

	^ Amqp091BasicCancel
]

{ #category : #'AMQP methods' }
Amqp091 class >> basicCancelOkMethod [

	^ Amqp091BasicCancelOk
]

{ #category : #'AMQP methods' }
Amqp091 class >> basicConsumeMethod [

	^ Amqp091BasicConsume
]

{ #category : #'AMQP methods' }
Amqp091 class >> basicConsumeOkMethod [

	^ Amqp091BasicConsumeOk
]

{ #category : #'AMQP methods' }
Amqp091 class >> basicDeliverMethod [

	^ Amqp091BasicDeliver
]

{ #category : #'AMQP methods' }
Amqp091 class >> basicGetEmptyMethod [

	^ Amqp091BasicGetEmpty
]

{ #category : #'AMQP methods' }
Amqp091 class >> basicGetMethod [

	^ Amqp091BasicGet
]

{ #category : #'AMQP methods' }
Amqp091 class >> basicGetOkMethod [

	^ Amqp091BasicGetOk
]

{ #category : #'AMQP methods' }
Amqp091 class >> basicNackMethod [

	^ Amqp091BasicNack
]

{ #category : #'AMQP content properties' }
Amqp091 class >> basicPropertiesClass [

	^ Amqp091BasicProperties
]

{ #category : #'AMQP methods' }
Amqp091 class >> basicPublishMethod [

	^ Amqp091BasicPublish
]

{ #category : #'AMQP methods' }
Amqp091 class >> basicQosMethod [

	^ Amqp091BasicQos
]

{ #category : #'AMQP methods' }
Amqp091 class >> basicQosOkMethod [

	^ Amqp091BasicQosOk
]

{ #category : #'AMQP methods' }
Amqp091 class >> basicRecoverAsyncMethod [

	^ Amqp091BasicRecoverAsync
]

{ #category : #'AMQP methods' }
Amqp091 class >> basicRecoverMethod [

	^ Amqp091BasicRecover
]

{ #category : #'AMQP methods' }
Amqp091 class >> basicRecoverOkMethod [

	^ Amqp091BasicRecoverOk
]

{ #category : #'AMQP methods' }
Amqp091 class >> basicRejectMethod [

	^ Amqp091BasicReject
]

{ #category : #'AMQP methods' }
Amqp091 class >> basicReturnMethod [

	^ Amqp091BasicReturn
]

{ #category : #'AMQP methods' }
Amqp091 class >> channelCloseMethod [

	^ Amqp091ChannelClose
]

{ #category : #'AMQP methods' }
Amqp091 class >> channelCloseOkMethod [

	^ Amqp091ChannelCloseOk
]

{ #category : #'AMQP protocol constants' }
Amqp091 class >> channelError [

	^ 504
]

{ #category : #'AMQP methods' }
Amqp091 class >> channelFlowMethod [

	^ Amqp091ChannelFlow
]

{ #category : #'AMQP methods' }
Amqp091 class >> channelFlowOkMethod [

	^ Amqp091ChannelFlowOk
]

{ #category : #'AMQP methods' }
Amqp091 class >> channelOpenMethod [

	^ Amqp091ChannelOpen
]

{ #category : #'AMQP methods' }
Amqp091 class >> channelOpenOkMethod [

	^ Amqp091ChannelOpenOk
]

{ #category : #'AMQP protocol constants' }
Amqp091 class >> commandInvalid [

	^ 503
]

{ #category : #'AMQP methods' }
Amqp091 class >> confirmSelectMethod [

	^ Amqp091ConfirmSelect
]

{ #category : #'AMQP methods' }
Amqp091 class >> connectionCloseMethod [

	^ Amqp091ConnectionClose
]

{ #category : #'AMQP methods' }
Amqp091 class >> connectionCloseOkMethod [

	^ Amqp091ConnectionCloseOk
]

{ #category : #'AMQP protocol constants' }
Amqp091 class >> connectionForced [

	^ 320
]

{ #category : #'AMQP methods' }
Amqp091 class >> connectionOpenMethod [

	^ Amqp091ConnectionOpen
]

{ #category : #'AMQP methods' }
Amqp091 class >> connectionOpenOkMethod [

	^ Amqp091ConnectionOpenOk
]

{ #category : #'AMQP methods' }
Amqp091 class >> connectionSecureMethod [

	^ Amqp091ConnectionSecure
]

{ #category : #'AMQP methods' }
Amqp091 class >> connectionSecureOkMethod [

	^ Amqp091ConnectionSecureOk
]

{ #category : #'AMQP methods' }
Amqp091 class >> connectionStartMethod [

	^ Amqp091ConnectionStart
]

{ #category : #'AMQP methods' }
Amqp091 class >> connectionStartOkMethod [

	^ Amqp091ConnectionStartOk
]

{ #category : #'AMQP methods' }
Amqp091 class >> connectionTuneMethod [

	^ Amqp091ConnectionTune
]

{ #category : #'AMQP methods' }
Amqp091 class >> connectionTuneOkMethod [

	^ Amqp091ConnectionTuneOk
]

{ #category : #'AMQP protocol constants' }
Amqp091 class >> contentTooLarge [

	^ 311
]

{ #category : #'AMQP methods' }
Amqp091 class >> exchangeDeclareMethod [

	^ Amqp091ExchangeDeclare
]

{ #category : #'AMQP methods' }
Amqp091 class >> exchangeDeclareOkMethod [

	^ Amqp091ExchangeDeclareOk
]

{ #category : #'AMQP methods' }
Amqp091 class >> exchangeDeleteMethod [

	^ Amqp091ExchangeDelete
]

{ #category : #'AMQP methods' }
Amqp091 class >> exchangeDeleteOkMethod [

	^ Amqp091ExchangeDeleteOk
]

{ #category : #'AMQP protocol constants' }
Amqp091 class >> frameBody [

	^ 3
]

{ #category : #'AMQP protocol constants' }
Amqp091 class >> frameEnd [

	^ 206
]

{ #category : #'AMQP protocol constants' }
Amqp091 class >> frameError [

	^ 501
]

{ #category : #'AMQP protocol constants' }
Amqp091 class >> frameHeader [

	^ 2
]

{ #category : #'AMQP protocol constants' }
Amqp091 class >> frameHeartbeat [

	^ 8
]

{ #category : #'AMQP protocol constants' }
Amqp091 class >> frameMethod [

	^ 1
]

{ #category : #'AMQP protocol constants' }
Amqp091 class >> frameMinSize [

	^ 4096
]

{ #category : #'class initialization' }
Amqp091 class >> initialize [

	classIds at: 60 put: Amqp091BasicProperties.
	methodIds at: 1310741 put: Amqp091ChannelFlowOk.
	methodIds at: 1310760 put: Amqp091ChannelClose.
	methodIds at: 1310731 put: Amqp091ChannelOpenOk.
	methodIds at: 1310730 put: Amqp091ChannelOpen.
	methodIds at: 1310740 put: Amqp091ChannelFlow.
	methodIds at: 1310761 put: Amqp091ChannelCloseOk.
	methodIds at: 2621461 put: Amqp091ExchangeDeleteOk.
	methodIds at: 2621451 put: Amqp091ExchangeDeclareOk.
	methodIds at: 2621450 put: Amqp091ExchangeDeclare.
	methodIds at: 2621460 put: Amqp091ExchangeDelete.
	methodIds at: 655411 put: Amqp091ConnectionCloseOk.
	methodIds at: 655410 put: Amqp091ConnectionClose.
	methodIds at: 655370 put: Amqp091ConnectionStart.
	methodIds at: 655380 put: Amqp091ConnectionSecure.
	methodIds at: 655401 put: Amqp091ConnectionOpenOk.
	methodIds at: 655400 put: Amqp091ConnectionOpen.
	methodIds at: 655381 put: Amqp091ConnectionSecureOk.
	methodIds at: 655371 put: Amqp091ConnectionStartOk.
	methodIds at: 655391 put: Amqp091ConnectionTuneOk.
	methodIds at: 655390 put: Amqp091ConnectionTune.
	methodIds at: 3276850 put: Amqp091QueueUnbind.
	methodIds at: 3276811 put: Amqp091QueueDeclareOk.
	methodIds at: 3276851 put: Amqp091QueueUnbindOk.
	methodIds at: 3276830 put: Amqp091QueuePurge.
	methodIds at: 3276831 put: Amqp091QueuePurgeOk.
	methodIds at: 3276810 put: Amqp091QueueDeclare.
	methodIds at: 3276821 put: Amqp091QueueBindOk.
	methodIds at: 3276841 put: Amqp091QueueDeleteOk.
	methodIds at: 3276820 put: Amqp091QueueBind.
	methodIds at: 3276840 put: Amqp091QueueDelete.
	methodIds at: 5898270 put: Amqp091TxRollback.
	methodIds at: 5898271 put: Amqp091TxRollbackOk.
	methodIds at: 5898261 put: Amqp091TxCommitOk.
	methodIds at: 5898251 put: Amqp091TxSelectOk.
	methodIds at: 5898260 put: Amqp091TxCommit.
	methodIds at: 5898250 put: Amqp091TxSelect.
	methodIds at: 3932260 put: Amqp091BasicRecoverAsync.
	methodIds at: 3932270 put: Amqp091BasicRecover.
	methodIds at: 3932171 put: Amqp091BasicQosOk.
	methodIds at: 3932231 put: Amqp091BasicGetOk.
	methodIds at: 3932220 put: Amqp091BasicDeliver.
	methodIds at: 3932200 put: Amqp091BasicPublish.
	methodIds at: 3932170 put: Amqp091BasicQos.
	methodIds at: 3932190 put: Amqp091BasicCancel.
	methodIds at: 3932180 put: Amqp091BasicConsume.
	methodIds at: 3932232 put: Amqp091BasicGetEmpty.
	methodIds at: 3932240 put: Amqp091BasicAck.
	methodIds at: 3932250 put: Amqp091BasicReject.
	methodIds at: 3932181 put: Amqp091BasicConsumeOk.
	methodIds at: 3932210 put: Amqp091BasicReturn.
	methodIds at: 3932230 put: Amqp091BasicGet.
	methodIds at: 3932191 put: Amqp091BasicCancelOk.
	methodIds at: 3932271 put: Amqp091BasicRecoverOk.
	methodIds at: 3932280 put: Amqp091BasicNack.
	methodIds at: 5570570 put: Amqp091ConfirmSelect.
	methodIds at: 5570571 put: Amqp091ConfirmSelectOk
]

{ #category : #'AMQP protocol constants' }
Amqp091 class >> internalError [

	^ 541
]

{ #category : #'AMQP protocol constants' }
Amqp091 class >> invalidPath [

	^ 402
]

{ #category : #'AMQP protocol' }
Amqp091 class >> isObsoleteProtocolVariant [

	^ false
]

{ #category : #'AMQP protocol' }
Amqp091 class >> majorVersion [

	^ 0
]

{ #category : #'AMQP protocol' }
Amqp091 class >> minorVersion [

	^ 9
]

{ #category : #'AMQP protocol constants' }
Amqp091 class >> noConsumers [

	^ 313
]

{ #category : #'AMQP protocol constants' }
Amqp091 class >> notAllowed [

	^ 530
]

{ #category : #'AMQP protocol constants' }
Amqp091 class >> notFound [

	^ 404
]

{ #category : #'AMQP protocol constants' }
Amqp091 class >> notImplemented [

	^ 540
]

{ #category : #'AMQP protocol' }
Amqp091 class >> portNumber [

	^ 5672
]

{ #category : #'AMQP protocol constants' }
Amqp091 class >> preconditionFailed [

	^ 406
]

{ #category : #'AMQP methods' }
Amqp091 class >> queueBindMethod [

	^ Amqp091QueueBind
]

{ #category : #'AMQP methods' }
Amqp091 class >> queueBindOkMethod [

	^ Amqp091QueueBindOk
]

{ #category : #'AMQP methods' }
Amqp091 class >> queueDeclareMethod [

	^ Amqp091QueueDeclare
]

{ #category : #'AMQP methods' }
Amqp091 class >> queueDeclareOkMethod [

	^ Amqp091QueueDeclareOk
]

{ #category : #'AMQP methods' }
Amqp091 class >> queueDeleteMethod [

	^ Amqp091QueueDelete
]

{ #category : #'AMQP methods' }
Amqp091 class >> queueDeleteOkMethod [

	^ Amqp091QueueDeleteOk
]

{ #category : #'AMQP methods' }
Amqp091 class >> queuePurgeMethod [

	^ Amqp091QueuePurge
]

{ #category : #'AMQP methods' }
Amqp091 class >> queuePurgeOkMethod [

	^ Amqp091QueuePurgeOk
]

{ #category : #'AMQP methods' }
Amqp091 class >> queueUnbindMethod [

	^ Amqp091QueueUnbind
]

{ #category : #'AMQP methods' }
Amqp091 class >> queueUnbindOkMethod [

	^ Amqp091QueueUnbindOk
]

{ #category : #'AMQP protocol constants' }
Amqp091 class >> replySuccess [

	^ 200
]

{ #category : #'AMQP protocol constants' }
Amqp091 class >> resourceError [

	^ 506
]

{ #category : #'AMQP protocol constants' }
Amqp091 class >> resourceLocked [

	^ 405
]

{ #category : #'AMQP protocol' }
Amqp091 class >> revision [

	^ 1
]

{ #category : #'AMQP protocol constants' }
Amqp091 class >> syntaxError [

	^ 502
]

{ #category : #'AMQP methods' }
Amqp091 class >> txCommitMethod [

	^ Amqp091TxCommit
]

{ #category : #'AMQP methods' }
Amqp091 class >> txCommitOkMethod [

	^ Amqp091TxCommitOk
]

{ #category : #'AMQP methods' }
Amqp091 class >> txRollbackMethod [

	^ Amqp091TxRollback
]

{ #category : #'AMQP methods' }
Amqp091 class >> txRollbackOkMethod [

	^ Amqp091TxRollbackOk
]

{ #category : #'AMQP methods' }
Amqp091 class >> txSelectMethod [

	^ Amqp091TxSelect
]

{ #category : #'AMQP methods' }
Amqp091 class >> txSelectOkMethod [

	^ Amqp091TxSelectOk
]

{ #category : #'AMQP protocol constants' }
Amqp091 class >> unexpectedFrame [

	^ 505
]
