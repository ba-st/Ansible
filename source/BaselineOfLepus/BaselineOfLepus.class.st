Class {
	#name : #BaselineOfLepus,
	#superclass : #BaselineOf,
	#category : #BaselineOfLepus
}

{ #category : #baselines }
BaselineOfLepus >> baseline: spec [

	<baseline>
	spec
		for: #pharo
		do: [ self setUpDependencies: spec.
			
			ZnNetworkingUtils default socketStreamClass: SocketStream.

			spec
				package: 'Amqp-Protocol' with: [ spec requires: #('Amqp-Protocol-091' 'Amqp-Protocol-08') ];
				package: 'Amqp-Protocol-Base';
				package: 'Amqp-Protocol-08' with: [ spec requires: 'Amqp-Protocol-Base' ];
				package: 'Amqp-Protocol-091' with: [ spec requires: 'Amqp-Protocol-Base' ];
				package: 'Amqp-Tests' with: [ spec requires: 'Amqp-Protocol' ];
				package: 'Amqp-Tools' with: [ spec requires: 'XMLParser-Core' ].

			spec
				group: 'Deployment' with: #('Amqp-Protocol');
				group: 'Tests' with: #('Amqp-Tests');
				group: 'CI' with: #('Tests');
				group: 'Tools' with: #('Amqp-Tools');
				group: 'Development' with: #('Tests' 'Tools')
			]
]

{ #category : #accessing }
BaselineOfLepus >> projectClass [

	^ MetacelloCypressBaselineProject
]

{ #category : #initialization }
BaselineOfLepus >> setUpDependencies: spec [

	spec
		baseline: 'XMLParser'
			with: [ spec repository: 'github://pharo-contributions/XML-XMLParser:3.5.0/src' ];
		project: 'XMLParser-Core' copyFrom: 'XMLParser' with: [ spec loads: #('Core') ]
]
