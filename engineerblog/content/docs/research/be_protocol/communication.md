---
title: "Communication"
weight: 8
date: 2023-11-15T01:47:46+07:00
---

# Communication

## Request-Response

![request_response](/research/be_protocol/communication/request_response.png)

### Overview

The Request-Response pattern is a fundamental communication pattern where a client sends a request to a server, and the server processes the request and sends back a response. It's one of the most common patterns for communication in distributed systems, client-server architectures, and web applications.

## Push

Real time notification

![push](/research/be_protocol/communication/push.png)

### Overview

- Used by RabbitMQ

### Implementation

#### Concept:

- Client connects to a server
- Server sends data to the client
- Client doesn’t have to request anything
- Protocol must be bidirectional

#### Example code:

## Short Polling

Request is taking a while, I’ll check with you later

![short_polling](/research/be_protocol/communication/short_polling.png)

### Implementation

#### Concept:

- Client sends a request
- Server responds immediately with a handle
- Server continues to process the request
- Client uses that handle to check for status
- Multiple “short” request response as polls

## Long Polling

![long_polling](/research/be_protocol/communication/long_polling.png)

### Implementation

#### Concept:

- Client sends a request
- Server responds immediately with a handle
- Server continues to process the request
- Client uses that handle to check for status
- Server DOES not reply until it has the response
- So we got a handle, we can disconnect and we are less chatty
- Some variation has timeouts too

## Server sent events

![server_sent_events](/research/be_protocol/communication/server_sent_events.png)

### Implementation

#### Concept:

- A response has start and end
- Client sends a request
- Server sends logical events as part of response
- Server never writes the end of the response
- It is still a request but an unending response
- Client parses the streams data looking for events
- Works with request/response (HTTP)

## Message Queue

Asynchronous messaging for batching jobs and decoupling applications

![message_queue](/research/be_protocol/communication/message_queue.png)

### Overview

A message queue is a form of asynchronous service-to-service communication used in serverless and microservices architectures. Messages are stored on the queue until they are processed and deleted. Each message is processed only once, by a single consumer. Message queues can be used to decouple heavyweight processing, to buffer or batch work, and to smooth spiky workloads.

## Publish Subcribe

One publisher many readers

![pub_sub](/research/be_protocol/communication/pub_sub.png)

### Implementation

#### Concept:

## Reference

- Linkedin: [Backend Communication Design Patterns](https://www.linkedin.com/pulse/backend-communication-design-patterns-muhammad-iftekhar-ul-alam/) (Sep 13, 2023)
- Freecodecamp: [Communication Design Patterns for Backend Development](https://www.freecodecamp.org/news/communication-design-patterns-for-backend-development/)
- Amazon: [Message Queues](https://aws.amazon.com/message-queue/)
