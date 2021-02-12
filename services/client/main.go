package main

import (
	"context"

	dapr "github.com/dapr/go-sdk/client"
)

func main() {
	// just for this demo
	ctx := context.Background()

	// create the client
	client, err := dapr.NewClient()
	if err != nil {
		panic(err)
	}
	defer client.Close()

	nico := &dapr.DataContent{
		ContentType: "application/json",
		Data:        []byte(`{ "Id": 1, "Name": "Nico Meisenzahl" }`),
	}
	client.InvokeMethodWithContent(ctx, "containerconf-dapr-messageservice", "createuser", "post", nico)

	martin := &dapr.DataContent{
		ContentType: "application/json",
		Data:        []byte(`{ "Id": 2, "Name": "Martin Brandl" }`),
	}
	client.InvokeMethodWithContent(ctx, "containerconf-dapr-messageservice", "createuser", "post", martin)

	message := &dapr.DataContent{
		ContentType: "application/json",
		Data:        []byte(`{ "FromUser": 2, "ToUser": 1, "Text": "Quak, quak." }`),
	}
	client.InvokeMethodWithContent(ctx, "containerconf-dapr-messageservice", "sendmessage", "post", message)

}
