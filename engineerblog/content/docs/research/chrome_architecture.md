---
title: "Chrome Architecture"
weight: 20
date: 2023-12-05T01:47:46+07:00
---

# Chrome Architecture

## Prerequisites

Read [process vs thread](../process_vs_thread) first if you don't have any process and thread concept in your mind

## Browser Architecture

When you start an application, a process is created. The program might create thread(s) to help it do work, but that's optional. The Operating System gives the process a "slab" of memory to work with and all application state is kept in that private memory space. When you close the application, the process also goes away and the Operating System frees up the memory

A process can ask the Operating System to spin up another process to run different tasks. When this happens, different parts of the memory are allocated for the new process. If two processes need to talk, they can do so by using **I**nter **P**rocess **C**ommunication (**IPC**). Many applications are designed to work this way so that if a worker process get unresponsive, it can be restarted without stopping other processes which are running different parts of the application

![snap_process](/research/chrome_architecture/snap_process.png)

There is no standard specification on how one might build a web browser. One browser’s approach may be completely different from another

{{<hint info>}}
Chrome uses a separate content process and engine for each website instance, but Firefox reuses processes and engines to limit memory usage\
![chrome_vs_firefox](/research/chrome_architecture/chrome_vs_firefox.png)
{{</hint>}}

| Process      | What it controls?                                                                                                                                                                                            |
| ------------ | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| **Browser**  | Controls "chrome" part of the application including address bar, bookmarks, back and forward buttons. Also handles the invisible, privileged parts of a web browser such as network requests and file access |
| **Renderer** | Controls anything inside of the tab where a website is displayed                                                                                                                                             |
| Plugin       | Controls any plugins used by the website, for example, flash                                                                                                                                                 |
| GPU          | Handles GPU tasks in isolation from other processes. It is separated into different process because GPUs handles requests from multiple apps and draw them in the same surface                               |

There are even more processes like the Extension process and utility processes. If you want to see how many processes are running in your Chrome, click the options menu icon more_vert at the top right corner, select More Tools, then select Task Manager. This opens up a window with a list of processes that are currently running and how much CPU/Memory they are using.

![processes](/research/chrome_architecture/processes.png)

For the renderer process, multiple processes are created and assigned to each tab. **Until very recently**, Chrome gave **each tab a process** when it could; **now** it tries to give **each site its own process**, including iframes

![iframe_process](/research/chrome_architecture/iframe_process.png)

## Browser process

| Thread  | Mission                                                    |
| ------- | ---------------------------------------------------------- |
| UI      | Draws buttons and input fields of the browser              |
| Network | Deals with network stack to receive data from the internet |
| Storage | Controls access to the files and more                      |

![browser_process](/research/chrome_architecture/browser_process.png)

## Renderer process

The renderer process is responsible for everything that happens inside of a tab

| Thread                | Mission                                                                                                             |
| --------------------- | ------------------------------------------------------------------------------------------------------------------- |
| Main                  | The main thread handles most of the code you send to the user                                                       |
| Worker                | Sometimes parts of your JavaScript is handled by worker threads if you use a web worker or a service worker         |
| Compositor and Raster | Compositor and raster threads are also run inside of a renderer processes to render a page efficiently and smoothly |

The renderer process's core job is to turn HTML, CSS, and JavaScript into a web page that the user can interact with

![renderer_process](/research/chrome_architecture/renderer_process.png)

### Main thread

![renderer_process_flow](/research/chrome_architecture/renderer_process_flow.png)

| Pharse            | Job                                                                                                                                                                                                                                                                                                                                             | Visual                                                                    |
| ----------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------- |
| Parsing           | When the renderer process starts to receive HTML data, the main thread begins to parse the text string (HTML) and turn it into a **D**ocument **O**bject **M**odel (**DOM**)                                                                                                                                                                    | ![parsing](/research/chrome_architecture/parsing.png)                     |
| Style calculation | The main thread parses CSS and determines the computed style for each DOM node. This is information about what kind of style is applied to each element based on CSS selectors                                                                                                                                                                  | ![style_calculation](/research/chrome_architecture/style_calculation.png) |
| Layout            | The layout is a process to find the geometry of elements. The main thread walks through the DOM and computed styles and creates the layout tree which has information like x y coordinates and bounding box sizes. Layout tree may be similar structure to the DOM tree, but it only contains information related to what's visible on the page | ![layout](/research/chrome_architecture/layout.png)                       |
| Paint             | The main thread walks the layout tree to create paint records. Paint record is a note of painting process like "background first, then text, then rectangle"                                                                                                                                                                                    | ![paint](/research/chrome_architecture/paint.png)                         |

A website usually uses external resources like images, CSS, and JavaScript. Those files need to be loaded from network or cache. The main thread could request them one by one as they find them while parsing to build a DOM, but in order to speed up, "preload scanner" is run concurrently.

When the HTML parser finds a `<script>` tag, **it pauses the parsing of the HTML document** and has to load, parse, and execute the JavaScript code\
Why? Because JavaScript can change the shape of the document using things like `document.write()` which changes the entire DOM structure

![script_load](/research/chrome_architecture/script_load.png)

The browser then loads and runs the JavaScript code asynchronously and does not block the parsing. You may also use JavaScript module if that's suitable. `<link rel="preload">` is a way to inform browser that the resource is definitely needed for current navigation and you would like to download as soon as possible. You can read more on this at [Resource Prioritization](https://developers.google.com/web/fundamentals/performance/resource-prioritization)

### JavaScript

JavaScript, as you may already know, is single threaded, hence you can’t spawn new threads as you like to spread your computation cost over multiple CPU’s core for **true-parallel** work

![javascript](/research/chrome_architecture/javascript.png)

When your code is executed it may call the Browser’s APIs to interact with the DOM or schedule some async task. Those async tasks are added to the **Event queue** or to the prioritized **Job queue** (if using Promises). As soon as the the Call Stack has finished to process the current tick (is empty), the Event Loop feeds it with a new Tick (which is composed by ONE callback, the FULL job queue, and the POSSIBILITY to call, fully or only some parts, the **Render queue**)

- **Call Stack**: it is the place where **your code is executed** (your functions are loaded and executed, V8 engine in Chrome and NodeJS), it is basically a LIFO stack (last-in-first-out), when it is empty, a.k.a. has completed all the current Tick tasks, it becomes ready to accept the next Tick from the Event Loop
- **Browser APIs: a link between your code and the browser’s internals** to schedule tasks, interact with the DOM and more (ex. setTimeout, AJAX, createElement, querySelector, append, click, etc.). In case of callbacks they will add your callback code to the **Event queue**, instead, in case of a then (promise’s method), your then-code will be added to the **Job Queue**
- **Event queue**: every time you add a callback (ex. via the setTimeout or the AJAX APIs), it is added to this queue
- **Job queue**: this queue is reserved for promise’s thens, it is a prioritized queue, its meaning is like **‘execute this code later (= asynchronously), but as soon as possible! (= before the next Event Loop tick)’**, and this is why browsers had introduced this new queue to fulfil the Promises specifications
- **Render queue**: this is explained in [another article](https://frarizzi.science/journal/web-engineering/browser-rendering-queue-in-depth)
- **Next Tick**: it is what will be executed next, basically it’s composed by **ONE callback** from the Event queue, **THE FULL Job queue** (this point is important, **the current tick will finish only after the Job queue is empty**, so you may inadvertently block it from going to the next Tick if you continuously add new jobs to this queue), **may re-render** (execute the necessary steps in the Render queue to update the screen)
- **Event Loop**: it monitors the Call Stack, as soon as it is empty (has finished to process the current tick), the Event Loop feeds it with the next Tick

Along the main thread there are many other threads spawned by the browser to do useful stuff:

- **Parser Thread**: parses your code in **machine-understandable** trees
- **Statistics collector Thread**: collects data and statistics to discover insights about your code (the scope is to optimize it runtime)
- **Optimizer Thread**: uses the statistics and insights collected by the Statistics collector Thread to make performance optimizations over your code (Caching, Inlining, etc.)
- **Garbage Collector Thread**: removes unconnected (**no more referenceable from the ROOT node**) JavaScript objects to free up memory using a mark-and-sweep algorithm. We don’t know when this will happen and have no control over it. AFAIK the browser uses this thread to track whose objects to remove and do useful stuff, but when it needs to remove them it actually blocks the main thread and uses it. From the Firefox blog Q:”Silly question here, why must garbage collection stop UI events and js execution? Couldn’t the GC just run in a separate thread?”, R:”It can be done, but the garbage collector is looking at the same objects that the JS currently running is touching, so it must be done carefully. That said, the Firefox GC actually does do some work on a separate thread: some types of objects can be thrown away once they are known to be garbage without affecting the main thread.”
- **Rasterizer Thread**: rasterize your graphic into frames
- Etc

## Appendix

### Input events

The browser process is only aware of where that gesture occurred since content inside of a tab is handled by the renderer process. So the browser process sends the event type (like `touchstart`) and its coordinates to the renderer process

Renderer process handles the event appropriately by finding the event target and running event listeners that are attached

{{<img src="/research/chrome_architecture/input_event.png" alt="input_event" caption="Input event routed through the browser process to the renderer process">}}

If no input event listeners are attached to the page, Compositor thread can create a new composite frame completely independent of the main thread. But what if some event listeners were attached to the page? How would the compositor thread find out if the event needs to be handled?

### “Non-fast scrollable region”

Since running JavaScript is the main thread's job, when a page is composited, the compositor thread marks a region of the page that has event handlers attached as "Non-Fast Scrollable Region"

By having this information, the compositor thread can make sure to send input event to the main thread if the event occurs in that region. If input event comes from outside of this region, then the compositor thread carries on compositing new frame without waiting for the main thread

![nonfast](/research/chrome_architecture/nonfast.png)

## Reference

- Chrome: [Inside look at modern web browser (part 1)](https://developer.chrome.com/blog/inside-browser-part1/) (2018 Sep 21)
- Chrome: [Inside look at modern web browser (part 2)](https://developer.chrome.com/blog/inside-browser-part2/) (2018 Sep 21)
- Chrome: [Inside look at modern web browser (part 3)](https://developer.chrome.com/blog/inside-browser-part3/) (2020 Aug 18)
- Chrome: [Inside look at modern web browser (part 4)](https://developer.chrome.com/blog/inside-browser-part4/) (2019 Jan 12)
- Gitconnected: [How web browsers use processes and threads](https://levelup.gitconnected.com/how-web-browsers-use-processes-and-threads-9f8f8fa23371) (2020 Jul 17)
- Medium: [Javascript main thread dissected](https://medium.com/@francesco_rizzi/javascript-main-thread-dissected-43c85fce7e23) (2017 Nov 13)
- V8: [JavaScript modules](https://v8.dev/features/modules) (2018 Jun 18)

{{< footer >}}