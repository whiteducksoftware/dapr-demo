# Dapr demo

This repository contains a simple demo to show how [dapr](https://dapr.io/) can help implementing a polyglott microservice based architecture.

The demo consists of three applications.

- **Client**: Written in _Go_, uses dapr **service invocation** to talk to the MessageService over _GRPC_.
- **MessageService**: Written in _C# .NET 5_, uses dapr **state management** to persist state and also uses the **publish & subscribe** building block to publish messages.
- **NotificationService**: Written in _TypeScript / Node.js_, uses the **publish & subscribe** building block to subscribe on messages from the MessageService and outputs them on the console.

![architecture](./assets/architecture.png)

## Prerequisites

- [.NET 5.0](https://dotnet.microsoft.com/download/dotnet/5.0)
- [Go](https://golang.org/)
- [Node.js with NPM](https://nodejs.org/en/)
- [Dapr](https://dapr.io/)

The applications also rely on preconfigured dapr components (e. g. a state configuration with the name `statestore` and a publish & subscribe configuration with the name `pubsub`) which reflects the default configuration that is provided from the dapr installer.

## Usage

### Start the NotificationService

First, you will have to **install the necessary npm packages**:

```bash
npm install
```

If you are on Windows or if you have PowerShell Core installed, you can use the `run.ps1` to start the application:

```powershell
cd ./services/notificationservice
./run.ps1
```

Otherwise, start the application using the dapr cli:

```bash
dapr run \
    --app-id demo-dapr-notificationservice \
    --app-port 5005 \
    ts-node app.ts
```

### Start the MessageService

If you are on Windows or if you have PowerShell Core installed, you can use the `run.ps1` to start the application:

```powershell
cd ./services/messageservice
./run.ps1
```

Otherwise, start the application using the dapr cli:

```bash
dapr run \
    --app-id demo-dapr-messageservice \
    --app-port 5002 \
    --app-protocol grpc \
    dotnet run
```

### Start the Client

If you are on Windows or if you have PowerShell Core installed, you can use the `run.ps1` to start the application:

```powershell
cd ./services/client
./run.ps1
```

Otherwise, start the application using the dapr cli:

```bash
dapr run \
    --app-id demo-dapr-client \
    go run main.go
```

If everything was setup up correctly, you should see the following output:
![output](./assets/output.png)
