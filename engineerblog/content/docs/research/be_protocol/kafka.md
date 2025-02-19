---
title: "Kafka - Draft"
weight: 10
date: 2025-02-12
---

# Kafka

- Consumers keep track of message retrieval with an offset tracker
- Retain messages according to the retention policy
- There is no message priority

## Demo

```yml
# docker-compose.yml
services:
  zookeeper:
    image: wurstmeister/zookeeper
    container_name: zookeeper
    ports:
      - "2181:2181"
  kafka:
    image: wurstmeister/kafka
    container_name: kafka
    ports:
      - "9092:9092"
      - "29094:29094"
    environment:
      KAFKA_ADVERTISED_HOST_NAME: kafka 
      KAFKA_ZOOKEEPER_CONNECT: zookeeper:2181
      KAFKA_LISTENERS: LISTENER_BOB://kafka:29092,LISTENER_FRED://kafka:9092,LISTENER_ALICE://kafka:29094
      KAFKA_ADVERTISED_LISTENERS: LISTENER_BOB://kafka:29092,LISTENER_FRED://localhost:9092,LISTENER_ALICE://never-gonna-give-you-up:29094
      KAFKA_LISTENER_SECURITY_PROTOCOL_MAP: LISTENER_BOB:PLAINTEXT,LISTENER_FRED:PLAINTEXT,LISTENER_ALICE:PLAINTEXT
      KAFKA_INTER_BROKER_LISTENER_NAME: LISTENER_BOB
    depends_on:
      - zookeeper
  kafka-ui:
    image: provectuslabs/kafka-ui
    container_name: kafka-ui
    ports:
      - "9091:8080" # -> localhost:9091
    depends_on:
      - kafka
      - zookeeper
    environment:
      KAFKA_CLUSTERS_0_NAME: local
      KAFKA_CLUSTERS_0_BOOTSTRAP_SERVERS: kafka:29092  
      KAFKA_CLUSTERS_0_ZOOKEEPER: zookeeper:2181
```

## Reference

- Dev: [How to integrate kafka with nodejs ?](https://dev.to/chafroudtarek/how-to-integrate-kafka-with-nodejs--4bil) (Jan 9th, 2023)
- Robin Moffatt: [Kafka Listeners - Explained](https://rmoff.net/2018/08/02/kafka-listeners-explained/) (Aug 2nd, 2018)

{{< footer >}}
