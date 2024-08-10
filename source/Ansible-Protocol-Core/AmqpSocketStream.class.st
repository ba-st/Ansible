Class {
	#name : 'AmqpSocketStream',
	#superclass : 'SocketStream',
	#category : 'Ansible-Protocol-Core',
	#package : 'Ansible-Protocol-Core'
}

{ #category : 'control' }
AmqpSocketStream >> flush [
	"If the other end is connected and we have something
	to send, then we send it and reset the outBuffer.
	If the other end is closed and we are signaling errors, do so."

	(outNextToWrite > 1 and: [ socket isOtherEndClosed not ]) ifTrue: [
		[ socket sendData: outBuffer count: outNextToWrite - 1 ]
			on: NetworkError
			do: [ :ex |
				shouldSignal
					ifTrue: [ ex pass ]
					ifFalse: [ "swallow" ] ].
		outNextToWrite := 1 ]
]
