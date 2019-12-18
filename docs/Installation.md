# Installation

## Basic Installation

You can load **Lepus** evaluating:
```smalltalk
Metacello new
	baseline: 'Lepus';
	repository: 'github://fortizpenaloza/Lepus:<DEFAULT_BRANCH>/source';
	load.
```
>  Change `<DEFAULT_BRANCH>` to some released version if you want a pinned version

## Using as dependency

In order to include **Lepus** as part of your project, you should reference the package in your product baseline:

```smalltalk
setUpDependencies: spec

	spec
		baseline: 'Lepus'
			with: [ spec
				repository: 'github://fortizpenaloza/Lepus:v{XX}/source';
				loads: #('Deployment') ];
		import: 'Lepus'.
```
> Replace `{XX}` with the version you want to depend on

```smalltalk
baseline: spec

	<baseline>
	spec
		for: #common
		do: [ self setUpDependencies: spec.
			spec package: 'My-Package' with: [ spec requires: #('Lepus') ] ]
```

## Provided groups

- `Deployment` will load all the packages needed in a deployed application
- `Tests` will load the test cases
- `Tools` will load the extensions to the SUnit framework and development tools (inspector and spotter extensions) and the code generation tools.
- `CI` is the group loaded in the continuous integration setup
- `Development` will load all the needed packages to develop and contribute to the project
