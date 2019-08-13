Class {
	#name : #Amqp08TestTable,
	#superclass : #AmqpProtocolMethod,
	#instVars : [
		'table',
		'integerOp',
		'stringOp'
	],
	#category : #'Amqp-Protocol-08'
}

{ #category : #'AMQP codec' }
Amqp08TestTable >> acceptableResponseClasses [

	^ {Amqp08TestTableOk}
]

{ #category : #'AMQP codec' }
Amqp08TestTable >> codecMethodId [

	^ 7864350
]

{ #category : #'AMQP codec' }
Amqp08TestTable >> decodeFrom: codec [

	| bitBuffer |

	table := codec nextTable.
	integerOp := codec nextOctet.
	stringOp := codec nextOctet
]

{ #category : #'AMQP codec' }
Amqp08TestTable >> encodeOn: codec [

	| bitBuffer |

	codec nextTablePut: table.
	codec nextOctetPut: integerOp.
	codec nextOctetPut: stringOp
]

{ #category : #'AMQP codec' }
Amqp08TestTable >> hasContents [

	^ false
]

{ #category : #accessing }
Amqp08TestTable >> integerOp [

	^ integerOp
]

{ #category : #accessing }
Amqp08TestTable >> integerOp: aValue [

	integerOp := aValue
]

{ #category : #accessing }
Amqp08TestTable >> stringOp [

	^ stringOp
]

{ #category : #accessing }
Amqp08TestTable >> stringOp: aValue [

	stringOp := aValue
]

{ #category : #accessing }
Amqp08TestTable >> table [

	^ table
]

{ #category : #accessing }
Amqp08TestTable >> table: aValue [

	table := aValue
]
