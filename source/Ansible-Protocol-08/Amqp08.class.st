Class {
	#name : #Amqp08,
	#superclass : #AmqpProtocol,
	#category : #'Ansible-Protocol-08'
}

{ #category : #'AMQP protocol constants' }
Amqp08 class >> accessRefused [

	^ 403
]

{ #category : #'AMQP methods' }
Amqp08 class >> accessRequestMethod [

	^ Amqp08AccessRequest
]

{ #category : #'AMQP methods' }
Amqp08 class >> accessRequestOkMethod [

	^ Amqp08AccessRequestOk
]

{ #category : #'AMQP methods' }
Amqp08 class >> basicAckMethod [

	^ Amqp08BasicAck
]

{ #category : #'AMQP methods' }
Amqp08 class >> basicCancelMethod [

	^ Amqp08BasicCancel
]

{ #category : #'AMQP methods' }
Amqp08 class >> basicCancelOkMethod [

	^ Amqp08BasicCancelOk
]

{ #category : #'AMQP methods' }
Amqp08 class >> basicConsumeMethod [

	^ Amqp08BasicConsume
]

{ #category : #'AMQP methods' }
Amqp08 class >> basicConsumeOkMethod [

	^ Amqp08BasicConsumeOk
]

{ #category : #'AMQP methods' }
Amqp08 class >> basicDeliverMethod [

	^ Amqp08BasicDeliver
]

{ #category : #'AMQP methods' }
Amqp08 class >> basicGetEmptyMethod [

	^ Amqp08BasicGetEmpty
]

{ #category : #'AMQP methods' }
Amqp08 class >> basicGetMethod [

	^ Amqp08BasicGet
]

{ #category : #'AMQP methods' }
Amqp08 class >> basicGetOkMethod [

	^ Amqp08BasicGetOk
]

{ #category : #'AMQP content properties' }
Amqp08 class >> basicPropertiesClass [

	^ Amqp08BasicProperties
]

{ #category : #'AMQP methods' }
Amqp08 class >> basicPublishMethod [

	^ Amqp08BasicPublish
]

{ #category : #'AMQP methods' }
Amqp08 class >> basicQosMethod [

	^ Amqp08BasicQos
]

{ #category : #'AMQP methods' }
Amqp08 class >> basicQosOkMethod [

	^ Amqp08BasicQosOk
]

{ #category : #'AMQP methods' }
Amqp08 class >> basicRecoverMethod [

	^ Amqp08BasicRecover
]

{ #category : #'AMQP methods' }
Amqp08 class >> basicRejectMethod [

	^ Amqp08BasicReject
]

{ #category : #'AMQP methods' }
Amqp08 class >> basicReturnMethod [

	^ Amqp08BasicReturn
]

{ #category : #'AMQP methods' }
Amqp08 class >> channelAlertMethod [

	^ Amqp08ChannelAlert
]

{ #category : #'AMQP methods' }
Amqp08 class >> channelCloseMethod [

	^ Amqp08ChannelClose
]

{ #category : #'AMQP methods' }
Amqp08 class >> channelCloseOkMethod [

	^ Amqp08ChannelCloseOk
]

{ #category : #'AMQP protocol constants' }
Amqp08 class >> channelError [

	^ 504
]

{ #category : #'AMQP methods' }
Amqp08 class >> channelFlowMethod [

	^ Amqp08ChannelFlow
]

{ #category : #'AMQP methods' }
Amqp08 class >> channelFlowOkMethod [

	^ Amqp08ChannelFlowOk
]

{ #category : #'AMQP methods' }
Amqp08 class >> channelOpenMethod [

	^ Amqp08ChannelOpen
]

{ #category : #'AMQP methods' }
Amqp08 class >> channelOpenOkMethod [

	^ Amqp08ChannelOpenOk
]

{ #category : #'AMQP protocol constants' }
Amqp08 class >> commandInvalid [

	^ 503
]

{ #category : #'AMQP methods' }
Amqp08 class >> connectionCloseMethod [

	^ Amqp08ConnectionClose
]

{ #category : #'AMQP methods' }
Amqp08 class >> connectionCloseOkMethod [

	^ Amqp08ConnectionCloseOk
]

{ #category : #'AMQP protocol constants' }
Amqp08 class >> connectionForced [

	^ 320
]

{ #category : #'AMQP methods' }
Amqp08 class >> connectionOpenMethod [

	^ Amqp08ConnectionOpen
]

{ #category : #'AMQP methods' }
Amqp08 class >> connectionOpenOkMethod [

	^ Amqp08ConnectionOpenOk
]

{ #category : #'AMQP methods' }
Amqp08 class >> connectionRedirectMethod [

	^ Amqp08ConnectionRedirect
]

{ #category : #'AMQP methods' }
Amqp08 class >> connectionSecureMethod [

	^ Amqp08ConnectionSecure
]

{ #category : #'AMQP methods' }
Amqp08 class >> connectionSecureOkMethod [

	^ Amqp08ConnectionSecureOk
]

{ #category : #'AMQP methods' }
Amqp08 class >> connectionStartMethod [

	^ Amqp08ConnectionStart
]

{ #category : #'AMQP methods' }
Amqp08 class >> connectionStartOkMethod [

	^ Amqp08ConnectionStartOk
]

{ #category : #'AMQP methods' }
Amqp08 class >> connectionTuneMethod [

	^ Amqp08ConnectionTune
]

{ #category : #'AMQP methods' }
Amqp08 class >> connectionTuneOkMethod [

	^ Amqp08ConnectionTuneOk
]

{ #category : #'AMQP protocol constants' }
Amqp08 class >> contentTooLarge [

	^ 311
]

{ #category : #'AMQP methods' }
Amqp08 class >> dtxSelectMethod [

	^ Amqp08DtxSelect
]

{ #category : #'AMQP methods' }
Amqp08 class >> dtxSelectOkMethod [

	^ Amqp08DtxSelectOk
]

{ #category : #'AMQP methods' }
Amqp08 class >> dtxStartMethod [

	^ Amqp08DtxStart
]

{ #category : #'AMQP methods' }
Amqp08 class >> dtxStartOkMethod [

	^ Amqp08DtxStartOk
]

{ #category : #'AMQP methods' }
Amqp08 class >> exchangeDeclareMethod [

	^ Amqp08ExchangeDeclare
]

{ #category : #'AMQP methods' }
Amqp08 class >> exchangeDeclareOkMethod [

	^ Amqp08ExchangeDeclareOk
]

{ #category : #'AMQP methods' }
Amqp08 class >> exchangeDeleteMethod [

	^ Amqp08ExchangeDelete
]

{ #category : #'AMQP methods' }
Amqp08 class >> exchangeDeleteOkMethod [

	^ Amqp08ExchangeDeleteOk
]

{ #category : #'AMQP methods' }
Amqp08 class >> fileAckMethod [

	^ Amqp08FileAck
]

{ #category : #'AMQP methods' }
Amqp08 class >> fileCancelMethod [

	^ Amqp08FileCancel
]

{ #category : #'AMQP methods' }
Amqp08 class >> fileCancelOkMethod [

	^ Amqp08FileCancelOk
]

{ #category : #'AMQP methods' }
Amqp08 class >> fileConsumeMethod [

	^ Amqp08FileConsume
]

{ #category : #'AMQP methods' }
Amqp08 class >> fileConsumeOkMethod [

	^ Amqp08FileConsumeOk
]

{ #category : #'AMQP methods' }
Amqp08 class >> fileDeliverMethod [

	^ Amqp08FileDeliver
]

{ #category : #'AMQP methods' }
Amqp08 class >> fileOpenMethod [

	^ Amqp08FileOpen
]

{ #category : #'AMQP methods' }
Amqp08 class >> fileOpenOkMethod [

	^ Amqp08FileOpenOk
]

{ #category : #'AMQP content properties' }
Amqp08 class >> filePropertiesClass [

	^ Amqp08FileProperties
]

{ #category : #'AMQP methods' }
Amqp08 class >> filePublishMethod [

	^ Amqp08FilePublish
]

{ #category : #'AMQP methods' }
Amqp08 class >> fileQosMethod [

	^ Amqp08FileQos
]

{ #category : #'AMQP methods' }
Amqp08 class >> fileQosOkMethod [

	^ Amqp08FileQosOk
]

{ #category : #'AMQP methods' }
Amqp08 class >> fileRejectMethod [

	^ Amqp08FileReject
]

{ #category : #'AMQP methods' }
Amqp08 class >> fileReturnMethod [

	^ Amqp08FileReturn
]

{ #category : #'AMQP methods' }
Amqp08 class >> fileStageMethod [

	^ Amqp08FileStage
]

{ #category : #'AMQP protocol constants' }
Amqp08 class >> frameBody [

	^ 3
]

{ #category : #'AMQP protocol constants' }
Amqp08 class >> frameEnd [

	^ 206
]

{ #category : #'AMQP protocol constants' }
Amqp08 class >> frameError [

	^ 501
]

{ #category : #'AMQP protocol constants' }
Amqp08 class >> frameHeader [

	^ 2
]

{ #category : #'AMQP protocol constants' }
Amqp08 class >> frameHeartbeat [

	^ 8
]

{ #category : #'AMQP protocol constants' }
Amqp08 class >> frameMethod [

	^ 1
]

{ #category : #'AMQP protocol constants' }
Amqp08 class >> frameMinSize [

	^ 4096
]

{ #category : #'AMQP protocol constants' }
Amqp08 class >> frameOobBody [

	^ 6
]

{ #category : #'AMQP protocol constants' }
Amqp08 class >> frameOobHeader [

	^ 5
]

{ #category : #'AMQP protocol constants' }
Amqp08 class >> frameOobMethod [

	^ 4
]

{ #category : #'AMQP protocol constants' }
Amqp08 class >> frameTrace [

	^ 7
]

{ #category : #'class initialization' }
Amqp08 class >> initialize [

	super initialize.
	classIds at: 70 put: Amqp08FileProperties.
	classIds at: 80 put: Amqp08StreamProperties.
	classIds at: 60 put: Amqp08BasicProperties.
	classIds at: 110 put: Amqp08TunnelProperties.
	methodIds at: 2621461 put: Amqp08ExchangeDeleteOk.
	methodIds at: 2621450 put: Amqp08ExchangeDeclare.
	methodIds at: 2621451 put: Amqp08ExchangeDeclareOk.
	methodIds at: 2621460 put: Amqp08ExchangeDelete.
	methodIds at: 3276821 put: Amqp08QueueBindOk.
	methodIds at: 3276841 put: Amqp08QueueDeleteOk.
	methodIds at: 3276820 put: Amqp08QueueBind.
	methodIds at: 3276840 put: Amqp08QueueDelete.
	methodIds at: 3276830 put: Amqp08QueuePurge.
	methodIds at: 3276810 put: Amqp08QueueDeclare.
	methodIds at: 3276811 put: Amqp08QueueDeclareOk.
	methodIds at: 3276831 put: Amqp08QueuePurgeOk.
	methodIds at: 1310731 put: Amqp08ChannelOpenOk.
	methodIds at: 1310741 put: Amqp08ChannelFlowOk.
	methodIds at: 1310750 put: Amqp08ChannelAlert.
	methodIds at: 1310730 put: Amqp08ChannelOpen.
	methodIds at: 1310761 put: Amqp08ChannelCloseOk.
	methodIds at: 1310740 put: Amqp08ChannelFlow.
	methodIds at: 1310760 put: Amqp08ChannelClose.
	methodIds at: 7864340 put: Amqp08TestString.
	methodIds at: 7864331 put: Amqp08TestIntegerOk.
	methodIds at: 7864360 put: Amqp08TestContent.
	methodIds at: 7864351 put: Amqp08TestTableOk.
	methodIds at: 7864361 put: Amqp08TestContentOk.
	methodIds at: 7864350 put: Amqp08TestTable.
	methodIds at: 7864341 put: Amqp08TestStringOk.
	methodIds at: 7864330 put: Amqp08TestInteger.
	methodIds at: 4587580 put: Amqp08FilePublish.
	methodIds at: 4587561 put: Amqp08FileOpenOk.
	methodIds at: 4587600 put: Amqp08FileDeliver.
	methodIds at: 4587610 put: Amqp08FileAck.
	methodIds at: 4587540 put: Amqp08FileConsume.
	methodIds at: 4587530 put: Amqp08FileQos.
	methodIds at: 4587570 put: Amqp08FileStage.
	methodIds at: 4587541 put: Amqp08FileConsumeOk.
	methodIds at: 4587590 put: Amqp08FileReturn.
	methodIds at: 4587560 put: Amqp08FileOpen.
	methodIds at: 4587620 put: Amqp08FileReject.
	methodIds at: 4587551 put: Amqp08FileCancelOk.
	methodIds at: 4587531 put: Amqp08FileQosOk.
	methodIds at: 4587550 put: Amqp08FileCancel.
	methodIds at: 5242920 put: Amqp08StreamPublish.
	methodIds at: 5242940 put: Amqp08StreamDeliver.
	methodIds at: 5242900 put: Amqp08StreamConsume.
	methodIds at: 5242890 put: Amqp08StreamQos.
	methodIds at: 5242901 put: Amqp08StreamConsumeOk.
	methodIds at: 5242930 put: Amqp08StreamReturn.
	methodIds at: 5242911 put: Amqp08StreamCancelOk.
	methodIds at: 5242891 put: Amqp08StreamQosOk.
	methodIds at: 5242910 put: Amqp08StreamCancel.
	methodIds at: 3932200 put: Amqp08BasicPublish.
	methodIds at: 3932220 put: Amqp08BasicDeliver.
	methodIds at: 3932230 put: Amqp08BasicGet.
	methodIds at: 3932231 put: Amqp08BasicGetOk.
	methodIds at: 3932240 put: Amqp08BasicAck.
	methodIds at: 3932180 put: Amqp08BasicConsume.
	methodIds at: 3932170 put: Amqp08BasicQos.
	methodIds at: 3932232 put: Amqp08BasicGetEmpty.
	methodIds at: 3932260 put: Amqp08BasicRecover.
	methodIds at: 3932181 put: Amqp08BasicConsumeOk.
	methodIds at: 3932210 put: Amqp08BasicReturn.
	methodIds at: 3932250 put: Amqp08BasicReject.
	methodIds at: 3932191 put: Amqp08BasicCancelOk.
	methodIds at: 3932171 put: Amqp08BasicQosOk.
	methodIds at: 3932190 put: Amqp08BasicCancel.
	methodIds at: 7208970 put: Amqp08TunnelRequest.
	methodIds at: 5898250 put: Amqp08TxSelect.
	methodIds at: 5898251 put: Amqp08TxSelectOk.
	methodIds at: 5898270 put: Amqp08TxRollback.
	methodIds at: 5898271 put: Amqp08TxRollbackOk.
	methodIds at: 5898261 put: Amqp08TxCommitOk.
	methodIds at: 5898260 put: Amqp08TxCommit.
	methodIds at: 655380 put: Amqp08ConnectionSecure.
	methodIds at: 655401 put: Amqp08ConnectionOpenOk.
	methodIds at: 655370 put: Amqp08ConnectionStart.
	methodIds at: 655371 put: Amqp08ConnectionStartOk.
	methodIds at: 655421 put: Amqp08ConnectionCloseOk.
	methodIds at: 655410 put: Amqp08ConnectionRedirect.
	methodIds at: 655420 put: Amqp08ConnectionClose.
	methodIds at: 655390 put: Amqp08ConnectionTune.
	methodIds at: 655391 put: Amqp08ConnectionTuneOk.
	methodIds at: 655381 put: Amqp08ConnectionSecureOk.
	methodIds at: 655400 put: Amqp08ConnectionOpen.
	methodIds at: 6553621 put: Amqp08DtxStartOk.
	methodIds at: 6553611 put: Amqp08DtxSelectOk.
	methodIds at: 6553620 put: Amqp08DtxStart.
	methodIds at: 6553610 put: Amqp08DtxSelect.
	methodIds at: 1966090 put: Amqp08AccessRequest.
	methodIds at: 1966091 put: Amqp08AccessRequestOk
]

{ #category : #'AMQP protocol constants' }
Amqp08 class >> internalError [

	^ 541
]

{ #category : #'AMQP protocol constants' }
Amqp08 class >> invalidPath [

	^ 402
]

{ #category : #'AMQP protocol' }
Amqp08 class >> isObsoleteProtocolVariant [

	^ true
]

{ #category : #'AMQP protocol' }
Amqp08 class >> majorVersion [

	^ 0
]

{ #category : #'AMQP protocol' }
Amqp08 class >> minorVersion [

	^ 8
]

{ #category : #'AMQP protocol constants' }
Amqp08 class >> notAllowed [

	^ 530
]

{ #category : #'AMQP protocol constants' }
Amqp08 class >> notDelivered [

	^ 310
]

{ #category : #'AMQP protocol constants' }
Amqp08 class >> notFound [

	^ 404
]

{ #category : #'AMQP protocol constants' }
Amqp08 class >> notImplemented [

	^ 540
]

{ #category : #'AMQP protocol' }
Amqp08 class >> portNumber [

	^ 5672
]

{ #category : #'AMQP methods' }
Amqp08 class >> queueBindMethod [

	^ Amqp08QueueBind
]

{ #category : #'AMQP methods' }
Amqp08 class >> queueBindOkMethod [

	^ Amqp08QueueBindOk
]

{ #category : #'AMQP methods' }
Amqp08 class >> queueDeclareMethod [

	^ Amqp08QueueDeclare
]

{ #category : #'AMQP methods' }
Amqp08 class >> queueDeclareOkMethod [

	^ Amqp08QueueDeclareOk
]

{ #category : #'AMQP methods' }
Amqp08 class >> queueDeleteMethod [

	^ Amqp08QueueDelete
]

{ #category : #'AMQP methods' }
Amqp08 class >> queueDeleteOkMethod [

	^ Amqp08QueueDeleteOk
]

{ #category : #'AMQP methods' }
Amqp08 class >> queuePurgeMethod [

	^ Amqp08QueuePurge
]

{ #category : #'AMQP methods' }
Amqp08 class >> queuePurgeOkMethod [

	^ Amqp08QueuePurgeOk
]

{ #category : #'AMQP protocol constants' }
Amqp08 class >> replySuccess [

	^ 200
]

{ #category : #'AMQP protocol constants' }
Amqp08 class >> resourceError [

	^ 506
]

{ #category : #'AMQP protocol constants' }
Amqp08 class >> resourceLocked [

	^ 405
]

{ #category : #'AMQP protocol' }
Amqp08 class >> revision [

	^ 0
]

{ #category : #'AMQP methods' }
Amqp08 class >> streamCancelMethod [

	^ Amqp08StreamCancel
]

{ #category : #'AMQP methods' }
Amqp08 class >> streamCancelOkMethod [

	^ Amqp08StreamCancelOk
]

{ #category : #'AMQP methods' }
Amqp08 class >> streamConsumeMethod [

	^ Amqp08StreamConsume
]

{ #category : #'AMQP methods' }
Amqp08 class >> streamConsumeOkMethod [

	^ Amqp08StreamConsumeOk
]

{ #category : #'AMQP methods' }
Amqp08 class >> streamDeliverMethod [

	^ Amqp08StreamDeliver
]

{ #category : #'AMQP content properties' }
Amqp08 class >> streamPropertiesClass [

	^ Amqp08StreamProperties
]

{ #category : #'AMQP methods' }
Amqp08 class >> streamPublishMethod [

	^ Amqp08StreamPublish
]

{ #category : #'AMQP methods' }
Amqp08 class >> streamQosMethod [

	^ Amqp08StreamQos
]

{ #category : #'AMQP methods' }
Amqp08 class >> streamQosOkMethod [

	^ Amqp08StreamQosOk
]

{ #category : #'AMQP methods' }
Amqp08 class >> streamReturnMethod [

	^ Amqp08StreamReturn
]

{ #category : #'AMQP protocol constants' }
Amqp08 class >> syntaxError [

	^ 502
]

{ #category : #'AMQP methods' }
Amqp08 class >> testContentMethod [

	^ Amqp08TestContent
]

{ #category : #'AMQP methods' }
Amqp08 class >> testContentOkMethod [

	^ Amqp08TestContentOk
]

{ #category : #'AMQP methods' }
Amqp08 class >> testIntegerMethod [

	^ Amqp08TestInteger
]

{ #category : #'AMQP methods' }
Amqp08 class >> testIntegerOkMethod [

	^ Amqp08TestIntegerOk
]

{ #category : #'AMQP methods' }
Amqp08 class >> testStringMethod [

	^ Amqp08TestString
]

{ #category : #'AMQP methods' }
Amqp08 class >> testStringOkMethod [

	^ Amqp08TestStringOk
]

{ #category : #'AMQP methods' }
Amqp08 class >> testTableMethod [

	^ Amqp08TestTable
]

{ #category : #'AMQP methods' }
Amqp08 class >> testTableOkMethod [

	^ Amqp08TestTableOk
]

{ #category : #'AMQP content properties' }
Amqp08 class >> tunnelPropertiesClass [

	^ Amqp08TunnelProperties
]

{ #category : #'AMQP methods' }
Amqp08 class >> tunnelRequestMethod [

	^ Amqp08TunnelRequest
]

{ #category : #'AMQP methods' }
Amqp08 class >> txCommitMethod [

	^ Amqp08TxCommit
]

{ #category : #'AMQP methods' }
Amqp08 class >> txCommitOkMethod [

	^ Amqp08TxCommitOk
]

{ #category : #'AMQP methods' }
Amqp08 class >> txRollbackMethod [

	^ Amqp08TxRollback
]

{ #category : #'AMQP methods' }
Amqp08 class >> txRollbackOkMethod [

	^ Amqp08TxRollbackOk
]

{ #category : #'AMQP methods' }
Amqp08 class >> txSelectMethod [

	^ Amqp08TxSelect
]

{ #category : #'AMQP methods' }
Amqp08 class >> txSelectOkMethod [

	^ Amqp08TxSelectOk
]
