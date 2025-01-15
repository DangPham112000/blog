---
title: "Process vs Thread"
weight: 10
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

It’s possible to communicate between threads using that shared memory space
However, one misbehaving thread could bring down the entire process

![shared_memory](/research/process_vs_thread/shared_memory.png)

### Code demo

{{<details title="When one **process** malfunctions, other processes keep running" open=false >}}
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
{{<details title="One misbehaving **thread** could bring down the entire process" open=false >}}
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

## Multithreading and Multiprocessing

### Concurrency and Parallelism

**Concurrency** allows multiple tasks to make progress by interleaving their execution, even if they are not executing simultaneously. It is focused on efficient task scheduling and resource utilization

![concurrency](/research/process_vs_thread/concurrency.png)

**Parallelism** involves executing multiple tasks simultaneously, typically on separate processing units or cores. It aims to achieve higher performance and faster task completion

![parallelism](/research/process_vs_thread/parallelism.png)

### Multithreading

Multithreading focuses on generating computing threads from a single process, whereas multiprocessing increases computing power by adding processors

![multithreading](/research/process_vs_thread/multithreading.png)

### Multiprocessing

Multiprocessing uses two or more processors to increase computing power, whereas multithreading uses a single process with multiple code segments to increase computing power

![multiprocessing](/research/process_vs_thread/multiprocessing.png)

### Code demo

{{<details title="Prepared files" open=false >}}
**Nodejs**

`k.js`

```js
const CPUS = require("os").cpus();
const NUM_CPU = CPUS.length;
const TOTAL_OBJS = 10000000;
const numWorkers = NUM_CPU;
const workload = TOTAL_OBJS / numWorkers;

module.exports = {
  CPUS,
  NUM_CPU,
  TOTAL_OBJS,
  numWorkers,
  workload,
};
```

`_.js`

```js
const generateRandomName = () => {
  const names = [
    "Alice",
    "Bob",
    "Charlie",
    "David",
    "Eve",
    "Frank",
    "Grace",
    "Henry",
    "Ivy",
    "Jack",
  ];
  return names[Math.floor(Math.random() * names.length)];
};

const generateRandomAge = () => {
  return Math.floor(Math.random() * 100) + 1;
};

const generateObjects = (count) => {
  const objects = [];
  for (let i = 0; i < count; i++) {
    const object = {
      name: generateRandomName(),
      age: generateRandomAge(),
      createTime: new Date(),
    };
    objects.push(object);
  }
  return objects;
};

class Logger {
  constructor(isEnable) {
    this.isEnable = !!isEnable;
  }
  isDebug = false;
  logP1(...args) {
    if (this.isEnable) {
      console.log(...args);
    }
  }
  debug(...args) {
    if (this.isDebug && this.isEnable) {
      console.log(...args);
    }
  }
}

const ts = () => new Date().getTime();

class Monitor {
  startTime;
  endTime;

  start() {
    this.startTime = ts();
  }

  end() {
    this.endTime = ts();
  }

  getTotal() {
    return this.endTime - this.startTime;
  }
}

module.exports = {
  Logger,
  Monitor,
  generateObjects,
};
```

`worker.js`

```js
const { generateObjects, Monitor, Logger } = require("../_");
const { workerData, parentPort, threadId } = require("worker_threads");

const monitor = new Monitor();
const logger = new Logger(true);

const { workload, isDebug } = workerData;
logger.isDebug = isDebug;

logger.debug("Worker", threadId, "of process", process.pid, "is running");

monitor.start();
const objects = generateObjects(workload);
monitor.end();

logger.debug(
  "Worker",
  threadId,
  "generated",
  objects.length,
  "in",
  monitor.getTotal(),
  "ms"
);

monitor.start();
parentPort.postMessage(objects);
monitor.end();
logger.debug("worker", threadId, "send data in", monitor.getTotal(), "ms");
```

{{</details>}}
{{<nl>}}
{{<details title="Single thread vs multithreading vs multiprocessing" open=false >}}
**Nodejs**

`singleThread.js`

```js
const { TOTAL_OBJS } = require("../k");
const { generateObjects, Monitor } = require("../_");

const monitor = new Monitor();

monitor.start();
const obj = generateObjects(TOTAL_OBJS);
monitor.end();

console.log("Generate", obj.length, "in", monitor.getTotal(), "ms");
```

`multithread.js`

```js
const { Worker } = require("worker_threads");

const { numWorkers, workload, TOTAL_OBJS } = require("../k");
const { Monitor, Logger } = require("../_");
let generatedObjects = [];
const monitor = new Monitor();
const logger = new Logger(true);

// set true to see more logs
logger.isDebug = true;

function runWorker(workerData) {
  return new Promise((resolve, reject) => {
    const worker = new Worker("./worker_threads/worker.js", { workerData });

    logger.debug("Worker", worker.threadId, "is running");

    worker.on("message", (message) => {
      generatedObjects = generatedObjects.concat(message);
    });

    worker.on("error", reject);
    worker.on("exit", (code) => {
      if (code === 0) {
        resolve();
      } else {
        reject(new Error(`Worker stopped with exit code ${code}`));
      }
    });
  });
}

async function generateObjectsWithWorkers() {
  const workers = [];

  monitor.start();
  for (let i = 0; i < numWorkers; i++) {
    const workerData = {
      workload,
      isDebug: logger.isDebug,
    };
    workers.push(runWorker(workerData));
  }

  await Promise.all(workers);
  monitor.end();
  logger.logP1(
    "All done!",
    numWorkers,
    "workers,",
    generatedObjects.length,
    "objects, in",
    monitor.getTotal(),
    "ms"
  );
}

generateObjectsWithWorkers();
```

`multiprocess.js`

```js
const cluster = require("cluster");

const { workload, numWorkers } = require("../k");
const { Monitor, Logger, generateObjects } = require("../_");

const logger = new Logger(true);
const monitor = new Monitor();

// set true to see more logs
logger.isDebug = true;

if (cluster.isMaster) {
  monitor.start();
  logger.logP1("Master", process.pid, "is running");

  // Fork slaves
  for (let i = 0; i < numWorkers; i++) {
    cluster.fork();
  }

  // Collect data from slaves
  let generatedObjects = [];
  cluster.on("message", (slave, message) => {
    generatedObjects = generatedObjects.concat(message);
  });

  //  Wait for all workers to finish logic
  let slaveOff = 0;
  cluster.on("disconnect", () => {
    slaveOff++;

    if (slaveOff === numWorkers) {
      monitor.end();
      logger.logP1(
        "All done!",
        slaveOff,
        "slaves, in",
        monitor.getTotal(),
        "ms"
      );
      // Exit the application
      process.exit(0);
    }
  });
} else {
  // Slave process logic
  logger.debug("Slave", process.pid, "is running");

  let generatedObjects = [];

  // Generate objects in the worker process
  monitor.start();
  const objects = generateObjects(workload);
  monitor.end();
  generatedObjects = generatedObjects.concat(objects);

  logger.debug(
    "Generated",
    objects.length,
    "objects in slave",
    process.pid,
    "in",
    monitor.getTotal(),
    "ms"
  );

  // Send objects to the master process
  monitor.start();
  process.send(objects);
  monitor.end();
  logger.debug("slave", process.pid, "send data in", monitor.getTotal(), "ms");

  // Disconnect the slave process
  cluster.worker.disconnect();
}
```

{{</details>}}

{{<details title="Time-consuming when not communication together" open=false >}}
Time-consuming when running multiple threads and multiple processes without communication together meaning each item runs separately and does not share data

**Nodejs**

```js
// TODO: update guideline how it work and how it look (htop)
```

{{</details>}}
{{<nl>}}
{{<details title="Time-consuming when communication together" open=false >}}
Time-consuming when running multiple threads and multiple processes within communication together meaning each item runs separately but shares data with the main item

**Nodejs**

<!-- // TODO: update guideline how it work and how it look (htop) -->

{{</details>}}

## Context switching

{{<hint info>}}
How does the OS run threads or processes on a CPU (processor) ? \
=> This is handled by context switching
{{</hint>}}

![scheduler](/research/process_vs_thread/scheduler.png)

During a context switch, one process is switched out of the CPU (processor) so another process can run

![process_executing](/research/process_vs_thread/process_executing.png)

The OS stores the states of the current running process so the process can be restored and resume execution at a later point

It then restores the previously saved states of a different process and resumes execution for that process

**Context switching is expensive**. It involves saving and loading registers, switching out memory pages, and updating various kernel data structures

![process_control_block](/research/process_vs_thread/process_control_block.png)

Switching execution between **threads** also requires context switching

![context_switching](/research/process_vs_thread/context_switching.png)

It’s generally **faster** to switch context between **threads** than between **processes**

There are fewer states to track, and more importantly, since threads share the same memory address space, there is no need to switch out virtual memory pages which is one of the most expensive operations during a context switch

Context switching is so costly, there are **other mechanisms to try to minimize it**. Some examples are **fibers and coroutines**

These mechanisms **trade complexity** for even **lower context-switching costs**

![fiber_yield](/research/process_vs_thread/fiber_yield.png)

In general, they are cooperatively scheduled, that is, they must yield control for others to run

In other words, **the application itself handles task scheduling**

It’s the responsibility of the application to make sure a long-running task is broken up by yielding periodically

## Conclusion

Program, process, and thread:

- The program contains a set of instructions
- The program is loaded into memory. It becomes one or more running processes. When a process starts, it is assigned memory and resources
- The thread is the smallest unit of execution within a process. A process can have one or more threads

If we can ideally run each thread on each idle core, we can actually run parallelism all jobs we want with the shortest time consuming

The cost when sharing data between threads and processes is also expensive, processes are more expensive than threads because threads inside the process use together shared memory address space

Context-switching will appear when the scheduler of OS assigns one logical processor more than one thread or process that needs to run. Context-switching is expensive

## Appendix

### Processor definition

There are 2 definitions of the term `Processor` that can lead you to confusion when researching

Let’s devine it into 2 names:

- **Physical processor**: means processor definition in the hardware world
- **Logical processor**: means processor definition in the software world

#### Physical processor

**A processor** in this context means **the entire CPU chip** as the Intel define

This image is the complexity of a modern multi-processor, multi-core system
![physical_processors](/research/process_vs_thread/physical_processors.png)

#### Logical processor

![logical_processors](/research/process_vs_thread/logical_processors.png)

**A processor** in this context means **a virtual core**:

- CPU has 8 cores
- CPU has **hyperthreading** and it is enabled so **each core split into 2 virtual cores**

### Virtual memory

A computer can address more memory than the amount physically installed on the system. This extra memory is actually called virtual memory and it is a section of a hard disk that's set up to emulate the computer's RAM

![virtual_memory](/research/process_vs_thread/virtual_memory.png)

### Hyper-threading

Intel® Hyper-Threading Technology is a hardware innovation that allows more than one thread to run on each core. More threads means more work can be done in parallel

How does Hyper-Threading work? When Intel® Hyper-Threading Technology is active, the CPU exposes two execution contexts per physical core. This means that one physical core now works like two “logical cores” that can handle different software threads

## Reference

- Bytebytego: [Interview question: Design Twitter (Episode 5)](https://blog.bytebytego.com/p/interview-question-design-twitter)
- Bytebytego: [FANG Interview Question | Process vs Thread](https://www.youtube.com/watch?v=4rLW7zg21gI)
- Intel: [A Better Way to Measure CPU Utilization](https://www.intel.com/content/www/us/en/developer/articles/tool/performance-counter-monitor.html)
- Medium: [Achieving concurrency in Go](https://medium.com/rungo/achieving-concurrency-in-go-3f84cbf870ca)
- Stackoverflow: [What are the differences between multi-CPU, multi-core and hyper-thread?](https://stackoverflow.com/questions/680684/what-are-the-differences-between-multi-cpu-multi-core-and-hyper-thread)
- Tutorialspoint: [Operating System - Virtual Memory](https://www.tutorialspoint.com/operating_system/os_virtual_memory.htm)
- Wikipedia: [Virtual memory](https://en.wikipedia.org/wiki/Virtual_memory)
- Intel: [What Is Hyper-Threading?](https://www.intel.com/content/www/us/en/gaming/resources/hyper-threading.html#:~:text=Intel%C2%AE%20Hyper%2DThreading%20Technology%20is%20a%20hardware%20innovation%20that,execution%20contexts%20per%20physical%20core)
- Geeksforgeeks: [Difference between User Level thread and Kernel Level thread](https://www.geeksforgeeks.org/difference-between-user-level-thread-and-kernel-level-thread/)
- Geeksforgeeks: [Difference between MultiCore and MultiProcessor System](https://www.geeksforgeeks.org/difference-between-multicore-and-multiprocessor-system/)
- Indeed: [Multithreading vs. Multiprocessing: What's the Difference?](https://www.indeed.com/career-advice/career-development/multithreading-vs-multiprocessing#:~:text=Multiprocessing%20uses%20two%20or%20more,computing%20power%20by%20adding%20CPUs.)
- Scaler: [Difference Between Multicore and Multiprocessor System](https://www.scaler.com/topics/operating-system/difference-between-multicore-and-multiprocessor-system/)
- Superuser: [What's the difference between a multiprocessor and a multiprocessing system?](https://superuser.com/questions/1297813/whats-the-difference-between-a-multiprocessor-and-a-multiprocessing-system)
- Superuser: [What's the difference between multicore proccesor and multiproccess system?](https://superuser.com/questions/13107/whats-the-difference-between-multicore-proc-and-multiproc-system?rq=1)

{{< footer >}}