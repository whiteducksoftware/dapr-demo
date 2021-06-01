Set-Location ../../../services/client

dapr run `
    --app-id dapr-demo-client `
    --components-path ../../dapr/self-hosted/local `
    go run main.go
