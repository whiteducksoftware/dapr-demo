package main

import (
	"context"
	"strconv"
	"time"

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

	fredDuckleberry := &dapr.DataContent{
		ContentType: "application/json",
		Data:        []byte(`{ "Id": 1, "Name": "Fred Duckleberry" }`),
	}
	client.InvokeMethodWithContent(ctx, "dapr-demo-message-service", "createuser", "post", fredDuckleberry)

	fridaDuckleberry := &dapr.DataContent{
		ContentType: "application/json",
		Data:        []byte(`{ "Id": 2, "Name": "Frida Duckleberry" }`),
	}
	client.InvokeMethodWithContent(ctx, "dapr-demo-message-service", "createuser", "post", fridaDuckleberry)

	// keep sending messages for demo purposes
	for i := 0; i < 500; i++ {
		var counterAsString = strconv.Itoa(i)
		var messageData = `{ "FromUser": 2, "ToUser": 1, "Text": "Quak, quak ` + counterAsString + `." }`

		message := &dapr.DataContent{
			ContentType: "application/json",
			Data:        []byte(messageData),
		}
		client.InvokeMethodWithContent(ctx, "dapr-demo-message-service", "sendmessage", "post", message)

		time.Sleep(5 * time.Second)
	}
}
