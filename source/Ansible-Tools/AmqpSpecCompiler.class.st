Class {
	#name : #AmqpSpecCompiler,
	#superclass : #Object,
	#instVars : [
		'spec',
		'prefix',
		'definitionCategory'
	],
	#category : #'Ansible-Tools'
}

{ #category : #accessing }
AmqpSpecCompiler >> acceptableResponseClassesSource: methodDefinition [

	^ String
		streamContents: [ :stream | 
			stream
				nextPutAll: 'acceptableResponseClasses';
				space;
				nextPut: $^.

			methodDefinition responses
				ifEmpty: [ stream nextPutAll: '#()' ]
				ifNotEmpty: [ :responses | 
					stream nextPutAll: 'Array'.

					responses
						do: [ :response | 
							stream
								space;
								nextPutAll: 'with:';
								nextPutAll: prefix;
								nextPutAll: methodDefinition classDef name upperCamelCased;
								nextPutAll: response upperCamelCased
							]
					]
			]
]

{ #category : #'code generation' }
AmqpSpecCompiler >> applyFormatting [

	( RBPackageEnvironment packageName: definitionCategory )
		classesDo: [ :class | 
			class
				methodsDo: [ :method | 
					| formattedCode |

					formattedCode := BIConfigurableFormatter format: method ast.
					class compile: formattedCode
					]
			]
]

{ #category : #accessing }
AmqpSpecCompiler >> decodeFieldSource: aFieldDefinition [

	^ ( aFieldDefinition isReserved
		ifTrue: [ '' ]
		ifFalse: [ '' , aFieldDefinition name lowerCamelCased , ' := ' ] ) , 'codec next'
		, aFieldDefinition domainType capitalized , '.'
]

{ #category : #accessing }
AmqpSpecCompiler >> decodeMethodSource: aMethodDefinition [

	^ String
		streamContents: [ :stream | 
			| bitindex |

			stream
				nextPutAll: 'decodeFrom: codec';
				cr.

			aMethodDefinition fields
				detect: [ :fieldDefinition | fieldDefinition domainType = 'bit' ]
				ifFound: [ stream
						nextPutAll: '| bitBuffer |';
						cr
					].

			bitindex := nil.
			aMethodDefinition fields
				do: [ :fieldDefinition | 
					fieldDefinition domainType = 'bit'
						ifTrue: [ bitindex ifNil: [ bitindex := 0 ].
							bitindex >= 8
								ifTrue: [ bitindex := 0 ].
							bitindex = 0
								ifTrue: [ stream
										nextPutAll: 'bitBuffer := codec nextOctet.';
										cr
									].
							fieldDefinition isReserved
								ifFalse: [ stream
										nextPutAll: fieldDefinition name lowerCamelCased;
										nextPutAll: (' := (bitBuffer bitAnd: <1p>) ~= 0.' expandMacrosWith: ( 1 bitShift: bitindex ) );
										cr
									].
							bitindex := bitindex + 1
							]
						ifFalse: [ bitindex := nil.
							stream
								nextPutAll: ( self decodeFieldSource: fieldDefinition );
								cr
							]
					]
			]
]

{ #category : #accessing }
AmqpSpecCompiler >> decodePropertiesSource: aClassDefinition [

	| s |

	s := WriteStream with: 'decodeFrom: codec
	| qFlags |
	qFlags := self decodeFlagsFrom: codec.
'.
	aClassDefinition
		propertiesAndMasksDo: [ :fieldDefinition :bitMask | 
			fieldDefinition domainType = 'bit'
				ifTrue: [ fieldDefinition isReserved
						ifFalse: [ s
								nextPutAll: '	' , fieldDefinition methodName , ' := (qFlags bitAnd: ' , bitMask asString , ') ~= 0.';
								cr
							]
					]
				ifFalse: [ s nextPutAll: '	(qFlags bitAnd: ' , bitMask asString , ') = 0 ifTrue: ['.
					fieldDefinition isReserved
						ifFalse: [ s nextPutAll: fieldDefinition  name lowerCamelCased  , ' := nil' ].
					s
						nextPutAll: '] ifFalse: [' , ( self decodeFieldSource: fieldDefinition ) , '].';
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
AmqpSpecCompiler >> encodeFieldSource: aFieldDefinition [

	^ 'codec next' , aFieldDefinition domainType capitalized , 'Put: '
		,
			( aFieldDefinition isReserved
				ifTrue: [ self reservedValueForDomain: aFieldDefinition domainType ]
				ifFalse: [ aFieldDefinition name lowerCamelCased ] ) , '.'
]

{ #category : #accessing }
AmqpSpecCompiler >> encodeMethodSource: aMethodDefinition [

	| bitindex finishbits |

	^ String
		streamContents: [ :stream | 
			stream
				nextPutAll: 'encodeOn: codec';
				cr.


			aMethodDefinition fields
				detect: [ :fieldDefinition | fieldDefinition domainType = 'bit' ]
				ifFound: [ stream
						nextPutAll: '| bitBuffer |';
						cr
					].

			bitindex := nil.
			finishbits := [ bitindex notNil
				ifTrue: [ stream
						nextPutAll: 'codec nextOctetPut: bitBuffer.';
						cr
					]
			].

			aMethodDefinition fields
				do: [ :fieldDefinition | 
					fieldDefinition domainType = 'bit'
						ifTrue: [ bitindex
								ifNil: [ bitindex := 0.
									stream
										nextPutAll: 'bitBuffer := 0.';
										cr
									].
							bitindex >= 8
								ifTrue: [ finishbits value.
									stream
										nextPutAll: 'bitBuffer := 0.';
										cr.
									bitindex := 0
									].
							fieldDefinition isReserved
								ifFalse: [ stream
										nextPutAll: ( '(<1s> ifNil: [false])' expandMacrosWith: fieldDefinition name lowerCamelCased );
										nextPutAll: ( ' ifTrue: [bitBuffer := bitBuffer bitOr: <1p>].' expandMacrosWith: ( 1 bitShift: bitindex ) );
										cr
									].
							bitindex := bitindex + 1
							]
						ifFalse: [ finishbits value.
							bitindex := nil.
							stream
								nextPutAll: ( self encodeFieldSource: fieldDefinition );
								cr
							]
					].
			finishbits value
			]
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
				ifFalse: [ property domainType = 'bit'
						ifTrue: [ source
								nextPutAll: '	' , property name lowerCamelCased , ' ifTrue: [qFlags := qFlags bitOr: ' , bitMask asString , '].';
								cr
							]
						ifFalse: [ source
								nextPutAll: '	' , property name lowerCamelCased , ' isNil ifFalse: [qFlags := qFlags bitOr: ' , bitMask asString , '].';
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
								nextPutAll: '	' , f name lowerCamelCased , ' isNil ifFalse: [' , ( self encodeFieldSource: f ) , '].';
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
		named: prefix , aClassDefinition name upperCamelCased , 'Properties'
		instanceVariables: ( fieldDefinitions collect: [ :fieldDefinition | fieldDefinition name lowerCamelCased ] ).
	fieldDefinitions
		do: [ :fieldDefinition | 
			class
				compile: fieldDefinition name lowerCamelCased , ' ^ ' , fieldDefinition name lowerCamelCased
				classified: 'accessing'.
			class
				compile:
					fieldDefinition name lowerCamelCased , ': aValue ' , fieldDefinition name lowerCamelCased
						, ' := aValue.'
				classified: 'accessing'
			].
	class compile: 'codecClassId ^ ' , aClassDefinition index asString classified: 'AMQP codec'.
	class compile: ( self decodePropertiesSource: aClassDefinition ) classified: 'AMQP codec'.
	class compile: ( self encodePropertiesSource: aClassDefinition ) classified: 'AMQP codec'
]

{ #category : #'code generation' }
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
		do: [ :constant | 
			class
				compile: constant name lowerCamelCased , ' ^' , constant value asString
				classified: 'AMQP protocol constants'
			].

	spec classDefinitions valuesDo: [ :def | self generateClass: def ].
	class compile: self initializerSource classified: 'class initialization'.

	spec allMethods
		do: [ :def | 
			class
				compile:
					def classDef name lowerCamelCased , def name upperCamelCased , 'Method' , ' ^ '
						, ( prefix , def classDef name upperCamelCased , def name upperCamelCased )
				classified: 'AMQP methods'
			].
		
	spec classDefinitions
		valuesDo: [ :classDefinition | 
			classDefinition hasProperties
				ifTrue: [ class
						compile:
							( classDefinition name lowerCamelCased , 'Properties' , 'Class' ) , ' ^ '
								, ( prefix , classDefinition name upperCamelCased , 'Properties' )
						classified: 'AMQP content properties'
					]
			]
]

{ #category : #accessing }
AmqpSpecCompiler >> generateMethod: aMethodDefinition [

	| class fieldDefinitions |

	fieldDefinitions := aMethodDefinition fields
		reject: [ :fieldDefinition | fieldDefinition isReserved ].

	class := self
		subclassOf: AmqpProtocolMethod
		named: prefix , aMethodDefinition classDef name upperCamelCased , aMethodDefinition name upperCamelCased
		instanceVariables: ( ( fieldDefinitions collect: #name ) collect: #lowerCamelCased ).

	fieldDefinitions
		do: [ :fieldDefinition | 
			class
				compile: fieldDefinition name lowerCamelCased , ' ^ ' , fieldDefinition name lowerCamelCased
				classified: 'accessing'.
			class
				compile:
					fieldDefinition name lowerCamelCased , ': aValue ' , fieldDefinition name lowerCamelCased
						, ' := aValue.'
				classified: 'accessing'
			].
	class compile: 'codecMethodId ^ ' , aMethodDefinition methodId asString classified: 'AMQP codec'.
	class compile: 'hasContents ^ ' , aMethodDefinition hasContents asString classified: 'AMQP codec'.
	class compile: ( self acceptableResponseClassesSource: aMethodDefinition ) classified: 'AMQP codec'.
	class compile: ( self decodeMethodSource: aMethodDefinition ) classified: 'AMQP codec'.
	class compile: ( self encodeMethodSource: aMethodDefinition ) classified: 'AMQP codec'
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
								nextPutAll: prefix , classDefinition name upperCamelCased , 'Properties';
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
						nextPutAll: prefix , each classDef name upperCamelCased , each name upperCamelCased;
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
	definitionCategory := 'Ansible-Protocol-' , spec versionString.
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

{ #category : #'code generation' }
AmqpSpecCompiler >> wipePackage [

	( self confirm: 'Are you sure you want to erase all classes in package ' , definitionCategory , '?' )
		ifFalse: [ ^ self ].

	( RBPackageEnvironment packageName: definitionCategory )
		classesDo: [ :class | 
			class isObsolete
				ifFalse: [ class removeFromSystem ]
			]
]
