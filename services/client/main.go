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

	fredDuck := &dapr.DataContent{
		ContentType: "application/json",
		Data:        []byte(`{ "Id": 1, "Name": "Fred Duck" }`),
	}
	client.InvokeMethodWithContent(ctx, "dapr-demo-message-service", "createuser", "post", fredDuck)

	johnDoe := &dapr.DataContent{
		ContentType: "application/json",
		Data:        []byte(`{ "Id": 2, "Name": "John Doe" }`),
	}
	client.InvokeMethodWithContent(ctx, "dapr-demo-message-service", "createuser", "post", johnDoe)

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
