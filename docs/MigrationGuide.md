# Migration Guide

## Migration from v2 to v3

* Manually load the package `Ansible-Deprecated-V3` that has transformation of deprecated messages.

* `RabbitMQWorker` has been refactored to be used by composition instead of inheritance:
The classes that subclassified it implemented the subclass responsibility `#configureConnection:` and `#process: payload` should be changed to instantiate `RabbitMQWorker` as to pass that process logic to the `processingPayloadWith:` collaborator. 

For instance, 

```
Class {
	#name : 'RabbitMQTextReverser',
	#superclass : 'RabbitMQWorker',
    #instVars : [ 
        'testCase',
    ]
}

{ #category : 'initialization' }
RabbitMQTextReverser >> initializeWorkingWith: aTestCase 

    testCase := aTestCase

{ #category : 'private' }
RabbitMQTextReverser >> #configureConnection: builder 
	
    builder hostname: 'localhost'.
	builder portNumber: 5672.
	builder username: 'guest'.
	builder password: 'guest'.

{ #category : 'private' }
RabbitMQTextReverser >> process: payload 
    
    testCase storeText: payload utf8Decoded reversed
```

Should be refactored to

```
Class {
	#name : 'RabbitMQTextReverser',
	#superclass : 'Object',
    #instVars : [ 
        'worker'
    ]
}

RabbitMQTextReverser >> initializeWorkingWith: aTestCase 

    worker := RabbitMQWorker
        configuredBy: [ :options |
            options 
                at: #hostname 'localhost';.
                at: #port 5672;.
	            at: #username 'guest';.
	            at: #password 'guest'
            ]
        processingMessagesWith: [ :payload | aTestCase storeText: payload utf8Decoded reversed ]. 

    worker start
```