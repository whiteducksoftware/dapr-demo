param location string
param environmentId string

// basic settings
// var image = 'ghcr.io/whiteducksoftware/dapr-demo/notification-service:latest'
var image = 'ghcr.io/whiteducksoftware/sample-mvc:fred'
var name = 'dapr-demo-notification-service'

resource notificationservice 'Microsoft.App/containerApps@2022-03-01' = {
  name: 'notificationservice'
  location: location
  properties: {
    managedEnvironmentId: environmentId
    configuration: {
      // dapr: {
      //   enabled: true
      //   appId: name
      //   appProtocol: 'grpc'
      //   appPort: 5005
      // }
    }
    template: {
      containers: [
        {
          image: image
          name: name
          resources: {
            cpu: 1
            memory: '2.0Gi'
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
