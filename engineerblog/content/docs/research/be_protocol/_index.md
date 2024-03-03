---
title: "Backend Protocol"
weight: 20
date: 2023-11-15T01:47:46+07:00
---

# Backend Protocol

## What is a protocol?

- A system that allows two parties to communicate
- A protocol is designed with a set of properties
- Depending on the purpose of the protocol
- TCP, UDP, HTTP, gRPC, FTP
- The application protocols (HTTP/1.1, HTTP/2, HTTP/3) run on top of transport protocols (TCP, UDP)

## Protocol properties

- Data format
  - Text based (plain text, JSON, XML)
  - Binary (protobuf, RESP, h2, h3)
- Transfer mode
  - Message based (UDP, HTTP)
  - Stream (TCP, WebRTC)
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

7 Layers each describe a specific networking component

Layer 7 - Application - HTTP/FTP/gRPC

Layer 6 - Presentation - Encoding, Serialization

Layer 5 - Session - Connection establishment, TLS

Layer 4 - Transport - UDP/TCP

Layer 3 - Network - IP

Layer 2 - Data link - Frames, Mac address Ethernet

Layer 1 - Physical - Electric signals, fiber or radio waves

## TCP/IP Model

Much simpler than OSI just 4 layers

- Application (Layer 5, 6 and 7)
- Transport (Layer 4)
- Internet (Layer 3)
- Data link (Layer 2)
- Physical layer is not officially covered in the model
