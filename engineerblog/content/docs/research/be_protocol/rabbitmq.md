---
title: "RabbitMQ"
weight: 9
date: 2025-02-11
---

# RabbitMQ

![rabbitmq](/research/be_protocol/rabbitmq/rabbitmq.png)

- Producer sends and monitors if the message reaches the intended consumer
- Messages are deleted once consumed
- Designed for complex message routing
- Support message priorities

## Exchange types

- Direct Exchange
- Topic Exchange
- Fanout Exchange
- Headers Exchange
- Dead Letter Exchange

### Direct Exchange

- A message goes to the queue(s) with the **binding key** that **exactly matches** the **routing key** of the message

![direct](/research/be_protocol/rabbitmq/direct.png)

### Topic Exchange

- Route messages to queues based on **wildcard matches** between the **routing key** and the **binding pattern**

![topic](/research/be_protocol/rabbitmq/topic.png)

### Fanout Exchange

- Copy and route a message **to all queues**

![fanout](/research/be_protocol/rabbitmq/fanout.png)

### Headers Exchange

- Similar to topic exchanges
- Route messages based on **header values instead of routing keys**

### Dead Letter Exchange

- Capture messages that are not deliverable

## Demo

![direct_demo](/research/be_protocol/rabbitmq/direct_demo.png)

### Setup RabbitMQ Broker

1. Pull the official RabbitMQ image:
    ```sh
    sudo docker pull rabbitmq:4.0.5-management
    ```
2. Start a RabbitMQ:
    ```sh
    sudo docker run --name rabbitmq -p 5672:5672 -p 15672:15672 rabbitmq:4.0.5-management
    ```
    - `--name` assigns a name to the container
    - `-p` maps the ports from the container to your host machine 
        - `5672` is for **RabbitMQ server**
        - `15672` is for **management UI**
3. Access the RabbitMQ Management Console:
    - Open a web browser and navigate to [http://localhost:15672/](http://localhost:15672/)
    - Log in with the default username `guest` and password `guest`

### Setup services

- `AMQP` is the data transfer protocol for communication with RabbitMQ

{{<details title="**Prepare**" open=false >}}
```js
// config.js
module.exports = {
  rabbitMQ: {
    url: "amqp://localhost",
    exchangeName: "logExchange",
    exchangeType: "direct",
  },
};
```

You can run this code block bellow with **REST Client** VScode extension

```text
### post.http

@url=http://localhost:3000

### Info log
POST {{url}}/sendLog
Content-Type: application/json

{
    "logType": "Info",
    "message": "Everything works OK"
}

### Warning log
POST {{url}}/sendLog
Content-Type: application/json

{
    "logType": "Warning",
    "message": "Chrome is moving towards a new experience that allows users to choose to browse without third-party cookies"
}

### Error log
POST {{url}}/sendLog
Content-Type: application/json

{
    "logType": "Error",
    "message": "Unchecked runtime.lastError: The message port closed before a response was received"
}
```
{{</details>}}

{{<nl>}}

{{<details title="**Logger service**" open=false >}}
```js
// loggerService.js
const amqp = require("amqplib");
const config = require("./config");

class Producer {
  channel;

  async createChannel() {
    const rabbitmqUrl = config.rabbitMQ.url;
    const connection = await amqp.connect(rabbitmqUrl);
    this.channel = await connection.createChannel();
  }

  async publishMessage(routingKey, message) {
    if (!this.channel) {
      await this.createChannel();
    }

    const exchangeName = config.rabbitMQ.exchangeName;
    const exchangeType = config.rabbitMQ.exchangeType;
    await this.channel.assertExchange(exchangeName, exchangeType);

    const logDetails = {
      logType: routingKey,
      message: message,
      dateTime: new Date(),
    };
    await this.channel.publish(
      exchangeName,
      routingKey,
      Buffer.from(JSON.stringify(logDetails))
    );

    console.log(
      `The new ${routingKey} log is sent to exchange ${exchangeName}`
    );
  }
}

const express = require("express");
const app = express();
const producer = new Producer();

app.use(express.json());

app.post("/sendLog", async (req, res) => {
  await producer.publishMessage(req.body.logType, req.body.message);
  res.send();
});

app.listen(3000, () => {
  console.log("Server started...");
});
```
{{</details>}}

{{<nl>}}

{{<details title="**Info service**" open=false >}}
```js
// loggerService.js
const amqp = require("amqplib");
const config = require("./config");

async function consumeMessages() {
  const rabbitmqUrl = config.rabbitMQ.url;
  const connection = await amqp.connect(rabbitmqUrl);
  const channel = await connection.createChannel();

  const exchangeName = config.rabbitMQ.exchangeName;
  const exchangeType = config.rabbitMQ.exchangeType;
  await channel.assertExchange(exchangeName, exchangeType);

  const q = await channel.assertQueue("InfoQueue");

  await channel.bindQueue(q.queue, exchangeName, "Info");

  channel.consume(q.queue, (msg) => {
    const data = JSON.parse(msg.content);
    console.log(data);
    channel.ack(msg);
  });
}

consumeMessages();
```
{{</details>}}

{{<nl>}}

{{<details title="**Warning service**" open=false >}}
```js
// warningService.js
const amqp = require("amqplib");
const config = require("./config");

async function consumeMessages() {
  const connection = await amqp.connect(config.rabbitMQ.url);
  const channel = await connection.createChannel();

  const exchangeName = config.rabbitMQ.exchangeName;
  const exchangeType = config.rabbitMQ.exchangeType;
  await channel.assertExchange(exchangeName, exchangeType);

  const q = await channel.assertQueue("WarningQueue");

  await channel.bindQueue(q.queue, exchangeName, "Warning");
  await channel.bindQueue(q.queue, exchangeName, "Error");

  channel.consume(q.queue, (msg) => {
    const data = JSON.parse(msg.content);
    console.log(data);
    channel.ack(msg);
  });
}

consumeMessages();
```
{{</details>}}

1. Create a folder to hold all services in one place, such as `RabbitMQ_Demo`
2. Initialize Node.js with: `npm init -y`
3. Install necessary libraries:
    - `amqplib`: `npm i amqplib`
    - `express`: `npm i express`
4. Prepare the necessary files: `config.js`, `post.http`, `loggerService.js`, `infoService.js`, and `warningService.js` 
5. Start the services: 
    - Logger service: `node loggerService.js`
    - Info service: `node infoService.js`
    - Warning service: `node warningService.js`

### Scenario

- Send info, warning, or error messages to the Logger service
    - **Expect**: They are routed to the corresponding consumer services
- Try sending some messages with a logType that does not exist in any services
    - **Expect**: The logger service announces that the message was sent to the Exchange, but none of the consumer services receive the message
- Try commenting out the code line in the Consumer service's code block: `channel.ack(msg);`
    - **Expect**: Consumer services receive messages normally, but when we start them again, they will receive all unacknowledged messages again

## Reference

- Cloudamqp: [Part 4: RabbitMQ Exchanges, routing keys and bindings](https://www.cloudamqp.com/blog/part4-rabbitmq-for-beginners-exchanges-routing-keys-bindings.html) (Sep 24th, 2019)
- Youtube: [RabbitMQ basics (Including different exchange types + real use cases)](https://www.youtube.com/watch?v=i5G3uSGS7QQ) (Jun 2nd, 2022)
- Svix: [Running RabbitMQ in Docker: A Comprehensive Guide](https://www.svix.com/resources/guides/rabbitmq-docker-setup-guide/)
- Youtube: [NodeJs Microservices using RabbitMQ (Message Queueing)](https://www.youtube.com/watch?v=igaVS0S1hA4) (Jul 11th, 2022)

{{< footer >}}