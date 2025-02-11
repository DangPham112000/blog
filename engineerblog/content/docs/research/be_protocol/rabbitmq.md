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
- Route messages based on header values instead of routing keys

### Dead Letter Exchange

- Capture messages that are not deliverable

## Demo

![direct_demo](/research/be_protocol/rabbitmq/direct_demo.png)

Pull the official RabbitMQ image:

`sudo docker pull rabbitmq:4.0.5-management`

Start a RabbitMQ

`sudo docker run --name rabbitmq -p 5672:5672 -p 15672:15672 rabbitmq:4.0.5-management`

- `--name` assigns a name to the container
- `-p` maps the ports from the container to your host machine 
    - `5672` is for **RabbitMQ server**
    - `15672` is for **management UI**

Access the RabbitMQ Management Console:
- Open a web browser and navigate to `http://localhost:15672/`
- Log in with the default username `guest` and password `guest`

`AMQP` is the data transfer protocol for communication with RabbitMQ

## Reference

- Cloudamqp: [Part 4: RabbitMQ Exchanges, routing keys and bindings](https://www.cloudamqp.com/blog/part4-rabbitmq-for-beginners-exchanges-routing-keys-bindings.html) (Sep 24th, 2019)
- Youtube: [RabbitMQ basics (Including different exchange types + real use cases)](https://www.youtube.com/watch?v=i5G3uSGS7QQ) (Jun 2nd, 2022)
- Svix: [Running RabbitMQ in Docker: A Comprehensive Guide](https://www.svix.com/resources/guides/rabbitmq-docker-setup-guide/)
- Youtube: [NodeJs Microservices using RabbitMQ (Message Queueing)](https://www.youtube.com/watch?v=igaVS0S1hA4) (Jul 11th, 2022)

{{< footer >}}