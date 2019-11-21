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
AmqpSpecCompiler class >> capitalizedNameFor: aString [

	^ self joinPieces: ( aString substrings collect: [ :each | each capitalized ] )
]

{ #category : #'as yet unclassified' }
AmqpSpecCompiler class >> joinPieces: strings [

	| s |

	s := WriteStream with: ''.
	strings do: [ :each | s nextPutAll: each ].
	^ s contents
]

{ #category : #'as yet unclassified' }
AmqpSpecCompiler class >> methodNameFor: aString [

	| first |

	first := true.
	^ self
		joinPieces:
			( aString substrings
				collect: [ :each | 
					first
						ifTrue: [ first := false.
							each
							]
						ifFalse: [ each capitalized ]
					] )
]

{ #category : #accessing }
AmqpSpecCompiler >> acceptableResponseClassesSource: m [

	| s |

	s := WriteStream with: 'acceptableResponseClasses
	^ {
'.
	m responses
		do: [ :each | 
			s
				nextPutAll: '		' , ( self classNameFor: m classDef name , ' ' , each ) , '.';
				cr
			].
	s nextPutAll: '	}'.
	^ s contents
]

{ #category : #accessing }
AmqpSpecCompiler >> classNameFor: aString [

	^ ( prefix
		, ( AmqpSpecCompiler joinPieces: ( aString substrings collect: [ :each | each capitalized ] ) ) )
		asSymbol
]

{ #category : #accessing }
AmqpSpecCompiler >> decodeFieldSource: f [

	^ ( f isReserved
		ifTrue: [ '' ]
		ifFalse: [ '' , f methodName , ' := ' ] ) , 'codec next' , f domainName , '.'
]

{ #category : #accessing }
AmqpSpecCompiler >> decodeMethodSource: m [

	| s bitindex |

	s := WriteStream with: 'decodeFrom: codec
	| bitBuffer |
'.
	bitindex := nil.
	m fields
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
		propertiesAndMasksDo: [ :f :bitMask | 
			f isReserved
				ifFalse: [ f domain = 'bit'
						ifTrue: [ source
								nextPutAll: '	' , f methodName , ' ifTrue: [qFlags := qFlags bitOr: ' , bitMask asString , '].';
								cr
							]
						ifFalse: [ source
								nextPutAll: '	' , f methodName , ' isNil ifFalse: [qFlags := qFlags bitOr: ' , bitMask asString , '].';
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

	self halt.
	self generateContentProperties: aClassDefinition.
	aClassDefinition methods valuesDo: [ :method | self generateMethod: method ]
]

{ #category : #accessing }
AmqpSpecCompiler >> generateContentProperties: aClassDefinition [

	| class fs |

	aClassDefinition hasProperties
		ifFalse: [ ^ self ].
	fs := aClassDefinition contentProperties reject: [ :each | each isReserved ].
	class := self
		subclassOf: AmqpProtocolProperties
		named: aClassDefinition propertiesName
		instanceVariables: ( fs collect: [ :each | each methodName ] ).
	fs
		do: [ :f | 
			class compile: f methodName , ' ^ ' , f methodName classified: 'accessing'.
			class compile: f methodName , ': aValue ' , f methodName , ' := aValue.' classified: 'accessing'
			].
	class compile: 'codecClassId ^ ' , aClassDefinition index asString classified: 'AMQP codec'.
	class compile: ( self decodePropertiesSource: aClassDefinition ) classified: 'AMQP codec'.
	class compile: ( self encodePropertiesSource: aClassDefinition ) classified: 'AMQP codec'
]

{ #category : #accessing }
AmqpSpecCompiler >> generateEverything [

	| protocol class |

	protocol := self subclassOf: AmqpProtocol named: '' instanceVariables: #().
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
				compile: ( self class methodNameFor: name ) , ' ^' , value asString
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
AmqpSpecCompiler >> generateMethod: def [

	| c fs |

	fs := def fields reject: [ :each | each isReserved ].
	c := self
		subclassOf: AmqpProtocolMethod
		named: def classDef name , ' ' , def name
		instanceVariables: ( fs collect: [ :each | each methodName ] ).
	fs
		do: [ :f | 
			c compile: f methodName , ' ^ ' , f methodName classified: 'accessing'.
			c compile: f methodName , ': aValue ' , f methodName , ' := aValue.' classified: 'accessing'
			].
	c compile: 'codecMethodId ^ ' , def methodId asString classified: 'AMQP codec'.
	c compile: 'hasContents ^ ' , def hasContents asString classified: 'AMQP codec'.
	c compile: ( self acceptableResponseClassesSource: def ) classified: 'AMQP codec'.
	c compile: ( self decodeMethodSource: def ) classified: 'AMQP codec'.
	c compile: ( self encodeMethodSource: def ) classified: 'AMQP codec'
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
		subclass: ( self classNameFor: aClassName )
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
