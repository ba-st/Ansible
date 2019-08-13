Class {
	#name : #BaselineOfLepus,
	#superclass : #BaselineOf,
	#category : #BaselineOfLepus
}

{ #category : #baselines }
BaselineOfLepus >> baseline: spec [

	<baseline>
	spec
		for: #common
		do: [ spec
				package: 'Amqp-Protocol' with: [ spec requires: #('Amqp-Protocol-091' 'Amqp-Protocol-08') ];
				package: 'Amqp-Protocol-Base';
				package: 'Amqp-Protocol-08' with: [ spec requires: 'Amqp-Protocol-Base' ];
				package: 'Amqp-Protocol-091' with: [ spec requires: 'Amqp-Protocol-Base' ];
				package: 'Amqp-Tests' with: [ spec requires: 'Amqp-Protocol' ];
				package: 'Amqp-Tools';
				package: 'Amqp-Examples'.

			spec
				group: 'Deployment' with: #('Amqp-Protocol');
				group: 'Tests' with: #('Amqp-Tests');
				group: 'CI' with: #('Tests');
				group: 'Tools' with: #('Amqp-Tools');
				group: 'Examples' with: #('Amqp-Examples');
				group: 'Development' with: #('Tests' 'Tools')
			]
]

{ #category : #accessing }
BaselineOfLepus >> projectClass [

	^ MetacelloCypressBaselineProject
]
