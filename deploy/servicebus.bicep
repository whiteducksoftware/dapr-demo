param location string = resourceGroup().location
param serviceBusNamespaceName string = 'myapp${uniqueString(resourceGroup().id)}'
param skuName string = 'Basic'

resource serviceBusNamespace 'Microsoft.ServiceBus/namespaces@2018-01-01-preview' = {
  name: serviceBusNamespaceName
  location: location
  sku: {
    name: skuName
  }
}

resource authorizationRule 'Microsoft.ServiceBus/namespaces/AuthorizationRules@2021-11-01' = {
  name: 'myRule'
  parent: serviceBusNamespace
  properties: {
    rights: [
      'Send'
    ]
  }
}

// resource deadLetterFirehoseQueue 'Microsoft.ServiceBus/namespaces/queues@2018-01-01-preview' = {
//   name: 'asdfsdf'
//   parent: serviceBusNamespace
//   properties: {
//     requiresDuplicateDetection: false
//     requiresSession: false
//     enablePartitioning: false
//   }
// }

// resource queues 'Microsoft.ServiceBus/namespaces/queues@2018-01-01-preview' = [for queueName in queueNames: {
//   parent: serviceBusNamespace
//   name: queueName
//   dependsOn: [
//     deadLetterFirehoseQueue
//   ]
//   properties: {
//     forwardDeadLetteredMessagesTo: deadLetterFirehoseQueueName
//   }
// }]

var tmp = authorizationRule.listKeys().primaryConnectionString

output connectionString string = tmp
