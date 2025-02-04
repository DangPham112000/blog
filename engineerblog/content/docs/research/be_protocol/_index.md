---
title: "Backend"
weight: 40
date: 2024-04-15T01:47:46+07:00
---

# Backend

## What is a protocol?

- A system that allows two parties to communicate
- A protocol is designed with a set of properties
- Depending on the purpose of the protocol
- [TCP, UDP](/docs/research/be_protocol/tcp_udp), [HTTP](/docs/research/be_protocol/http), [gRPC](/docs/research/be_protocol/grpc), FTP
- The application protocols (HTTP/1.1, HTTP/2, HTTP/3) run on top of transport protocols (TCP, UDP)

## Protocol properties

- Data format
  - Text based (plain text, JSON, XML)
  - Binary (protobuf, RESP, h2, h3)
- Transfer mode
  - Message based (UDP, HTTP)
  - Stream (TCP, [WebRTC](/docs/research/be_protocol/webrtc))
- Addressing system
  - DNS name, IP, MAC
- Directionality
  - Bidirectional (TCP)
  - Unidirectional (HTTP)
  - Full/Half duplex
- State
  - Stateful (TCP, gRPC, apache thrift)
  - Stateless (UDP, HTTP)
- Routing
  - Proxies, Gateways
- Flow & Congestion control
  - TCP (Flow & Congestion)
  - UDP (No control)
- Error management
  - Error code
  - Retries and timeouts

## Why do we need a communication model?

- Agnostic applications
  - App doesn’t need to to know network medium
  - Otherwise we need an App for WIFI, ethernet vs LTE vs fiber
- Network Equipment Management
  - Without a standard model, upgrading network equipments becomes difficult
  - Decoupled Innovation
- Innovations can be done in each layer separately without affecting the rest of the models

## OSI Model

7 Layers each describe a specific networking component:

- Layer 7: Application - HTTP/FTP/gRPC
- Layer 6: Presentation - Encoding, Serialization
- Layer 5: Session - Connection establishment, TLS
- Layer 4: Transport - UDP/TCP
- Layer 3: Network - IP
- Layer 2: Data link - Frames, Mac address Ethernet
- Layer 1: Physical - Electric signals, fiber or radio waves

![osi](/research/be_protocol/index/osi.png)
![osi_2](/research/be_protocol/index/osi_2.png)

### Data across network

![data_across_network](/research/be_protocol/index/data_across_network.png)
![data_across_network_2](/research/be_protocol/index/data_across_network_2.png)

## TCP/IP Model

Much simpler than OSI just 4 layers

![tcp_ip](/research/be_protocol/index/tcp_ip.png)

### Why

- OSI Model has too many layers which can be hard to comprehend
- Hard to argue about which layer does what
- Simpler to deal with Layers 5-6-7 as just one layer, application
- TCP/IP Model does just that

## Reference

- Geeksforgeeks: [TCP/IP Model](https://www.geeksforgeeks.org/tcp-ip-model/) (21 Jul, 2023)
- Udemy: [Fundamentals of Backend Engineering](https://www.udemy.com/course/fundamentals-of-backend-communications-and-protocols) (Feb, 2024)
