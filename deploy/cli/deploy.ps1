$location = 'westeurope'

$rgName = 'rg-dapr-demo-build'
$storageAccountName = 'stodaprdemobuild'
$serviceBusName = 'sb-dapr-demo-build'
$logAnalyticsName = 'log-dapr-demo-build'
$containerAppEnvironmentName = 'conappenv-dapr-demo-build'

az group create -n $rgName -l $location

# az containerapp env dapr-component list -g rg-community-build-conapp --name conappenv-build-dapr
#az storage account keys list --resource-group $rgName --account-name $storageAccountName --query '[0].value' --out tsv
az servicebus namespace create --resource-group $rgName --name $serviceBusName --location $location

az storage account create `
  --name $storageAccountName `
  --resource-group $rgName `
  --location $location `
  --sku Standard_LRS `
  --kind StorageV2


az monitor log-analytics workspace create -g $rgName -n $logAnalyticsName

$logWorkspaceId = az monitor log-analytics workspace show -g $rgName -n $logAnalyticsName --query 'customerId' --out tsv
$logWorkspaceKey = az monitor log-analytics workspace get-shared-keys --resource-group $rgName --workspace-name $logAnalyticsName --query 'primarySharedKey' --out tsv

az containerapp env create `
  --name $containerAppEnvironmentName `
  --resource-group $rgName `
  --logs-workspace-id $logWorkspaceId `
  --logs-workspace-key $logWorkspaceKey `
  --location $location

az containerapp env dapr-component set `
    --name $containerAppEnvironmentName `
    --resource-group $rgName `
    --dapr-component-name dapr-demo-state-store `
    --yaml statestore.yml

az containerapp env dapr-component set `
    --name $containerAppEnvironmentName `
    --resource-group $rgName `
    --dapr-component-name dapr-demo-pubsub `
    --yaml pubsub.yml

az containerapp create `
    --name dapr-demo-notification-service `
    --resource-group $rgName `
    --environment $containerAppEnvironmentName `
    --image ghcr.io/whiteducksoftware/dapr-demo/notification-service:latest `
    --min-replicas 1 `
    --max-replicas 1 `
    --enable-dapr `
    --dapr-app-port 5005 `
    --dapr-app-id 'dapr-demo-notification-service'

  az containerapp create `
    --name dapr-demo-message-service `
    --resource-group $rgName `
    --environment $containerAppEnvironmentName `
    --image ghcr.io/whiteducksoftware/dapr-demo/message-service:latest `
    --min-replicas 1 `
    --max-replicas 1 `
    --enable-dapr `
    --dapr-app-protocol grpc `
    --dapr-app-port 5002 `
    --dapr-app-id 'dapr-demo-message-service'

az containerapp create `
    --name dapr-demo-client `
    --resource-group $rgName `
    --environment $containerAppEnvironmentName `
    --image ghcr.io/whiteducksoftware/dapr-demo/client:latest `
    --enable-dapr `
    --dapr-app-id 'dapr-demo-client' `
    --min-replicas 1 `
    --max-replicas 1


