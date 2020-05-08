# Installation

## Basic Installation

You can load **Ansible** evaluating:
```smalltalk
Metacello new
	baseline: 'Ansible';
	repository: 'github://fortizpenaloza/Ansible:<DEFAULT_BRANCH>/source';
	load.
```
>  Change `<DEFAULT_BRANCH>` to some released version if you want a pinned version

## Using as dependency

In order to include **Ansible** as part of your project, you should reference the package in your product baseline:

```smalltalk
setUpDependencies: spec

	spec
		baseline: 'Ansible'
			with: [ spec
				repository: 'github://fortizpenaloza/Ansible:v{XX}/source';
				loads: #('Deployment') ];
		import: 'Ansible'.
```
> Replace `{XX}` with the version you want to depend on

```smalltalk
baseline: spec

	<baseline>
	spec
		for: #common
		do: [ self setUpDependencies: spec.
			spec package: 'My-Package' with: [ spec requires: #('Ansible') ] ]
```

## Provided groups

- `Deployment` will load all the packages needed in a deployed application
- `Tests` will load the test cases
- `Tools` will load the extensions to the SUnit framework and development tools (inspector and spotter extensions) and the code generation tools.
- `CI` is the group loaded in the continuous integration setup
- `Development` will load all the needed packages to develop and contribute to the project
