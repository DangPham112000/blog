---
title: "Communication"
weight: 8
date: 2023-11-15
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

### Overview

- Based on the Request-Response design pattern
- Holds the request open and only responds after completing the task 
- Real-time updates
- Server controls the timing of response

### Use case

- Fetch status updates
- User notifications

### Demo

{{<details title="Server code" open=false >}}
```js
// server.js
const express = require('express');
const app = express();
const port = 2000;

app.use(express.json());

app.get('/', (req, res) => {
    res.send('Hello world');
});

app.post('/validate-music', (req, res) => {
    const { musicName, capacity } = req.body;

    // Simulate processing time with a random delay between 5 to 10 seconds
    const delay = Math.floor(Math.random() * 6) + 5;

    console.log(`Received request to validate music: ${musicName}, capacity: ${capacity}`);
    
    setTimeout(() => {
        res.json({ message: `The music "${musicName}" is valid.` });
    }, delay * 1000);
});

app.listen(port, () => {
    console.log(`Server is running at http://localhost:${port}`);
});
```
{{</details>}}

{{<nl>}}

{{<details title="Client code" open=false >}}
```js
function validateMusic(musicName, capacity) {
    fetch('http://localhost:2000/validate-music', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json'
        },
        body: JSON.stringify({ musicName, capacity })
    })
    .then(response => response.json())
    .then(data => {
        console.log(data.message);
    });
}
  
validateMusic('Supernova', '5MB');
```
{{</details>}}

{{<nl>}}

{{<details title="Instruction" open=false >}}
1. Start the server by running `node server.js`\
    1.1. Your terminal will display: `Server is running at http://localhost:2000`
2. Open your browser and enter: `http://localhost:2000`\
    2.1. Your browser will display: `Hello world`
3. Open the browser console and run **Client code**\
    3.1. Your terminal will first log: `Received request to validate music: Supernova, capacity: 5MB`\
    3.2. Then, your browser console after some seconds will display: `The music "Supernova" is valid.`
{{</details>}}

## Push

![push](/research/be_protocol/communication/push.png)

### Overview

- **Bidirectional** communication
- Real-time updates

### Use case

- Chat and messaging apps
- Notification systems

### Demo

{{<details title="Server code" open=false >}}
```js
// server.js
const http = require('http');
const WebSocket = require('ws');
const port = 2000;

// Create an HTTP server
const server = http.createServer((req, res) => {
    if (req.url === '/') {
        res.writeHead(200, { 'Content-Type': 'text/plain' });
        res.end('Hello, World!');
    } else {
        res.writeHead(404, { 'Content-Type': 'text/plain' });
        res.end('Not Found');
    }
});

// Create a WebSocket server on top of the HTTP server
const wss = new WebSocket.Server({ server });

wss.on('connection', ws => {
    console.log('Client connected the WebSocket connection');

    ws.on('message', message => {
        console.log(`Received: ${message}`);
        
        // Simulating music validation process
        let progress = 0;

        const interval = setInterval(() => {
            progress += Math.floor(Math.random() * 10) + 10; // Random progress between 10% - 20%
            if (progress >= 100) {
                progress = 100;
                ws.send(JSON.stringify({ status: 'complete', message: 'Music validation complete and valid!' }));
                clearInterval(interval);
            } else {
                ws.send(JSON.stringify({ status: 'in-progress', progress: progress }));
            }
        }, 1000);
    });

    ws.on('close', () => {
        console.log('Client disconnected the WebSocket connection');
    });
});

server.listen(port, () => {
    console.log(`Server running on http://localhost:${port}`);
    console.log(`WebSocket server running on ws://localhost:${port}`);
});
```
{{</details>}}

{{<nl>}}

{{<details title="Client code" open=false >}}
```js
const socket = new WebSocket('ws://localhost:2000');

socket.onmessage = function(event) {
    const data = JSON.parse(event.data);
    if (data.status === 'in-progress') {
        console.log(`Validation progress: ${data.progress}%`);
    } else if (data.status === 'complete') {
        console.log(data.message);
        socket.close();
    }
};

socket.onopen = function() {
    console.log('Connected to the server');
    // Simulating a music upload with a title and arbitrary size
    const musicData = {
        title: 'My Awesome Track',
        size: 1234
    };
    socket.send(JSON.stringify(musicData));
};

socket.onclose = function() {
    console.log('Disconnected the WebSocket connection from the server');
};
```
{{</details>}}

{{<nl>}}

{{<details title="Instruction" open=false >}}
1. Start the server by running `node server.js`\
    1.1. Your terminal will display:
    ```text
    Server running on http://localhost:2000
    WebSocket server running on ws://localhost:2000
    ```
2. Open your browser and enter: `http://localhost:2000`\
    2.1. Your browser will display: `Hello world`
3. Open the browser console and run **Client code**\
    3.1. Your terminal will first log: 
    ```text
    Client connected the WebSocket connection
    Received: {"title":"My Awesome Track","size":1234}
    ```
    3.2. Then, your browser console will display: 
    ```text
    >> Connected to the server
    >> Validation progress: 18%
    >> Validation progress: 28%
    >> Validation progress: 39%
    >> Validation progress: 50%
    >> Validation progress: 65%
    >> Validation progress: 80%
    >> Validation progress: 97%
    >> Music validation complete and valid!
    >> Disconnected the WebSocket connection from the server
    ```
{{</details>}}

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

## Reference

- Freecodecamp: [Communication Design Patterns for Backend Development](https://www.freecodecamp.org/news/communication-design-patterns-for-backend-development/) (Sep 12th, 2023)
- Udemy: [Fundamentals of Backend Engineering](https://www.udemy.com/course/fundamentals-of-backend-communications-and-protocols) (Feb, 2024)
- Linkedin: [Understanding Short Polling: A Simple Backend Communication Pattern](https://www.linkedin.com/pulse/understanding-short-polling-simple-backend-pattern-rubayet-mnwec/) (Aug 7th, 2024)
- Amazon: [Message Queues](https://aws.amazon.com/message-queue/)

{{< footer >}}
