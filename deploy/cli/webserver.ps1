Write-host "Web Listener: Start"






try {
   $listener = New-Object System.Net.HttpListener
   $listener.Prefixes.Add('http://+:81/')  # Must GENAU mit der Angabe in NETSH übereinstimmen 
   $listener.Start()
}
catch {
   write-error "Unable to open listener. Check Admin permission or NETSH Binding"
   exit 1
}

Write-host "Web Listener listening"
$basename = (get-date -Format yyyyMMddHHmmss)
$count = 0


# app.get("/dapr/subscribe", (req, res) = > {
#       res.json([
#          {
#             pubsubname: "dapr-demo-pubsub",
#             topic: "dapr-demo-messages",
#             route: "messageendpoint",
#          },
#          ]);
#    });

# app.post("/messageendpoint", (req, res) = > {
#       console.log(req.body.data.text);
#       res.sendStatus(200);
#    });

while ($true) {

   # app.get("/dapr/subscribe", (req, res) = > {
   #       res.json([
   #          {
   #             pubsubname: "dapr-demo-pubsub",
   #             topic: "dapr-demo-messages",
   #             route: "messageendpoint",
   #          },
   #          ]);
   #    });
   
   $context = $listener.GetContext() # Warte auf eingehende Anfragen
   write-host "------- New Request ($count) arrived ------------"
   $request = $context.Request
   write-host (" URL.AbsoluteUri:" + $request.URL.AbsoluteUri)
   write-host (" HttpMethod     :" + $request.HttpMethod)
   if ($request.HasEntityBody) {
      write-host "Exporting Body"
      # converting streamreader to string
      $rcvStream = [System.IO.StreamReader]::new($context.Request.InputStream).ReadToEnd()
      $rcvStream | out-file -filepath ("request" + $basename + $count + ".txt")
   }
   else {
      write-host "No Body"
   }


   $subscribe = @(
      @{
         pubsubname = "dapr-demo-pubsub"
         topic      = "dapr-demo-messages"
         route      = "messageendpoint"
      }
   )

   $stringtest = $subscribe | ConvertTo-Json | out-string
   

   write-host "------- Sending OK Response ------------"
   $response = $context.Response
   $response.ContentType = 'text/plain'
   $message = "Anfrage verarbeitet"

   [byte[]] $buffer = [System.Text.Encoding]::UTF8.GetBytes($stringtest)
   $response.ContentLength64 = $buffer.length
   $response.OutputStream.Write($buffer, 0, $buffer.length)
   $response.OutputStream.close()
}

$listener.Stop()