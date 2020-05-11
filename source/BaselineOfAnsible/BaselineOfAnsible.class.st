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
		do: [ self
				setUpDependencies: spec;
				setUpPackages: spec.
			spec
				group: 'Deployment' with: #('Deployment-08 Deployment-091');
				group: 'CI' with: #('Tests');
				group: 'Tools' with: #('Ansible-Tools');
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

{ #category : #baselines }
BaselineOfAnsible >> setUpPackages: spec [

	spec
		package: 'Ansible-Protocol-Common';
		package: 'Ansible-Protocol-08' with: [ spec requires: 'Ansible-Protocol-Common' ];
		group: 'Deployment-08' with: 'Ansible-Protocol-08';
		package: 'Ansible-Protocol-091' with: [ spec requires: 'Ansible-Protocol-Common' ];
		group: 'Deployment-091' with: 'Ansible-Protocol-091';

		package: 'Ansible-Protocol-Core';
		group: 'Deployment-08' with: 'Ansible-Protocol-Core';
		group: 'Deployment-091' with: 'Ansible-Protocol-Core';

		package: 'Ansible-Tests' with: [ spec requires: 'Ansible-Protocol-Core' ];
		group: 'Tests' with: 'Ansible-Tests';
		package: 'Ansible-Protocol-Tests' with: [ spec requires: 'Ansible-Protocol-Core' ];
		group: 'Tests' with: 'Ansible-Protocol-Tests';
		
		package: 'Ansible-Tools' with: [ spec requires: 'XMLParser-Core' ]
]
