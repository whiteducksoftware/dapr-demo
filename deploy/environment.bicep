param environmentName string
param logAnalyticsWorkspaceName string
param appInsightsName string
param location string

@secure()
param masterKey string
param collection string
param database string
param url string

param connectionString string

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

resource environment 'Microsoft.App/managedEnvironments@2022-01-01-preview' = {
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

  resource daprStateComponent 'daprComponents@2022-01-01-preview' = {
    name: 'dapr-demo-state-store'
    properties: {
      componentType: 'state.azure.cosmosdb'
      version: 'v1'
      ignoreErrors: false
      initTimeout: '5s'
      secrets: [
        {
          name: 'masterkeysecret'
          value: masterKey
        }
      ]
      metadata: [
        {
          name: 'url'
          value: url
        }
        {
          name: 'masterKey'
          secretRef: 'masterkeysecret'
        }
        {
          name: 'database'
          value: database
        }
        {
          name: 'collection'
          value: collection
        }
      ]
      scopes: [
        'messageservice'
      ]
    }
  }

  resource daprPubSubComponent 'daprComponents@2022-01-01-preview' = {
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
        'messageservice'
        'notificationservice'
      ]
    }
  }
}

output location string = location
output environmentId string = environment.id
