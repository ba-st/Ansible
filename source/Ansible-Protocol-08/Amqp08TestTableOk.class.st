Class {
	#name : #Amqp08TestTableOk,
	#superclass : #AmqpProtocolMethod,
	#instVars : [
		'integerResult',
		'stringResult'
	],
	#category : #'Ansible-Protocol-08'
}

{ #category : #'AMQP codec' }
Amqp08TestTableOk >> acceptableResponseClasses [

	^ {}
]

{ #category : #'AMQP codec' }
Amqp08TestTableOk >> codecMethodId [

	^ 7864351
]

{ #category : #'AMQP codec' }
Amqp08TestTableOk >> decodeFrom: codec [

	| bitBuffer |

	integerResult := codec nextLonglong.
	stringResult := codec nextLongstr
]

{ #category : #'AMQP codec' }
Amqp08TestTableOk >> encodeOn: codec [

	| bitBuffer |

	codec nextLonglongPut: integerResult.
	codec nextLongstrPut: stringResult
]

{ #category : #'AMQP codec' }
Amqp08TestTableOk >> hasContents [

	^ false
]

{ #category : #accessing }
Amqp08TestTableOk >> integerResult [

	^ integerResult
]

{ #category : #accessing }
Amqp08TestTableOk >> integerResult: aValue [

	integerResult := aValue
]

{ #category : #accessing }
Amqp08TestTableOk >> stringResult [

	^ stringResult
]

{ #category : #accessing }
Amqp08TestTableOk >> stringResult: aValue [

	stringResult := aValue
]
