dapr run `
    --app-id dapr-demo-message-service `
    --app-port 5002 `
    --app-protocol grpc `
    --components-path ../../dapr/components/cloud `
    dotnet run
