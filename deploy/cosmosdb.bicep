@description('Cosmos DB account name')
param accountName string = 'cosmos-${uniqueString(resourceGroup().id)}'

@description('Location for the Cosmos DB account.')
param location string = resourceGroup().location

@description('The name for the Core (SQL) database')
param databaseName string

@description('The name of the cosmosDB container')
param containerName string = 'messages'

@description('Maximum throughput for the container')
@minValue(4000)
@maxValue(1000000)
param autoscaleMaxThroughput int = 4000

resource cosmosAccount 'Microsoft.DocumentDB/databaseAccounts@2021-04-15' = {
  name: toLower(accountName)
  location: location
  properties: {
    enableFreeTier: true
    databaseAccountOfferType: 'Standard'
    consistencyPolicy: {
      defaultConsistencyLevel: 'Session'
    }
    locations: [
      {
        locationName: location
      }
    ]
  }
}

resource cosmosDB 'Microsoft.DocumentDB/databaseAccounts/sqlDatabases@2021-04-15' = {
  name: '${cosmosAccount.name}/${toLower(databaseName)}'
  properties: {
    resource: {
      id: databaseName
    }
    options: {
      throughput: 400
    }
  }
}

resource container 'Microsoft.DocumentDB/databaseAccounts/sqlDatabases/containers@2021-01-15' = {
  parent: cosmosDB
  name: containerName
  properties: {
    resource: {
      id: containerName
      partitionKey: {
        paths: [
          '/partitionKey'
        ]
        kind: 'Hash'
      }
    }
    options: {
      autoscaleSettings: {
        maxThroughput: autoscaleMaxThroughput
      }
    }
  }
}

output url string = 'https://${cosmosAccount.name}.documents.azure.com:443/'
output database string = databaseName
output collection string = container.name

#disable-next-line outputs-should-not-contain-secrets
output masterKey string = cosmosAccount.listKeys().primaryMasterKey
