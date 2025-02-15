---
title: "TCP - UDP - Draft"
weight: 1
date: 2023-11-15T01:47:46+07:00
draft: true
---

# TCP - UDP

## UDP

User Datagram Protocol

### Overview

![udp](/research/be_protocol/tcp_udp/udp.png)

- Message Based Layer 4 protocol
- Ability to address processes in a host using ports
- Simple protocol to send and receive messages
- Prior communication not required (double edge sword)
- Stateless no knowledge is stored on the host
- 8 byte header Datagram

### Demo

```js
// server.js
import dgram from "dgram";

const socket = dgram.createSocket("udp4");
socket.bind(5500, "127.0.0.1");
socket.on("message", (msg, info) => {
  console.log(
    `My server got a datagram ${msg}, from ${info.address}:${info.port}`
  );
});
```

```shell
# client terminal
nc -u 127.0.0.1 5500
```

```shell
# client terminal
Hi
```

```shell
# client terminal
I am Dang
```

The result of the server log: (TBU)

## TCP

Transmission Control Protocol

### Overview

![tcp_handshake](/research/be_protocol/tcp_udp/tcp_handshake.png)

- Stream based Layer 4 protocol
- Ability to address processes in a host using ports
- “Controls” the transmission unlike UDP which is a firehose
- Connection
- Requires handshake
- 20 bytes headers Segment (can go to 60)
- Stateful

### 3 ways handshake

### Demo

```js
// server.js
import net from "net";

const server = net.createServer((socket) => {
  console.log(
    `TCP successfully handshack with ${socket.remoteAddress}:${socket.remotePort}`
  );
  socket.write("Hello Client!");
  socket.on("data", (data) => {
    console.log(`Received data ${data.toString()}`);
  });
  server.listen(6600, "127.0.0.1");
});
```

```shell
# client terminal
nc 127.0.0.1 6600
```

Client recieve message when successful establish the connection: (TBU)

```shell
# client terminal
This is data to send to the server!
```

## Reference

- Geeksforgeeks: [Differences between TCP and UDP](https://www.geeksforgeeks.org/differences-between-tcp-and-udp/) (06 May, 2023)
- Udemy: [Fundamentals of Backend Engineering](https://www.udemy.com/course/fundamentals-of-backend-communications-and-protocols) (Feb, 2024)
