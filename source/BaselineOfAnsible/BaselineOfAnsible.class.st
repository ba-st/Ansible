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
				package: 'Ansible-Protocol-Core'
					with: [ spec requires: #('Ansible-Protocol-091' 'Ansible-Protocol-08') ];
				package: 'Ansible-Protocol-Common';
				package: 'Ansible-Protocol-08'
					with: [ spec requires: 'Ansible-Protocol-Common' ];
				package: 'Ansible-Protocol-091'
					with: [ spec requires: 'Ansible-Protocol-Common' ];
				package: 'Ansible-Tests'
					with: [ spec requires: 'Ansible-Protocol-Common' ];
				package: 'Ansible-Protocol-Tests'
					with: [ spec requires: 'Ansible-Protocol-Core' ];
				package: 'Ansible-Tools'
					with: [ spec requires: 'XMLParser-Core' ].
			spec
				group: 'Deployment' with: #('Ansible-Protocol-Common');
				group: 'Tests' with: #('Ansible-Tests' 'Ansible-Protocol-Tests');
				group: 'CI' with: #('Tests');
				group: 'Tools' with: #('Ansible-Tools');
				group: 'Development' with: #('Tests' 'Tools') ]
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
