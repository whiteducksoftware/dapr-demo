param location string
param environmentId string

var image = 'ghcr.io/whiteducksoftware/dapr-demo/message-service:latest'
var name = 'dapr-demo-message-service'

resource messageService 'Microsoft.App/containerApps@2022-01-01-preview' = {
  name: 'messageservice'
  location: location
  properties: {
    managedEnvironmentId: environmentId
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
          image: image
          name: name
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
