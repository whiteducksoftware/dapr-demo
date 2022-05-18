$rgName = 'rg-community-build-conapp'
$environmentName = 'env-ozr2nmuwuplzu'
$location = 'westeurope'

az containerapp create `
    --name dapr-demo-notification-service `
    --resource-group $rgName `
    --environment $environmentName `
    --image ghcr.io/whiteducksoftware/dapr-demo/notification-service:latest `
    --min-replicas 1 `
    --max-replicas 1 `
    --enable-dapr `
    --dapr-app-port 5005 `
    --dapr-app-id dapr-demo-notification-service

az containerapp create `
    --name dapr-demo-message-service `
    --resource-group $rgName `
    --environment $environmentName `
    --image ghcr.io/whiteducksoftware/dapr-demo/message-service:latest `
    --min-replicas 1 `
    --max-replicas 1 `
    --enable-dapr `
    --dapr-app-port 5002 `
    --dapr-app-id 'dapr-demo-message-service'

    az containerapp create `
    --name dapr-demo-message-service-2 `
    --resource-group $rgName `
    --environment $environmentName `
    --image ghcr.io/whiteducksoftware/dapr-demo/message-service:latest `
    --min-replicas 1 `
    --max-replicas 1 `
    --enable-dapr `
    --dapr-app-port 5003 `
    --dapr-app-id dapr-demo-message-service-2

az containerapp create `
    --name client `
    --resource-group $rgName `
    --environment $environmentName `
    --image ghcr.io/whiteducksoftware/dapr-demo/client:latest `
    --target-port 50001 `
    --ingress 'external' `
    --min-replicas 1 `
    --max-replicas 1
    # --enable-dapr `
    # --dapr-app-port 50001 `
    # --dapr-app-id client