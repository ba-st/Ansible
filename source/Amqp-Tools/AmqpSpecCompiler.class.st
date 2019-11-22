Class {
	#name : #AmqpSpecCompiler,
	#superclass : #Object,
	#instVars : [
		'spec',
		'prefix',
		'definitionCategory'
	],
	#category : #'Amqp-Tools'
}

{ #category : #'as yet unclassified' }
AmqpSpecCompiler class >> joinPieces: strings [

	| s |

	s := WriteStream with: ''.
	strings do: [ :each | s nextPutAll: each ].
	^ s contents
]

{ #category : #'as yet unclassified' }
AmqpSpecCompiler class >> methodNameFor: aString [

	^ aString asMethodName
]

{ #category : #accessing }
AmqpSpecCompiler >> acceptableResponseClassesSource: methodDefinition [

	^ String
		streamContents: [ :stream | 
			stream
				nextPutAll:
					'acceptableResponseClasses
	^ {
'.
			methodDefinition responses
				do: [ :response | 
					stream
						tab;
						nextPutAll: prefix;
						nextPutAll: methodDefinition classDef name asClassName;
						nextPutAll: response asClassName;
						nextPut: $.;
						cr
					].
			stream nextPutAll: '	}'
			]
]

{ #category : #accessing }
AmqpSpecCompiler >> classNameFor: aString [

	^ ( String
		streamContents: [ :stream | 
			stream nextPutAll: prefix.
			aString substrings do: [ :substring | stream nextPutAll: substring capitalized ]
			] ) asSymbol
]

{ #category : #accessing }
AmqpSpecCompiler >> decodeFieldSource: aFieldDefinition [

	^ ( aFieldDefinition isReserved
		ifTrue: [ '' ]
		ifFalse: [ '' , aFieldDefinition asVariableName , ' := ' ] ) , 'codec next' , aFieldDefinition domainName , '.'
]

{ #category : #accessing }
AmqpSpecCompiler >> decodeMethodSource: aMethodDefinition [

	| s bitindex |

	s := WriteStream with: 'decodeFrom: codec
	| bitBuffer |
'.
	bitindex := nil.
	aMethodDefinition fields
		do: [ :f | 
			f domain = 'bit'
				ifTrue: [ bitindex ifNil: [ bitindex := 0 ].
					bitindex >= 8
						ifTrue: [ bitindex := 0 ].
					bitindex = 0
						ifTrue: [ s
								nextPutAll: '	bitBuffer := codec nextOctet.';
								cr
							].
					f isReserved
						ifFalse: [ s
								nextPutAll: '	' , f methodName , ' := (bitBuffer bitAnd: ' , ( 1 bitShift: bitindex ) asString , ') ~= 0.'.
							s cr
							].
					bitindex := bitindex + 1
					]
				ifFalse: [ bitindex := nil.
					s
						nextPutAll: '	' , ( self decodeFieldSource: f );
						cr
					]
			].
	^ s contents
]

{ #category : #accessing }
AmqpSpecCompiler >> decodePropertiesSource: c [

	| s |

	s := WriteStream with: 'decodeFrom: codec
	| qFlags |
	qFlags := self decodeFlagsFrom: codec.
'.
	c
		propertiesAndMasksDo: [ :f :bitMask | 
			f domain = 'bit'
				ifTrue: [ f isReserved
						ifFalse: [ s
								nextPutAll: '	' , f methodName , ' := (qFlags bitAnd: ' , bitMask asString , ') ~= 0.';
								cr
							]
					]
				ifFalse: [ s nextPutAll: '	(qFlags bitAnd: ' , bitMask asString , ') = 0 ifTrue: ['.
					f isReserved
						ifFalse: [ s nextPutAll: f methodName , ' := nil' ].
					s
						nextPutAll: '] ifFalse: [' , ( self decodeFieldSource: f ) , '].';
						cr
					]
			].
	^ s contents
]

{ #category : #accessing }
AmqpSpecCompiler >> definitionCategory [

	^ definitionCategory
]

{ #category : #accessing }
AmqpSpecCompiler >> definitionCategory: anObject [

	definitionCategory := anObject
]

{ #category : #accessing }
AmqpSpecCompiler >> encodeFieldSource: f [

	^ 'codec next' , f domainName , 'Put: '
		,
			( f isReserved
				ifTrue: [ self reservedValueForDomain: f domain ]
				ifFalse: [ f methodName ] ) , '.'
]

{ #category : #accessing }
AmqpSpecCompiler >> encodeMethodSource: m [

	| s bitindex finishbits |

	s := WriteStream with: 'encodeOn: codec
	| bitBuffer |
'.

	bitindex := nil.
	finishbits := [ bitindex notNil
		ifTrue: [ s
				nextPutAll: '	codec nextOctetPut: bitBuffer.';
				cr
			]
	].

	m fields
		do: [ :f | 
			f domain = 'bit'
				ifTrue: [ bitindex
						ifNil: [ bitindex := 0.
							s
								nextPutAll: '	bitBuffer := 0.';
								cr
							].
					bitindex >= 8
						ifTrue: [ finishbits value.
							s
								nextPutAll: '	bitBuffer := 0.';
								cr.
							bitindex := 0
							].
					f isReserved
						ifFalse: [ s
								nextPutAll:
									'	(' , f methodName , ' ifNil: [false])' , ' ifTrue: [bitBuffer := bitBuffer bitOr: '
										, ( 1 bitShift: bitindex ) asString , '].'.
							s cr
							].
					bitindex := bitindex + 1
					]
				ifFalse: [ finishbits value.
					bitindex := nil.
					s
						nextPutAll: '	' , ( self encodeFieldSource: f );
						cr
					]
			].
	finishbits value.
	^ s contents
]

{ #category : #accessing }
AmqpSpecCompiler >> encodePropertiesSource: aClassDefinition [

	| source |

	source := WriteStream with: 'encodeOn: codec
	| qFlags |
	qFlags := 0.

'.
	aClassDefinition
		propertiesAndMasksDo: [ :property :bitMask | 
			property isReserved
				ifFalse: [ property domain = 'bit'
						ifTrue: [ source
								nextPutAll: '	' , property methodName , ' ifTrue: [qFlags := qFlags bitOr: ' , bitMask asString , '].';
								cr
							]
						ifFalse: [ source
								nextPutAll: '	' , property methodName , ' isNil ifFalse: [qFlags := qFlags bitOr: ' , bitMask asString , '].';
								cr
							]
					]
			].
	source
		cr;
		nextPutAll: '	self encodeFlags: qFlags on: codec.';
		cr;
		cr.
	aClassDefinition
		propertiesAndMasksDo: [ :f :bitMask | 
			f isReserved
				ifFalse: [ f domain = 'bit'
						ifFalse: [ source
								nextPutAll: '	' , f methodName , ' isNil ifFalse: [' , ( self encodeFieldSource: f ) , '].';
								cr
							]
					]
			].
	^ source contents
]

{ #category : #accessing }
AmqpSpecCompiler >> generateClass: aClassDefinition [

	self generateContentProperties: aClassDefinition.
	aClassDefinition methods valuesDo: [ :method | self generateMethod: method ]
]

{ #category : #accessing }
AmqpSpecCompiler >> generateContentProperties: aClassDefinition [

	| class fieldDefinitions |

	aClassDefinition hasProperties
		ifFalse: [ ^ self ].
	fieldDefinitions := aClassDefinition contentProperties reject: [ :each | each isReserved ].
	class := self
		subclassOf: AmqpProtocolProperties
		named: aClassDefinition propertiesName
		instanceVariables: ( fieldDefinitions collect: [ :fieldDefinition | fieldDefinition methodName ] ).
	fieldDefinitions
		do: [ :fieldDefinition | 
			class
				compile: fieldDefinition methodName , ' ^ ' , fieldDefinition methodName
				classified: 'accessing'.
			class
				compile: fieldDefinition methodName , ': aValue ' , fieldDefinition methodName , ' := aValue.'
				classified: 'accessing'
			].
	class compile: 'codecClassId ^ ' , aClassDefinition index asString classified: 'AMQP codec'.
	class compile: ( self decodePropertiesSource: aClassDefinition ) classified: 'AMQP codec'.
	class compile: ( self encodePropertiesSource: aClassDefinition ) classified: 'AMQP codec'
]

{ #category : #accessing }
AmqpSpecCompiler >> generateEverything [

	| protocol class |

	protocol := self subclassOf: AmqpProtocol named: prefix instanceVariables: #().
	class := protocol class.

	class compile: 'portNumber ^' , spec portNumber asString classified: 'AMQP protocol'.
	class compile: 'majorVersion ^' , spec majorVersion asString classified: 'AMQP protocol'.
	class compile: 'minorVersion ^' , spec minorVersion asString classified: 'AMQP protocol'.
	class compile: 'revision ^' , spec revision asString classified: 'AMQP protocol'.
	class
		compile: 'isObsoleteProtocolVariant ^' , spec isObsoleteProtocolVariant asString
		classified: 'AMQP protocol'.

	spec constants
		keysAndValuesDo: [ :name :value | 
			class
				compile: ( name asMethodName ) , ' ^' , value asString
				classified: 'AMQP protocol constants'
			].

	spec classDefinitions valuesDo: [ :def | self generateClass: def ].
	class compile: self initializerSource classified: 'class initialization'.

	spec allMethods
		do: [ :def | 
			class
				compile:
					( self class methodNameFor: def classDef name , ' ' , def name , ' method' ) , ' ^ '
						, ( self classNameFor: def classDef name , ' ' , def name )
				classified: 'AMQP methods'
			].
	spec classDefinitions
		valuesDo: [ :classDefinition | 
			classDefinition hasProperties
				ifTrue: [ class
						compile:
							( self class methodNameFor: classDefinition propertiesName , ' class' ) , ' ^ '
								, ( self classNameFor: classDefinition propertiesName )
						classified: 'AMQP content properties'
					]
			]
]

{ #category : #accessing }
AmqpSpecCompiler >> generateMethod: methodDefinition [

	| class fieldDefinitions |

	fieldDefinitions := methodDefinition fields
		reject: [ :fieldDefinition | fieldDefinition isReserved ].

	class := self
		subclassOf: AmqpProtocolMethod
		named: prefix , methodDefinition classDef name asClassName , methodDefinition name asClassName
		instanceVariables: ( fieldDefinitions collect: #methodName ).

	fieldDefinitions
		do: [ :fieldDefinition | 
			class
				compile: fieldDefinition methodName , ' ^ ' , fieldDefinition methodName
				classified: 'accessing'.
			class
				compile: fieldDefinition methodName , ': aValue ' , fieldDefinition methodName , ' := aValue.'
				classified: 'accessing'
			].
	class compile: 'codecMethodId ^ ' , methodDefinition methodId asString classified: 'AMQP codec'.
	class compile: 'hasContents ^ ' , methodDefinition hasContents asString classified: 'AMQP codec'.
	class compile: ( self acceptableResponseClassesSource: methodDefinition ) classified: 'AMQP codec'.
	class compile: ( self decodeMethodSource: methodDefinition ) classified: 'AMQP codec'.
	class compile: ( self encodeMethodSource: methodDefinition ) classified: 'AMQP codec'
]

{ #category : #accessing }
AmqpSpecCompiler >> initializerSource [

	^ String
		streamContents: [ :stream | 
			stream
				nextPutAll:
					'initialize

	super initialize.
'.

			spec classDefinitions
				valuesDo: [ :classDefinition | 
					classDefinition hasProperties
						ifTrue: [ stream
								nextPutAll: '	classIds at: ';
								nextPutAll: classDefinition index asString;
								nextPutAll: ' put: ';
								nextPutAll: ( self classNameFor: classDefinition propertiesName );
								nextPut: $.;
								nextPut: Character cr
							]
					].
				
			spec allMethods
				do: [ :each | 
					stream
						nextPutAll: '	methodIds at: ';
						nextPutAll: each methodId asString;
						nextPutAll: ' put: ';
						nextPutAll: ( self classNameFor: each classDef name , ' ' , each name );
						nextPut: $.;
						nextPut: Character cr
					]
			]
]

{ #category : #accessing }
AmqpSpecCompiler >> prefix [

	^ prefix
]

{ #category : #accessing }
AmqpSpecCompiler >> reservedValueForDomain: domain [

	domain = 'octet'
		ifTrue: [ ^ '0' ].
	domain = 'short'
		ifTrue: [ ^ '0' ].
	domain = 'long'
		ifTrue: [ ^ '0' ].
	domain = 'longlong'
		ifTrue: [ ^ '0' ].
	^ 'nil'
]

{ #category : #accessing }
AmqpSpecCompiler >> spec [

	^ spec
]

{ #category : #accessing }
AmqpSpecCompiler >> spec: anObject [

	spec := anObject.
	definitionCategory := 'Amqp-Protocol-' , spec versionString.
	prefix := 'Amqp' , spec versionString
]

{ #category : #accessing }
AmqpSpecCompiler >> subclassOf: aSuperClass named: aClassName instanceVariables: aCollection [

	| instanceVariableNames |

	instanceVariableNames := String
		streamContents: [ :stream | 
			aCollection
				do: [ :instanceVariableName | stream nextPutAll: instanceVariableName ]
				separatedBy: [ stream space ]
			].
		
	^ aSuperClass
		subclass: aClassName
		instanceVariableNames: instanceVariableNames
		classVariableNames: ''
		package: definitionCategory
]

{ #category : #accessing }
AmqpSpecCompiler >> wipePackage [

	( self confirm: 'Are you sure you want to erase all classes in package ' , definitionCategory , '?' )
		ifFalse: [ ^ self ].
	( Class allSubInstances select: [ :each | each category = definitionCategory ] )
		do: [ :each | each removeFromSystem ]
]
