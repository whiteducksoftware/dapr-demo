param location string
param environmentId string

// basic settings
// var image = 'ghcr.io/whiteducksoftware/dapr-demo/message-service:latest'
var image = 'ghcr.io/whiteducksoftware/sample-mvc:fred'

var name = 'dapr-demo-message-service'

resource messageservice 'Microsoft.App/containerApps@2022-03-01' = {
  name: 'messageservice'
  location: location
  properties: {
    managedEnvironmentId: environmentId
    configuration: {
      // ingress: {
      //   external: true
      //   targetPort: 3000
      // }
      // dapr: {
      //   enabled: true
      //   appId: 'nodeapp'
      //   appProtocol: 'grpc'
      //   appPort: 3000
      // }
      // dapr: {
      //   enabled: true
      //   appId: 'daprdemomessageservice'
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
