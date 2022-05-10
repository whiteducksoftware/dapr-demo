param location string
param environmentId string

// basic settings
var image = 'ghcr.io/whiteducksoftware/dapr-demo/message-service:latest'
var name = 'dapr-demo-message-service'
var port = 5002

// environment settings
var cpu = 1
var memory = '2.0Gi'
var minReplicas = 1
var maxReplicas = 1

resource messageservice 'Microsoft.App/containerApps@2022-01-01-preview' = {
  name: 'messageservice'
  location: location
  properties: {
    managedEnvironmentId: environmentId
    configuration: {
      ingress: {
        external: true
        targetPort: port
      }
      dapr: {
        enabled: true
        appId: name
        appProtocol: 'grpc'
        appPort: port
      }
    }
    template: {
      containers: [
        {
          image: image
          name: name
          resources: {
            cpu: cpu
            memory: memory
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
