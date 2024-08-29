Extension { #name : 'Socket' }

{ #category : '*Ansible-Pharo-Pending-Patches' }
Socket >> connectTo: hostAddress port: port waitForConnectionFor: timeout [
	"Initiate a connection to the given port at the given host
	address. Waits until the connection is established or time outs."

	self connectNonBlockingTo: hostAddress port: port.
	self
		waitForConnectionFor: timeout
		ifClosed: [
			ConnectionClosed signal: 'Connection aborted to '
				, (NetNameResolver stringFromAddress: hostAddress) , ':'
				, port asString ]
		ifTimedOut: [
			ConnectionTimedOut signal: 'Cannot connect to '
				, (NetNameResolver stringFromAddress: hostAddress) , ':'
				, port asString ]
]

{ #category : '*Ansible-Pharo-Pending-Patches' }
Socket >> destroy [
	"Destroy this socket. Its connection, if any, is aborted and its resources are freed.
	Any processes waiting on the socket are freed immediately, but it is up to them to
	recognize that the socket has been destroyed.
	Do nothing if the socket has already been destroyed (i.e., if its socketHandle is nil)."

	socketHandle ifNotNil: [
		| saveSemaphores |
		self isValid ifTrue: [ self primSocketDestroy: socketHandle ].
		socketHandle := nil.
		Smalltalk unregisterExternalObject: semaphore.
		Smalltalk unregisterExternalObject: readSemaphore.
		Smalltalk unregisterExternalObject: writeSemaphore.
		"Stash the semaphores and nil them before signaling to make sure
		no caller gets a chance to wait on them again and block forever."
		saveSemaphores := {
			                  semaphore.
			                  readSemaphore.
			                  writeSemaphore }.
		semaphore := readSemaphore := writeSemaphore := nil.
		"A single #signal should be sufficient, as multiple processes trying to
		read or write at once will result in undefined behavior anyway as their
		data gets all mixed up together."
		saveSemaphores do: [ :each | each signal ].
		self unregister ]
]

{ #category : '*Ansible-Pharo-Pending-Patches' }
Socket >> retryIfWaitingForConnection: aBlock [

	^ aBlock
		  on: ExpectedSocketFailure 
		  do: [ :e |
			  self isWaitingForConnection
				  ifTrue: [
					  self
						  waitForConnectionFor: Socket standardTimeout
						  ifClosed: nil
						  ifTimedOut: nil.
					  aBlock value ]
				  ifFalse: [ e pass ] ]
]

{ #category : '*Ansible-Pharo-Pending-Patches' }
Socket >> socketError [

	^ socketHandle ifNotNil: [ self primSocketError: socketHandle ]
]

{ #category : '*Ansible-Pharo-Pending-Patches' }
Socket >> socketErrorMessage [

	^ self socketError
		  ifNil: [ 'Socket destroyed, cannot retrieve error message' ]
		  ifNotNil: [ :err |
			  [ OSPlatform current getErrorMessage: err ]
				  on: Error
				  do: [ 'Error code: ' , err printString ] ]
]

{ #category : '*Ansible-Pharo-Pending-Patches' }
Socket >> waitForAcceptFor: timeout ifClosed: closedBlock ifTimedOut: timeoutBlock [
	"Wait and accept an incoming connection"

	self
		waitForConnectionFor: timeout
		ifClosed: [ ^ closedBlock value ]
		ifTimedOut: [ ^ timeoutBlock value ].
	^ self accept
]

{ #category : '*Ansible-Pharo-Pending-Patches' }
Socket >> waitForConnectionFor: timeout [
	"Wait up until the given deadline for a connection to be established. Return true if it is established by the deadline, false if not."

	^ self
		  waitForConnectionFor: timeout
		  ifClosed: [
			  ConnectionClosed signal: (socketHandle
					   ifNil: [ 'Socket destroyed while connecting' ]
					   ifNotNil: [
					   'Connection aborted or failed: ' , self socketErrorMessage ]) ]
		  ifTimedOut: [
			  ConnectionTimedOut signal:
				  'Failed to connect in ' , timeout asString , ' seconds' ]
]

{ #category : '*Ansible-Pharo-Pending-Patches' }
Socket >> waitForConnectionFor: timeout ifClosed: closedBlock ifTimedOut: timeoutBlock [
	"Wait up until the given deadline for a connection to be established.
	Evaluate closedBlock if the connection is closed locally,
	or timeoutBlock if the deadline expires.
	
	We should separately detect the case of a connection being refused here as well."

	| startTime msecsDelta msecsElapsed status |
	startTime := Time millisecondClockValue.
	msecsDelta := (timeout * 1000) truncated.

	[
	status := self primSocketConnectionStatus: socketHandle.
	status == WaitingForConnection and: [
		(msecsElapsed := Time millisecondsSince: startTime) < msecsDelta ] ]
		whileTrue: [ semaphore waitTimeoutMilliseconds: msecsDelta - msecsElapsed ].

	status == WaitingForConnection ifTrue: [ ^ timeoutBlock value ].
	status == Connected ifFalse: [ ^ closedBlock value ]
]

{ #category : '*Ansible-Pharo-Pending-Patches' }
Socket >> waitForDataFor: timeout ifClosed: closedBlock ifTimedOut: timedOutBlock [
	"Wait for the given nr of seconds for data to arrive.
	If it does not, execute <timedOutBlock>. If the connection
	is closed before any data arrives, execute <closedBlock>."

	| startTime msecsDelta msecsElapsed |
	startTime := Time millisecondClockValue.
	msecsDelta := (timeout * 1000) truncated.
	[ self dataAvailable ] whileFalse: [
		self isConnected ifFalse: [ ^ closedBlock value ].
		(msecsElapsed := Time millisecondsSince: startTime) < msecsDelta
			ifFalse: [ ^ timedOutBlock value ].
		readSemaphore waitTimeoutMilliseconds: msecsDelta - msecsElapsed ]
]
