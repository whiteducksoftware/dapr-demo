using System;
using System.Text.Json;
using System.Threading.Tasks;
using Dapr.AppCallback.Autogen.Grpc.v1;
using Dapr.Client;
using Dapr.Client.Autogen.Grpc.v1;
using Demo.Dapr.MessageService.Models;
using Google.Protobuf.WellKnownTypes;
using Grpc.Core;

namespace Demo.Dapr.MessageService
{
    public class MessageService : AppCallback.AppCallbackBase
    {
        readonly JsonSerializerOptions jsonOptions = new JsonSerializerOptions { PropertyNamingPolicy = JsonNamingPolicy.CamelCase };
        public const string StoreName = "dapr-demo-state-store";

        private readonly DaprClient _daprClient;

        public MessageService(DaprClient daprClient)
        {
            _daprClient = daprClient;
        }
        public override async Task<InvokeResponse> OnInvoke(InvokeRequest request, ServerCallContext context)
        {
            var response = new InvokeResponse();
            switch (request.Method)
            {
                case "createuser":
                    var user = JsonSerializer.Deserialize<User>(System.Text.Encoding.UTF8.GetString(request.Data.Value.Memory.ToArray()));
                    await CreateUserAsync(user);

                    break;

                case "sendmessage":
                    var message = JsonSerializer.Deserialize<Message>(System.Text.Encoding.UTF8.GetString(request.Data.Value.Memory.ToArray()));
                    await SendMessageAsync(message);

                    break;
            }

            return await Task.FromResult(response);
        }

        private async Task CreateUserAsync(User user)
        {
            Console.WriteLine($"Received user {JsonSerializer.Serialize(user)}");

            await _daprClient.SaveStateAsync(StoreName, user.Id.ToString(), user.Name);
        }

        private async Task SendMessageAsync(Message message)
        {
            var fromUser = await _daprClient.GetStateAsync<string>(StoreName, message.FromUser.ToString());
            var toUser = await _daprClient.GetStateAsync<string>(StoreName, message.ToUser.ToString());

            var eventData = new { Text = $"Message from {fromUser} to {toUser}: '{message.Text}'" };
            await _daprClient.PublishEventAsync("dapr-demo-pubsub", "dapr-demo-messages", eventData);
        }

        public override Task<ListTopicSubscriptionsResponse> ListTopicSubscriptions(Empty request, ServerCallContext context)
        {
            return Task.FromResult(new ListTopicSubscriptionsResponse());
        }

        public override async Task<TopicEventResponse> OnTopicEvent(TopicEventRequest request, ServerCallContext context)
        {
            return await Task.FromResult(default(TopicEventResponse));
        }
    }
}
