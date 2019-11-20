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

			spec
				package: 'Amqp-Tools' with: [ spec requires: 'XMLParser-Core' ].
				
			spec
				group: 'Tools' with: #('Amqp-Tools');
				group: 'Development' with: #('Tools')
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
