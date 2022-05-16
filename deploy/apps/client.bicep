param location string
param environmentId string

// basic settings
var image = 'ghcr.io/whiteducksoftware/dapr-demo/client:latest'
var name = 'clientimage'

resource client 'Microsoft.App/containerApps@2022-03-01' = {
  name: 'client'
  location: location
  properties: {
    managedEnvironmentId: environmentId
    configuration: {
      // ingress: {
      //   external: false
      //   targetPort: 50001
      // }
      // dapr: {
      //   enabled: true
      //   appId: name
      //   appProtocol: 'grpc'
      //   appPort: 50001
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
