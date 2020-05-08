Class {
	#name : #Amqp08TestIntegerOk,
	#superclass : #AmqpProtocolMethod,
	#instVars : [
		'result'
	],
	#category : #'Ansible-Protocol-08'
}

{ #category : #'AMQP codec' }
Amqp08TestIntegerOk >> acceptableResponseClasses [

	^ {}
]

{ #category : #'AMQP codec' }
Amqp08TestIntegerOk >> codecMethodId [

	^ 7864331
]

{ #category : #'AMQP codec' }
Amqp08TestIntegerOk >> decodeFrom: codec [

	| bitBuffer |

	result := codec nextLonglong
]

{ #category : #'AMQP codec' }
Amqp08TestIntegerOk >> encodeOn: codec [

	| bitBuffer |

	codec nextLonglongPut: result
]

{ #category : #'AMQP codec' }
Amqp08TestIntegerOk >> hasContents [

	^ false
]

{ #category : #accessing }
Amqp08TestIntegerOk >> result [

	^ result
]

{ #category : #accessing }
Amqp08TestIntegerOk >> result: aValue [

	result := aValue
]
