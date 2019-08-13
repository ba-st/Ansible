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
AmqpSpecCompiler >> encodePropertiesSource: c [

	| s |

	s := WriteStream with: 'encodeOn: codec
	| qFlags |
	qFlags := 0.

'.
	c
		propertiesAndMasksDo: [ :f :bitMask | 
			f isReserved
				ifFalse: [ f domain = 'bit'
						ifTrue: [ s
								nextPutAll: '	' , f methodName , ' ifTrue: [qFlags := qFlags bitOr: ' , bitMask asString , '].';
								cr
							]
						ifFalse: [ s
								nextPutAll: '	' , f methodName , ' isNil ifFalse: [qFlags := qFlags bitOr: ' , bitMask asString , '].';
								cr
							]
					]
			].
	s
		cr;
		nextPutAll: '	self encodeFlags: qFlags on: codec.';
		cr;
		cr.
	c
		propertiesAndMasksDo: [ :f :bitMask | 
			f isReserved
				ifFalse: [ f domain = 'bit'
						ifFalse: [ s
								nextPutAll: '	' , f methodName , ' isNil ifFalse: [' , ( self encodeFieldSource: f ) , '].';
								cr
							]
					]
			].
	^ s contents
]

{ #category : #accessing }
AmqpSpecCompiler >> generateClass: def [

	self generateContentProperties: def.
	def methods valuesDo: [ :each | self generateMethod: each ]
]

{ #category : #accessing }
AmqpSpecCompiler >> generateContentProperties: def [

	| c fs |

	def hasProperties
		ifFalse: [ ^ self ].
	fs := def contentProperties reject: [ :each | each isReserved ].
	c := self
		subclassOf: AmqpProtocolProperties
		named: def propertiesName
		instanceVariables: ( fs collect: [ :each | each methodName ] ).
	fs
		do: [ :f | 
			c compile: f methodName , ' ^ ' , f methodName classified: 'accessing'.
			c compile: f methodName , ': aValue ' , f methodName , ' := aValue.' classified: 'accessing'
			].
	c compile: 'codecClassId ^ ' , def index asString classified: 'AMQP codec'.
	c compile: ( self decodePropertiesSource: def ) classified: 'AMQP codec'.
	c compile: ( self encodePropertiesSource: def ) classified: 'AMQP codec'
]

{ #category : #accessing }
AmqpSpecCompiler >> generateEverything [

	| p pc |

	p := self subclassOf: AmqpProtocol named: '' instanceVariables: #().
	pc := p class.

	pc compile: 'portNumber ^' , spec portNumber asString classified: 'AMQP protocol'.
	pc compile: 'majorVersion ^' , spec majorVersion asString classified: 'AMQP protocol'.
	pc compile: 'minorVersion ^' , spec minorVersion asString classified: 'AMQP protocol'.
	pc compile: 'revision ^' , spec revision asString classified: 'AMQP protocol'.
	pc
		compile: 'isObsoleteProtocolVariant ^' , spec isObsoleteProtocolVariant asString
		classified: 'AMQP protocol'.

	spec constants
		keysAndValuesDo: [ :name :value | 
			pc
				compile: ( AmqpSpecCompiler methodNameFor: name ) , ' ^' , value asString
				classified: 'AMQP protocol constants'
			].

	spec classDefinitions valuesDo: [ :def | self generateClass: def ].
	pc compile: self initializerSource classified: 'class initialization'.

	spec allMethods
		do: [ :def | 
			pc
				compile:
					( AmqpSpecCompiler methodNameFor: def classDef name , ' ' , def name , ' method' ) , ' ^ '
						, ( self classNameFor: def classDef name , ' ' , def name )
				classified: 'AMQP methods'
			].
	spec classDefinitions
		valuesDo: [ :def | 
			def hasProperties
				ifTrue: [ pc
						compile:
							( AmqpSpecCompiler methodNameFor: def propertiesName , ' class' ) , ' ^ '
								, ( self classNameFor: def propertiesName )
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

	| source |

	source := WriteStream with: 'initialize
	super initialize.
'.
	spec classDefinitions
		valuesDo: [ :each | 
			each hasProperties
				ifTrue: [ source
						nextPutAll: '	classIds at: ';
						nextPutAll: each index asString;
						nextPutAll: ' put: ';
						nextPutAll: ( self classNameFor: each propertiesName );
						nextPut: $.;
						nextPut: Character cr
					]
			].
	spec allMethods
		do: [ :each | 
			source
				nextPutAll: '	methodIds at: ';
				nextPutAll: each methodId asString;
				nextPutAll: ' put: ';
				nextPutAll: ( self classNameFor: each classDef name , ' ' , each name );
				nextPut: $.;
				nextPut: Character cr
			].
	^ source contents
]

{ #category : #accessing }
AmqpSpecCompiler >> prefix [

	^ prefix
]

{ #category : #accessing }
AmqpSpecCompiler >> prefix: anObject [

	prefix := anObject
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
AmqpSpecCompiler >> subclassOf: aSuperClass named: aString instanceVariables: aCollection [

	| ivs n c |

	ivs := WriteStream with: ''.
	n := self classNameFor: aString.
	aCollection do: [ :each | ivs nextPutAll: each ] separatedBy: [ ivs space ].
	c := aSuperClass
		subclass: n
		instanceVariableNames: ivs contents
		classVariableNames: ''
		poolDictionaries: ''
		category: definitionCategory.
	^ c
]

{ #category : #accessing }
AmqpSpecCompiler >> wipePackage [

	( self confirm: 'Are you sure you want to erase all classes in package ' , definitionCategory , '?' )
		ifFalse: [ ^ self ].
	( Class allSubInstances select: [ :each | each category = definitionCategory ] )
		do: [ :each | each removeFromSystem ]
]
