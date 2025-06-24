Class {
	#name : 'AmqpCommandBuilder',
	#superclass : 'Object',
	#instVars : [
		'bodyFrames',
		'remainingBytes',
		'methodOptional',
		'headerOptional'
	],
	#category : 'Ansible-Protocol-Core',
	#package : 'Ansible-Protocol-Core'
}

{ #category : 'initialization' }
AmqpCommandBuilder >> appendBodyFrame: aFrame [

  ( aFrame isKindOf: AmqpContentBodyFrame ) ifFalse: [
      AmqpProtocolSyntaxError signal: 'Unexpected frame kind' ].

  remainingBytes := remainingBytes - aFrame fragment size.
  bodyFrames nextPutAll: aFrame fragment
]

{ #category : 'initialization' }
AmqpCommandBuilder >> initialize [

  methodOptional := Optional unused.
  headerOptional := Optional unused.
  bodyFrames := WriteStream on: ByteArray new.
  remainingBytes := 0
]

{ #category : 'initialization' }
AmqpCommandBuilder >> setHeaderFrame: aFrame [

  ( aFrame isKindOf: AmqpContentHeaderFrame ) ifFalse: [
      AmqpProtocolSyntaxError signal: 'Unexpected frame kind' ].

  headerOptional := Optional containing: aFrame.
  remainingBytes := aFrame bodySize
]

{ #category : 'initialization' }
AmqpCommandBuilder >> setMethodFrame: aFrame [

  ( aFrame isKindOf: AmqpMethodFrame ) ifFalse: [
      AmqpProtocolSyntaxError signal:
        ( 'Expecting a AmqpMethodFrame but received <1p>' expandMacrosWith: aFrame )
    ].

  methodOptional := Optional containing: aFrame method
]

{ #category : 'initialization' }
AmqpCommandBuilder >> withCommandDo: aBlock ifUncompletedDo: anUncompletedBlock [

  methodOptional
    withContentDo: [ :method |
        | command |
        command := AmqpCommand new.
        command method: method.

        method hasContents then: [
            headerOptional
              withContentDo: [ :header |
                  remainingBytes > 0 then: [ ^ anUncompletedBlock value ].
                  remainingBytes < 0 ifTrue: [
                      AmqpProtocolSyntaxError signal: 'Received body overrun' ].

                  command
                    properties: header properties;
                    body: bodyFrames contents;
                    yourself
                ]
              ifUnused: [ ^ anUncompletedBlock value ]
          ].
        aBlock value: command
      ]
    ifUnused: anUncompletedBlock
]
