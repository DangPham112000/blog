---
title: "Scale - draft"
weight: 1000
date: 2024-04-18T01:47:46+07:00
---

# Scale

## Monolith architecture

- The server in itself is capable and responsible for all the tasks that have to be performed and can perform every step needed to perform a function
- Tasks: Authorization, Presentation, Database, Business

### Server side rendering (SSR)

![SSR](/research/scale/SSR.png)

## Splitting server

### Database splitting

![database_splitting](/research/scale/database_splitting.png)

- Assume your app have a stable traffic
- Your data is not maintain steady, it always grows up. So database is the first thing we need to splitting out from our server and be standalone
- For later you will need to upgrade your DB (whatever scale out or scale up)

### Client splitting && Client side rendering (CSR)

![CSR](/research/scale/CSR.png)

Example Flow:

1. The user enters `https://gg.com` in the browser bar
2. The user's browser send an request to google
3. GG's gateway receive this request first:
   1. Parse the request -> `{ method: GET, url: gg.com }` -> This request is belong to frontend
   2. Ask and receive index.html, css, js from gg's frontend server
   3. Response back these things to user
4. The user's browser receive materials and then render gg website
5. The user enters `The biggest butterfly` in the gg search
6. Gg website ask browser to send a request to gg\
   `{ method: POST, url: gg.com/api, body: The biggest butterfly }`
7. After receive this request, gateway routes it to the backend server due to path `/api`
8. Backend server progress the request, get some data from database and response back
9. The gg website using JS to rerender the interface corresponding with the response

### Mobile

![mobile](/research/scale/mobile.png)

In mobile architecture

- Application is already installed in the device, they not need an frontend server to serve interface anymore
- Only need backend server if it need to process some business, CRUD data, ...

## Scale

### Vertical

![vertical_scaling](/research/scale/vertical_scaling.png)

- Also called “scale up”
- Vertical scaling is based on the idea of adding more power(CPU, RAM) to existing systems, basically adding more resources
- Pros:
  - Simplicity: less complicated maintenance, less need for software changes, less complex process communication
  - Cost-effective: upgrading a pre-existing server costs less than purchasing a new one
- Cons:
  - Higher possibility for downtime
  - Single point of failure
  - Upgrade limitations

### Horizontal

![horizontal_scaling](/research/scale/horizontal_scaling.png)

- Also called “scale out”
- Horizontal scaling is based on the idea of adding more machines to our pool of resources.
- Pros:
  - Fewer periods of downtime
  - Increased resilience and fault tolerance
- Cons:
  - Increased complexity of maintenance and operation
  - Increased Initial costs

## Load balancer

- A load balancer is a device that sits between the user and the server group and acts as an invisible facilitator, ensuring that all resource servers are used equally

![load_balancer](/research/scale/load_balancer.png)

- Run application server maintenance or upgrades without application downtime
- Prevents traffic bottlenecks at any one server
- Route traffic through a group of network firewalls for additional security

### Algorithms

- **Round-robin**: Route traffic to the servers turn by turn or in a round-robin fashion
- **Weighted round-robin**: Servers with higher weights will receive more incoming application traffic
- **Least connection**: Which servers have the fewest active connections and sends traffic to those servers
- **Resource-based**: Check the server resources, such as its computing capacity and memory. Then, the load balancer checks the agent for sufficient free resources before distributing traffic to that server
- ...

## Database Scaling

### Replication

- All the slaves are connected with the master
- If the master DB goes down an eligible slave will hold the new master

![replication](/research/scale/replication.png)

- High Availability of data disasters recovery
- No downtime for maintenance (like backups index rebuilds and compaction)

### Sharding

- Sharding is a method for distributing large dataset and allocating it across multiple servers

![sharding](/research/scale/sharding.png)

#### How it work?

- Consistent Hashing

#### Simple example

- We have 3 databases (shards) store products, named from 0 to 2
- We using product id to determind which shard will be used
- Each product come to our servers:
  - id will mod with 3
  - If equal 0, shard 0 will be used to read or write this data
  - Similar to others

![sharding_eg](/research/scale/sharding_eg.png)

### Combination

![combination](/research/scale/combination.png)

## Caching

## CDN

## Data center

## Message queue

## Reference

- Geeksforgeeks: [What is a monolith server ?](https://www.geeksforgeeks.org/what-is-a-monolith-server/) (19 Nov, 2021)
- Cloudzero: [Horizontal Vs. Vertical Scaling: How Do They Compare?](https://www.cloudzero.com/blog/horizontal-vs-vertical-scaling/) (May 05, 2023)
- Amazon: [What is Load Balancing?](https://aws.amazon.com/what-is/load-balancing)
