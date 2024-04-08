---
title: "Docker"
weight: 30
date: 2024-04-08T01:47:46+07:00
---

# Docker

## Terminology

- `Image`: Like the execution file (.exe) and even more. It have all needed setup dependences that stored inside it and ready to run instructions
- `Container`: Like the process after you run the image, but this application at this time is considered as the whole virtual machine
- `Dockerfile`: You will write all the instructions here, guild the Docker engine what enviroment you want your app to run inside, what dependencies need to be installed, copy your source code into and last but not least is the command to run your app

## Listing containers

- Listing all running containers:

```cmd
docker ps
```

- Listing both stopped and runnning containers:

```cmd
docker ps --all
```

## Build the image

```cmd
docker build -t welcome-to-docker .
```

- The `-t` flag tags your image with a name. (welcome-to-docker in this case)
- The `.` lets Docker know where it can find the Dockerfile
