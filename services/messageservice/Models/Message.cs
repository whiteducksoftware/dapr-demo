namespace Demo.Dapr.MessageService.Models
{

    public class Message
    {
        public int FromUser { get; set; }

        public int ToUser { get; set; }

        public string Text { get; set; }
    }
}