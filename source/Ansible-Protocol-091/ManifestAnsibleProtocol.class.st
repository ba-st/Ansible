"
I store metadata for this package. These meta data are used by other tools such as the SmalllintManifestChecker and the critics Browser
"
Class {
	#name : #ManifestAnsibleProtocol,
	#superclass : #PackageManifest,
	#category : #'Ansible-Protocol-091-Manifest'
}

{ #category : #'code-critics' }
ManifestAnsibleProtocol class >> ruleRBUtilityMethodsRuleV1FalsePositive [
	^ #(#(#(#RGMethodDefinition #(#Amqp091ExchangeDeclare #autoDelete: #false)) #'2021-01-07T17:20:47.443029-03:00') )
]
