---
title: "Scale"
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

Everything stored on frontend can be changed by the user so this is potential security vulnerability

This is the main difference between backend and frontend caching, backend caching can't be edited by the user

![caching](/research/scale/caching.png)

### Frontend

On the frontend, a browser or the client application caches data like a header image the first time your user accesses it. The next time they access that same content, the frontend loads the cached files to improve performance

#### Browser caching

Browser caching is a technique that allows you to store certain files, such as CSS, JavaScript, and images

#### CDN - Content Delivery Network

Implementing CDN caching requires integrating your website with a CDN provider. This involves configuring your DNS settings to point to the CDN’s servers and setting up caching rules to determine which files should be cached and for how long

### Backend

Backend development uses caching to reduce the load on the application server. What you store in the backend cache depends on your application itself. Cached content includes static pages, database query results, API responses, session data, images, and videos

## Appendix

{{<details title="**Ramble on about the limit of the speed of light**" open=false >}}

Quantum entanglement promises to enable instant communication or data transmission in the future, regardless of distance

However, as of now, we use fiber optic cables, and the latency is significantly higher when transfering data from a distant location compared to a nearby one

A question is: **Aren't data packets traveling at the speed of light?** If they did, would the difference in latency between close and far locations be significant?

For example:

- The distance from Ho Chi Minh City to New York is 14,275 km, or 14,275,000 meters
- The speed of light is approximately 300,000,000 m/s, or 300,000 meters per millisecond (m/ms)
- The time for a data packet to travel one way would be around 47.583 ms, so a round trip (sending and receiving) would take about 95 ms

But this is in an ideal scenario where:

- The server takes 0 ms to process the request and sends the response instantly
- The signal is traveling in a vacuum at the speed of light (300,000 m/ms)

In reality:

- The speed of data transmission through fiber optic cables is lower—around 200,000 kilometers per second, or 200,000 m/ms
- Even with a direct fiber optic connection between Ho Chi Minh City and a server in New York, the round trip would take at least 142.75 ms

So even with a direct connection to a New York server, I'd still be playing League of Legends with a ping of over 140 ms!

{{</details>}}

## Reference

- Geeksforgeeks: [What is a monolith server ?](https://www.geeksforgeeks.org/what-is-a-monolith-server/) (19 Nov, 2021)
- Cloudzero: [Horizontal Vs. Vertical Scaling: How Do They Compare?](https://www.cloudzero.com/blog/horizontal-vs-vertical-scaling/) (May 05, 2023)
- Amazon: [What is Load Balancing?](https://aws.amazon.com/what-is/load-balancing)
- Linkedin: [How Web is limited by the speed of light?](https://www.linkedin.com/pulse/internet-speed-light-viktor-turskyi-/) (May 16, 2022)

{{< footer >}}