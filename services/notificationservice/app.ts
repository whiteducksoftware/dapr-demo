import express from "express";
import bodyParser from "body-parser";

const app = express();
app.use(bodyParser.json({ type: "application/*+json" }));

const port = 5005;

app.get("/dapr/subscribe", (req, res) => {
  res.json([
    {
      pubsubname: "pubsub",
      topic: "message",
      route: "messageendpoint",
    },
  ]);
});

app.post("/messageendpoint", (req, res) => {
  console.log(req.body.data.text);
  res.sendStatus(200);
});

app.listen(port, () => console.log(`consumer app listening on port ${port}!`));
