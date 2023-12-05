---
title: "Process vs Thread"
weight: 20
date: 2023-12-05T01:47:46+07:00
---

# Process vs Thread

## Program

A **Program** is an executable file containing a set of instructions and passively stored on disk

![program](/research/process_vs_thread/program.png)

## Process

A **Process** means a program is in execution. When a program is loaded into the memory and becomes active, the program becomes a process or processes

![process](/research/process_vs_thread/process.png)

## Thread

A **Thread** is the smallest unit of execution within a process

![program_process_thread](/research/process_vs_thread/program_process_thread.png)

## Process vs Thread

### Process

The process requires some essential resources such as registers, program counter, and stack

![process_resouces](/research/process_vs_thread/process_resouces.png)

Each process has its own memory address space. One process can not corrupt the memory address space of another process. This means that when one process malfunctions, other processes keep running

![malfunction_process](/research/process_vs_thread/malfunction_process.png)

### Thread

A process has at least one thread. It’s called the **main thread**. It’s **not uncommon** for a process to have many threads

Each thread has its own stack. Earlier we mentioned **registers, program counters and stack pointers** as being part of a process. It’s more accurate to say that those things **belong to a thread**

![thread_resources](/research/process_vs_thread/thread_resources.png)

{{<hint info>}}
Threads within a process share a memory address space
{{</hint>}}

It’s possible to communicate between threads using that shared memory space.
However, one misbehaving thread could bring down the entire process

![shared_memory](/research/process_vs_thread/shared_memory.png)

### Code demo

{{<details title="When one **process** malfunctions, other processes keep running" >}}
**Nodejs**

```javascript
const cluster = require("cluster");

if (cluster.isMaster) {
  // Master process logic
  console.log("Master process", process.pid, "is running");

  const normalSlave = cluster.fork();
  const misbehavingSlave = cluster.fork();

  misbehavingSlave.send({ isNormal: false });
  normalSlave.send({ isNormal: true });

  setInterval(() => {
    console.log("Master process", process.pid, "is doing some work.");
  }, 300);
} else {
  // Slave process logic
  console.log("Slave process", process.pid, "is running");

  process.on("message", ({ isNormal }) => {
    if (isNormal) {
      setInterval(() => {
        console.log("Slave process", process.pid, "is doing some work.");
      }, 300);
    } else {
      setTimeout(() => {
        throw new Error("Slave process " + process.pid + " is corrupted!!!");
      }, 2000);
    }
  });
}
```

{{</details>}}
{{<nl>}}
{{<details title="One misbehaving **thread** could bring down the entire process">}}
**Nodejs**

```javascript
const { Worker } = require("worker_threads");

console.log("Process", process.pid, "starts");

// Create a misbehaving worker thread
const misbehavingWorker = new Worker(
  `
  const { threadId } = require('worker_threads');

  console.log('Thread', threadId, 'from process', process.pid, 'starts');
  
  // Intentionally cause an unhandled exception
  setTimeout(() => {
      throw new Error('Thread ' + threadId + ' is corrupted!!!');
  }, 2000);
  `,
  { eval: true }
);

// Create a normal worker thread
const normalWorker = new Worker(
  `
  const { threadId } = require('worker_threads');

  console.log('Thread', threadId, 'from process', process.pid, 'starts');

  // Simulate normal work
  setInterval(() => {
    console.log('Thread', threadId, 'is doing some work.');
  }, 300);
  `,
  { eval: true }
);
```

{{</details>}}

## Reference
