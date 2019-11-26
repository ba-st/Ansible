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
						nextPutAll: methodDefinition classDef name upperCamelCased;
						nextPutAll: response upperCamelCased ;
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
		ifFalse: [ '' , aFieldDefinition domainName lowerCamelCased , ' := ' ] ) , 'codec next'
		, aFieldDefinition domainType capitalized , '.'
]

{ #category : #accessing }
AmqpSpecCompiler >> decodeMethodSource: aMethodDefinition [

	| stream bitindex |

	stream := WriteStream with: 'decodeFrom: codec
	| bitBuffer |
'.
	bitindex := nil.
	aMethodDefinition fields
		do: [ :fieldDefinition | 
			fieldDefinition domainType = 'bit'
				ifTrue: [ bitindex ifNil: [ bitindex := 0 ].
					bitindex >= 8
						ifTrue: [ bitindex := 0 ].
					bitindex = 0
						ifTrue: [ stream
								nextPutAll: '	bitBuffer := codec nextOctet.';
								cr
							].
					fieldDefinition isReserved
						ifFalse: [ stream
								nextPutAll: '	' , fieldDefinition name lowerCamelCased , ' := (bitBuffer bitAnd: ' , ( 1 bitShift: bitindex ) asString , ') ~= 0.'.
							stream cr
							].
					bitindex := bitindex + 1
					]
				ifFalse: [ bitindex := nil.
					stream
						nextPutAll: '	' , ( self decodeFieldSource: fieldDefinition );
						cr
					]
			].
	^ stream contents
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
				ifFalse: [ aFieldDefinition domainName lowerCamelCased ] ) , '.'
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
		named: prefix , methodDefinition classDef name upperCamelCased , methodDefinition name upperCamelCased
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
