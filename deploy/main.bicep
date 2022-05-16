param location string = resourceGroup().location
param environmentName string = 'env-${uniqueString(resourceGroup().id)}'

module servicebus 'servicebus.bicep' = {
  name: '${deployment().name}--servicebus'
  params: {
    location: location
  }
}

module storage 'storage.bicep' = {
  name: '${deployment().name}--storage'
  params: {
    location: location
  }
}

module environment 'environment.bicep' = {
  name: '${deployment().name}--environment'
  params: {
    environmentName: environmentName
    location: location
    appInsightsName: '${environmentName}-ai'
    logAnalyticsWorkspaceName: '${environmentName}-la'
    connectionString: servicebus.outputs.connectionString
    storageAccountKey: storage.outputs.storageAccountKey
    storageAccountName: storage.outputs.storageAccountName
  }
}

// module client 'apps/client.bicep' = {
//   name: '${deployment().name}--client'
//   params: {
//     location: location
//     environmentId: environment.outputs.environmentId
//   }
// }

// module notificationservice 'apps/notificationservice.bicep' = {
//   name: '${deployment().name}--notificationservice'
//   params: {
//     location: location
//     environmentId: environment.outputs.environmentId
//   }
// }

module messageservice 'apps/messageservice.bicep' = {
  name: '${deployment().name}--messageservice'
  params: {
    location: location
    environmentId: environment.outputs.environmentId
  }
}

// output nodeFqdn string = nodeService.outputs.fqdn
// output pythonFqdn string = pythonService.outputs.fqdn
// output goFqdn string = goService.outputs.fqdn
// // output apimFqdn string = deployApim ? apim.outputs.fqdn : 'API Management not deployed'

// output url string = cosmosdb.outputs.url
// output masterKey string = cosmosdb.outputs.masterKey
// output database string = cosmosdb.outputs.database
// output collection string = cosmosdb.outputs.collection

output connectionString string = servicebus.outputs.connectionString
