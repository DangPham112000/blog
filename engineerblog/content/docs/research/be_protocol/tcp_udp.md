---
title: "TCP - UDP"
weight: 1
date: 2023-11-15T01:47:46+07:00
---

# TCP - UDP

## UDP

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
