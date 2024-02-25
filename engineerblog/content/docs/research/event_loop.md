---
title: "Event loop"
weight: 100
date: 2023-12-05T01:47:46+07:00
---

# Event loop

## Challenge

Can you guess the output of the below JS code

{{<columns>}}

<!-- prettier-ignore-start -->
```js
var name = "JS";

function execLater() {
  setTimeout(printName, 0);

  Promise
    .resolve()
    .then(() => {
      console.log("Promise resolve");
    });

  console.log(name);

  var name = "TS";
}

printName(name);

function printName() {
  console.log(name);
}

execLater();
```
<!-- prettier-ignore-end -->

<--->

Phase 1: the memory creation phase

1. `name` is declared and initialized equal `"JS"`
2. `execLater` is declared and initialized
3. `printName` is declared and initialized

Phase 2: the code execution phase

1. `printName` is called and it prints `"JS"`
2. `execLater` is called:
   1. Phase 1:
      1. `name` is assigned to undefined due to hoisting
   2. Phase 2:
      1. `printName` goes to the callback queue and wait for 0ms to be executed later
      2. The promise goes to the microtask queue
      3. `printName` is executed with the value of name is undefined
      4. `name` is assigned to `"TS"` but only in `execLater` scope
      5. Once the call stack is empty, the event loop pulls the promise to execute it as it has higher priority
      6. `printName` is called and print `"JS"` b/c it referents to the global scope

{{</columns>}}

{{<details title="The display order on the console" open=false >}}

1. JS
2. undefined
3. Promise resolve
4. JS

{{</details>}}

## Overview

## Stack

## Heap

## Queue

## Reference

- Mozilla: [The event loop](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Event_loop) (Dec 20, 2023)
- Youtube: [What the heck is the event loop anyway? | Philip Roberts | JSConf EU](https://www.youtube.com/watch?v=8aGhZQkoFbQ) (Oct 9, 2014)
- Nodejs: [The Node.js Event Loop](https://nodejs.org/en/learn/asynchronous-work/event-loop-timers-and-nexttick)
