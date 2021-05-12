Set-Location ../../../services/notificationservice

dapr run `
  --app-id dapr-demo-notification-service `
  --app-port 5005 `
  --components-path ../../dapr/self-hosted/local `
  npm run start
