param location string
param environmentId string

// basic settings
var image = 'ghcr.io/whiteducksoftware/dapr-demo/message-service:sha-cdc5345'
// var image = 'ghcr.io/whiteducksoftware/dapr-demo/message-service:latest'
var name = 'dapr-demo-message-service'

resource messageservice 'Microsoft.App/containerApps@2022-03-01' = {
  name: 'messageservice'
  location: location
  properties: {
    managedEnvironmentId: environmentId
    configuration: {
      ingress: {
        external: false
        targetPort: 5002
      }

      // dapr: {
      //   enabled: true
      //   appId: name
      //   appProtocol: 'grpc'
      //   appPort: 5002
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
