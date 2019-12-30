Class {
	#name : #BaselineOfAnsible,
	#superclass : #BaselineOf,
	#category : #BaselineOfAnsible
}

{ #category : #baselines }
BaselineOfAnsible >> baseline: spec [

	<baseline>
	spec
		for: #pharo
		do: [ self setUpDependencies: spec.

			spec
				package: 'Amqp-Protocol' with: [ spec requires: #('Amqp-Protocol-091' 'Amqp-Protocol-08') ];
				package: 'Amqp-Protocol-Base';
				package: 'Amqp-Protocol-08' with: [ spec requires: 'Amqp-Protocol-Base' ];
				package: 'Amqp-Protocol-091' with: [ spec requires: 'Amqp-Protocol-Base' ];
				package: 'Amqp-Tests' with: [ spec requires: 'Amqp-Protocol' ];
				package: 'Amqp-Protocol-Tests' with: [ spec requires: 'Amqp-Protocol' ];
				package: 'Amqp-Tools' with: [ spec requires: 'XMLParser-Core' ].

			spec
				group: 'Deployment' with: #('Amqp-Protocol');
				group: 'Tests' with: #('Amqp-Tests' 'Amqp-Protocol-Tests');
				group: 'CI' with: #('Tests');
				group: 'Tools' with: #('Amqp-Tools');
				group: 'Development' with: #('Tests' 'Tools')
			]
]

{ #category : #accessing }
BaselineOfAnsible >> projectClass [

	^ MetacelloCypressBaselineProject
]

{ #category : #initialization }
BaselineOfAnsible >> setUpDependencies: spec [

	spec
		baseline: 'XMLParser'
			with: [ spec repository: 'github://pharo-contributions/XML-XMLParser:3.5.0/src' ];
		project: 'XMLParser-Core' copyFrom: 'XMLParser' with: [ spec loads: #('Core') ]
]
