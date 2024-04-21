---
title: "HTTP - Draft"
weight: 2
date: 2023-11-15T01:47:46+07:00
---

# HTTP

## HTTP 1.0

Every request to the same server requires a separate TCP connection

{{< columns >}}
![1.0](/research/be_protocol/http/1.0.png)
<--->
![1.0_2](/research/be_protocol/http/1.0_2.png)
{{</ columns >}}

## HTTP 1.1

Was published in 1997

A TCP connection can be left open for reuse (persistent connection)

![1.1](/research/be_protocol/http/1.1.png)

### HTTP pipelining

HTTP pipelining is a feature of HTTP/1.1, which allows multiple HTTP requests to be sent over a single TCP connection without waiting for the corresponding responses. HTTP/1.1 requires servers to respond to pipelined requests correctly

## HOL (head-of-line) blocking issue

When the number of allowed parallel requests in the browser is used up, subsequent requests need to wait for the former ones to complete

## HTTP 2.0

Was published in 2015

It addresses HOL issue through request multiplexing, which eliminates HOL blocking at the application layer, but HOL still exists at the transport (TCP) layer. As you can see in the diagram, HTTP 2.0 introduced the concept of HTTP “streams”: an abstraction that allows multiplexing different HTTP exchanges onto the same TCP connection. Each stream doesn’t need to be sent in order

![2](/research/be_protocol/http/2.png)

## HTTP 3.0

HTTP over QUIC

- Was published in 2020
- It is the proposed successor to HTTP 2.0. It uses QUIC instead of TCP for the underlying transport protocol, thus removing HOL blocking in the transport layer
- QUIC is based on UDP. It introduces streams as first-class citizens at the transport layer. QUIC streams share the same QUIC connection, so no additional handshakes and slow starts are required to create new ones, but QUIC streams are delivered independently such that in most cases packet loss affecting one stream doesn't affect others

![quic](/research/be_protocol/http/quic.png)

## Reference

- Upwork: [What is the HTTP/2 Protocol? Overview and Examples](https://www.upwork.com/resources/what-is-http2) (Aug 23, 2021)
- Alex Xu: System design interview 0 (2022)
- Mozilla: [Connection management in HTTP/1.x](https://developer.mozilla.org/en-US/docs/Web/HTTP/Connection_management_in_HTTP_1.x) (May 10, 2023)
