import express from "express";

const app = express();
app.use(express.json({ type: "application/*+json" }));

const port = 5005;

app.get("/dapr/subscribe", (req, res) => {
  res.json([
    {
      pubsubname: "dapr-demo-pubsub",
      topic: "dapr-demo-messages",
      route: "messageendpoint",
    },
  ]);
});

app.post("/messageendpoint", (req, res) => {
  console.log(req.body.data.text);
  res.sendStatus(200);
});

app.listen(port, () => console.log(`consumer app listening on port ${port}!`));
