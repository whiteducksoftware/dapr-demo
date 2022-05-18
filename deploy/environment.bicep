param environmentName string
param logAnalyticsWorkspaceName string
param appInsightsName string
param location string
param storageAccountName string

@secure()
param connectionString string
param storageAccountKey string

resource logAnalyticsWorkspace 'Microsoft.OperationalInsights/workspaces@2020-03-01-preview' = {
  name: logAnalyticsWorkspaceName
  location: location
  properties: any({
    retentionInDays: 30
    features: {
      searchVersion: 1
    }
    sku: {
      name: 'PerGB2018'
    }
  })
}

resource appInsights 'Microsoft.Insights/components@2020-02-02' = {
  name: appInsightsName
  location: location
  kind: 'web'
  properties: {
    Application_Type: 'web'
    WorkspaceResourceId: logAnalyticsWorkspace.id
  }
}

resource environment 'Microsoft.App/managedEnvironments@2022-03-01' = {
  name: environmentName
  location: location
  properties: {
    daprAIInstrumentationKey: appInsights.properties.InstrumentationKey
    appLogsConfiguration: {
      destination: 'log-analytics'
      logAnalyticsConfiguration: {
        customerId: logAnalyticsWorkspace.properties.customerId
        sharedKey: logAnalyticsWorkspace.listKeys().primarySharedKey
      }
    }
  }

  resource daprComponent 'daprComponents@2022-03-01' = {
    name: 'dapr-demo-state-store'
    properties: {
      componentType: 'state.azure.blobstorage'
      version: 'v1'
      ignoreErrors: false
      initTimeout: '5s'
      secrets: [
        {
          name: 'storageaccountkey'
          value: storageAccountKey
        }
      ]
      metadata: [
        {
          name: 'accountName'
          value: storageAccountName
        }
        {
          name: 'containerName'
          value: 'daprcontainer'
        }
        {
          name: 'accountKey'
          secretRef: 'storageaccountkey'
        }
      ]
      scopes: [
        'dapr-demo-message-service'
      ]
    }
  }

  resource daprPubSubComponent 'daprComponents@2022-03-01' = {
    name: 'dapr-demo-pubsub'
    properties: {
      componentType: 'pubsub.azure.servicebus'
      version: 'v1'
      ignoreErrors: false
      initTimeout: '5s'
      secrets: [
        {
          name: 'connectionstringsecret'
          value: connectionString
        }
      ]
      metadata: [
        {
          name: 'connectionString'
          secretRef: 'connectionstringsecret'
        }
      ]
      scopes: [
        'dapr-demo-message-service'
        'dapr-demo-notification-service'
      ]
    }
  }
}

output location string = location
output environmentId string = environment.id
