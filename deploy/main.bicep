param location string = resourceGroup().location
param environmentName string = 'env-${uniqueString(resourceGroup().id)}'
param minReplicas int = 1

// notification service
var notificationServiceName = 'notification-service'
var notificationServiceImage = 'ghcr.io/whiteducksoftware/dapr-demo/notification-service:latest'
var notificationServicePort = 5005

// param nodeImage string
// param nodePort int = 3000
// var nodeServiceAppName = 'node-app'

// param pythonImage string
// param pythonPort int = 5000
// var pythonServiceAppName = 'python-app'

// param goImage string
// param goPort int = 8050
// var goServiceAppName = 'go-app'

// param apimName string = 'store-api-mgmt-${uniqueString(resourceGroup().id)}'
// param deployApim bool = true
// param isPrivateRegistry bool = true

// Container Apps Environment 1

module environment 'environment.bicep' = {
  name: '${deployment().name}--environment'
  params: {
    environmentName: environmentName
    location: location
    appInsightsName: '${environmentName}-ai'
    logAnalyticsWorkspaceName: '${environmentName}-la'
    collection: cosmosdb.outputs.collection
    database: cosmosdb.outputs.database
    masterKey: cosmosdb.outputs.masterKey
    url: cosmosdb.outputs.url
  }
}

// Cosmosdb
module cosmosdb 'cosmosdb.bicep' = {
  name: '${deployment().name}--cosmosdb'
  params: {
    location: 'westus' // yes, this should be location but right now, Azure CosmosDB is not available everywhere..
    databaseName: 'daprdb'
  }
}

// ServiceBus
module servicebus 'servicebus.bicep' = {
  name: '${deployment().name}--servicebus'
  params: {
    location: location
  }
}

module messageservice 'apps/messageservice.bicep' = {
  name: '${deployment().name}--messageservice'
  params: {
    location: location
    environmentId: environment.outputs.environmentId
  }
}

// NotificationService
// module notificationService 'container-http.bicep' = {
//   name: '${deployment().name}--${notificationServiceName}'
//   dependsOn: [
//     environment
//   ]
//   params: {
//     enableIngress: true
//     isExternalIngress: false
//     location: location
//     environmentName: environmentName
//     containerAppName: notificationServiceName
//     containerImage: notificationServiceImage
//     containerPort: notificationServicePort
//     isPrivateRegistry: false
//     minReplicas: minReplicas
//   }
// }

resource notificationService 'Microsoft.App/containerApps@2022-01-01-preview' = {
  name: 'notificationservice'
  location: location
  properties: {
    managedEnvironmentId: environment.outputs.environmentId
    configuration: {
      ingress: {
        external: true
        targetPort: 5005
      }
      dapr: {
        enabled: true
        appId: 'dapr-demo-notification-service'
        appProtocol: 'http'
        appPort: 5005
      }
    }
    template: {
      containers: [
        {
          image: notificationServiceImage
          name: notificationServiceName
          resources: {
            cpu: '0.5'
            memory: '1.0Gi'
          }
        }
      ]
      scale: {
        minReplicas: 1
        maxReplicas: 1
      }
    }
  }
}

// resource stateDaprComponent 'Microsoft.App/managedEnvironments/daprComponents@2022-01-01-preview' = {
//   name: '${environmentName}/orders'
//   dependsOn: [
//     environment
//   ]
//   properties: {
//     componentType: 'state.azure.cosmosdb'
//     version: 'v1'
//     secrets: [
//       {
//         name: 'masterkey'
//         value: cosmosdb.outputs.primaryMasterKey
//       }
//     ]
//     metadata: [
//       {
//         name: 'url'
//         value: cosmosdb.outputs.documentEndpoint
//       }
//       {
//         name: 'database'
//         value: 'ordersDb'
//       }
//       {
//         name: 'collection'
//         value: 'orders'
//       }
//       {
//         name: 'masterkey'
//         secretRef: 'masterkey'
//       }
//     ]
//     scopes: [
//       pythonServiceAppName
//     ]
//   }
// }

// // Go App
// module goService 'container-http.bicep' = {
//   name: '${deployment().name}--${goServiceAppName}'
//   dependsOn: [
//     environment
//   ]
//   params: {
//     enableIngress: true
//     isExternalIngress: false
//     location: location
//     environmentName: environmentName
//     containerAppName: goServiceAppName
//     containerImage: goImage
//     containerPort: goPort
//     isPrivateRegistry: isPrivateRegistry
//     minReplicas: minReplicas
//     containerRegistry: containerRegistry
//     registryPassword: registryPassword
//     containerRegistryUsername: containerRegistryUsername
//     secrets: isPrivateRegistry ? [
//       {
//         name: registryPassword
//         value: containerRegistryPassword
//       }
//     ] : []
//   }
// }

// // Node App
// module nodeService 'container-http.bicep' = {
//   name: '${deployment().name}--${nodeServiceAppName}'
//   dependsOn: [
//     environment
//   ]
//   params: {
//     enableIngress: true 
//     isExternalIngress: true
//     location: location
//     environmentName: environmentName
//     containerAppName: nodeServiceAppName
//     containerImage: nodeImage
//     containerPort: nodePort
//     minReplicas: minReplicas
//     isPrivateRegistry: isPrivateRegistry 
//     containerRegistry: containerRegistry
//     registryPassword: registryPassword
//     containerRegistryUsername: containerRegistryUsername
//     env: [
//       {
//         name: 'ORDER_SERVICE_NAME'
//         value: pythonServiceAppName
//       }
//       {
//         name: 'INVENTORY_SERVICE_NAME'
//         value: goServiceAppName
//       }
//     ]
//     secrets: [
//       {
//         name: registryPassword
//         value: containerRegistryPassword
//       }
//     ]
//   }
// }

// module apimStoreApi 'api-management-api.bicep' = if (deployApim) {
//   name: '${deployment().name}--apim-store-api'
//   dependsOn: [
//     apim
//     nodeService
//   ]
//   params: {
//     apiName: 'store-api'
//     apimInstanceName: apimName
//     apiEndPointURL: 'https://${nodeService.outputs.fqdn}/swagger.json'
//   }
// }

// output nodeFqdn string = nodeService.outputs.fqdn
// output pythonFqdn string = pythonService.outputs.fqdn
// output goFqdn string = goService.outputs.fqdn
// output apimFqdn string = deployApim ? apim.outputs.fqdn : 'API Management not deployed'

output url string = cosmosdb.outputs.url
output masterKey string = cosmosdb.outputs.masterKey
output database string = cosmosdb.outputs.database
output collection string = cosmosdb.outputs.collection

output connectionString string = servicebus.outputs.connectionString
