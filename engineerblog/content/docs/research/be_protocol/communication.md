---
title: "Communication - Draft"
weight: 8
date: 2023-11-15T01:47:46+07:00
---

# Communication

## Request-Response

![request_response](/research/be_protocol/communication/request_response.png)

### Overview

- Fundamental communication pattern
- The most common patterns for communication in client-server architectures

### Demo

{{<details title="Server code" open=false >}}
```js
// server.js
const http = require('http');

const server = http.createServer((req, res) => {
    console.log(`Received request: ${req.method} ${req.url}`);

    if (req.url === '/hello') {
        if (req.method === 'POST') {
            let body = '';

            req.on('data', chunk => {
                body += chunk.toString(); // Convert buffer to string
            });

            req.on('end', () => {
                res.writeHead(200, { 'Content-Type': 'text/plain' });
                if (body.trim() === "ping") {
                    res.end('pong');
                } else {
                    res.end('');
                }
            });

        } else {
            res.writeHead(200, { 'Content-Type': 'text/plain' });
            res.end('world');
        }
    } else {
        res.writeHead(404, { 'Content-Type': 'text/plain' });
        res.end('Not Found');
    }
});

server.listen(2000, () => {
    console.log('Server is listening on port 2000');
});
```
{{</details>}}

{{<nl>}}

{{<details title="Client code" open=false >}}
```js
fetch('http://localhost:2000/hello', {
    method: 'POST',
    headers: { 'Content-Type': 'text/plain' },
    body: 'ping'
})
.then(response => response.text())
.then(data => console.log(data))  // Should log: "pong"
```
{{</details>}}

{{<nl>}}

{{<details title="Instruction" open=false >}}
1. Start the server by running `node server.js`\
    1.1. Your terminal will display: `Server is listening on port 2000`
2. Open your browser and enter: `http://localhost:2000/hello`\
    2.1. Your terminal will first log: `Received request: GET /hello`\
    2.2. Then, your browser will display: `world`
3. Open the browser console and run **Client code**\
    3.1. Your terminal will first log: `Received request: POST /hello`\
    3.2. Then, your browser console will display: `pong`
{{</details>}}

## Short Polling

![short_polling](/research/be_protocol/communication/short_polling.png)

### Overview

- Based on the Request-Response design pattern
- Continuously polls the server for new updates
- Near real-time updates
- Client controls the frequency

### Use case

- Monitor stocks or cryptocurrencies
- Fetch status updates
- User notifications

### Demo


{{<details title="Server code" open=false >}}
```js
// server.js
const express = require('express');
const app = express();
const port = 2000;

app.get('/', (req, res) => {
    res.send('Hello world');
});

app.get('/bitcoin', (req, res) => {
    const randomValue = Math.floor(Math.random() * 111) - 10; // Random value between -10 and +100
    res.json({ coins: randomValue });
});

app.listen(port, () => {
    console.log(`Server is running at http://localhost:${port}`);
});
```
{{</details>}}

{{<nl>}}

{{<details title="Client code" open=false >}}
```js
function fetchBitcoinData() {
    fetch('http://localhost:2000/bitcoin')
        .then(response => response.json())
        .then(data => {
            console.log(`Bitcoin value: ${data.coins}`);
        });
}

setInterval(fetchBitcoinData, 1000);
```
{{</details>}}

{{<nl>}}

{{<details title="Instruction" open=false >}}
1. Start the server by running `node server.js`\
    1.1. Your terminal will display: `Server is running at http://localhost:2000`
2. Open your browser and enter: `http://localhost:2000`\
    2.1. Your browser will display: `Hello world`
3. Open the browser console and run **Client code**\
    3.1. Your browser console will continuously display: 
    ```text
    >> Bitcoin value: 10
    >> Bitcoin value: 100
    >> Bitcoin value: 26
    >> Bitcoin value: -6
    >> Bitcoin value: 65
    ...
    ```
{{</details>}}

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

- Freecodecamp: [Communication Design Patterns for Backend Development](https://www.freecodecamp.org/news/communication-design-patterns-for-backend-development/) (Sep 12th, 2023)
- Udemy: [Fundamentals of Backend Engineering](https://www.udemy.com/course/fundamentals-of-backend-communications-and-protocols) (Feb, 2024)
- Linkedin: [Understanding Short Polling: A Simple Backend Communication Pattern](https://www.linkedin.com/pulse/understanding-short-polling-simple-backend-pattern-rubayet-mnwec/) (Aug 7th, 2024)
- Amazon: [Message Queues](https://aws.amazon.com/message-queue/)
