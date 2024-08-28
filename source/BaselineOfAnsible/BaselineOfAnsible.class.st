Class {
	#name : 'BaselineOfAnsible',
	#superclass : 'BaselineOf',
	#category : 'BaselineOfAnsible',
	#package : 'BaselineOfAnsible'
}

{ #category : 'baselines' }
BaselineOfAnsible >> baseline: spec [

  <baseline>
  spec for: #pharo do: [
      self
        setUpDependencies: spec;
        setUpDeploymentPackages: spec;
        setUpTestPackages: spec;
        setUpToolsPackages: spec.
      spec
        group: 'Deployment' with: #( 'Deployment-08' 'Deployment-091' 'RabbitMQ' );
        group: 'CI' with: #( 'Tests' );
        group: 'Development' with: #( 'Tests' 'Tools' ).
      spec postLoadDoIt: #postLoadInitialization
    ]
]

{ #category : 'initialization' }
BaselineOfAnsible >> postLoadInitialization [
  " ExpectedSocketFailure is used to handle socket failures across 
	different Pharo versions (SocketError was introduced in Pharo 11) "

  Smalltalk at: #ExpectedSocketFailure put: ( ( Smalltalk includesKey: #SocketError )
        then: [ Smalltalk at: #SocketError ]
        otherwise: [ PrimitiveFailed ] )
]

{ #category : 'accessing' }
BaselineOfAnsible >> projectClass [

	^ MetacelloCypressBaselineProject 
]

{ #category : 'initialization' }
BaselineOfAnsible >> setUpDependencies: spec [

	spec
		baseline: 'XMLParser'
		with: [ spec repository: 'github://pharo-contributions/XML-XMLParser:master/src' ];
		project: 'XMLParser-Core' copyFrom: 'XMLParser' with: [ spec loads: #( 'Core' ) ].

	spec
		baseline: 'Bell' with: [ spec repository: 'github://ba-st/Bell:v3' ];
		project: 'Bell-SUnit' copyFrom: 'Bell' with: [ spec loads: 'Dependent-SUnit-Extensions' ].
		
	spec
		baseline: 'Launchpad' with: [ spec repository: 'github://ba-st/Launchpad:v6' ];
		project: 'Launchpad-Deployment' copyFrom: 'Launchpad' with: [ spec loads: 'Deployment' ].

	spec
		baseline: 'Buoy' with: [ spec repository: 'github://ba-st/Buoy:v8' ];
		project: 'Buoy-SUnit' copyFrom: 'Buoy' with: [ spec loads: 'Dependent-SUnit-Extensions' ].

	spec
		baseline: 'Hyperspace' with: [ spec repository: 'github://ba-st/Hyperspace:v6' ];
		project: 'Hyperspace-Deployment' copyFrom: 'Hyperspace' with: [ spec loads: 'Deployment' ]
]

{ #category : 'baselines' }
BaselineOfAnsible >> setUpDeploymentPackages: spec [
	
	spec
		for: #('pharo7.x' 'pharo8.x' 'pharo9.x' 'pharo10.x' 'pharo11.x')
		do: [ 
			spec
				package: 'Ansible-Pharo-Pending-Patches';
				group: 'RabbitMQ' with: 'Ansible-Pharo-Pending-Patches'. 
			spec
				package: 'Ansible-RabbitMQ'
				with: [ spec requires: #( 'Ansible-Pharo-Pending-Patches' 'Ansible-Protocol-091' 'Launchpad-Deployment' 'Hyperspace-Deployment' ) ];
				group: 'RabbitMQ' with: 'Ansible-RabbitMQ' ].
			
	spec
		package: 'Ansible-Protocol-Core';
		group: 'Deployment-08' with: 'Ansible-Protocol-Core';
		group: 'Deployment-091' with: 'Ansible-Protocol-Core';
		package: 'Ansible-Protocol-Common' with: [ spec requires: 'Ansible-Protocol-Core' ];
		group: 'Deployment-08' with: 'Ansible-Protocol-Common';
		group: 'Deployment-091' with: 'Ansible-Protocol-Common';
		package: 'Ansible-Protocol-08' with: [ spec requires: 'Ansible-Protocol-Common' ];
		group: 'Deployment-08' with: 'Ansible-Protocol-08';
		package: 'Ansible-Protocol-091' with: [ spec requires: 'Ansible-Protocol-Common' ];
		group: 'Deployment-091' with: 'Ansible-Protocol-091'.

	spec
		package: 'Ansible-RabbitMQ'
		with: [ spec requires: #( 'Ansible-Protocol-091' 'Launchpad-Deployment' 'Hyperspace-Deployment' ) ];
		group: 'RabbitMQ' with: 'Ansible-RabbitMQ'
]

{ #category : 'baselines' }
BaselineOfAnsible >> setUpTestPackages: spec [

	spec
		package: 'Ansible-Tests' with: [ spec requires: 'Ansible-Protocol-091' ];
		group: 'Tests' with: 'Ansible-Tests';
		package: 'Ansible-Protocol-Tests' with: [ spec requires: 'Ansible-Protocol-091' ];
		group: 'Tests' with: 'Ansible-Protocol-Tests';
		package: 'Ansible-Protocol-091-Tests' with: [ spec requires: 'Ansible-Protocol-091' ];
		group: 'Tests' with: 'Ansible-Protocol-091-Tests';
		package: 'Ansible-RabbitMQ-Tests' with: [ spec requires: #( 'Ansible-RabbitMQ' 'Buoy-SUnit' 'Bell-SUnit' ) ];
		group: 'Tests' with: 'Ansible-RabbitMQ-Tests'
]

{ #category : 'baselines' }
BaselineOfAnsible >> setUpToolsPackages: spec [

	spec
		package: 'Ansible-Tools' with: [ spec requires: 'XMLParser-Core' ];
		group: 'Tools' with: 'Ansible-Tools'
]
