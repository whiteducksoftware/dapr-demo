dapr run `
    --app-id dapr-demo-notification-service `
    --app-port 5005 `
    --components-path ../../dapr/components/local `
    ts-node app.ts
