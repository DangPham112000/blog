---
title: "Docker"
weight: 300
date: 2024-04-08T01:47:46+07:00
updated: 2024-04-11T01:47:46+07:00
---

# Docker Tips

## Terminology

- `Image`: Like the execution file (.exe) and even more. It have all needed setup dependences that stored inside it and ready to run instructions
- `Container`: Like the process after you run the image, but this application at this time is considered as the whole virtual machine

## Create

Create a docker image

### Dockerfile

You will write all the instructions here, guild the Docker engine what enviroment you want your app to run inside, what needed dependencies to be installed, copy your source code into and last but not least is the command to run your app:

1. Specify a base image
2. Run some commands to install additional programs
3. Specify a command to run on the container startup

```Dockerfile
# Dockerfile
# 1. Use an existing docker image as a base
FROM alpine
# 2. Download and install a dependency
RUN apk add --update redis
# 3. Tell the image what to do when it starts as a container
CMD ["redis-server"]
```

### Build

Build an image

```shell
# syntax
docker build -t <docker-id>/<project-name>:<version> .
# eg.
docker build -t dangpham/redis:v1 .
```

- The `-t` flag tags your image with a name (`dangpham/redis:v1` in this case)
- The `.` is the build context that lets Docker know where it can find the Dockerfile

### Build an image with specific docker file name

```shell
docker build -f Dockerfile.dev .
```

### Build an image from the running container

```shell
docker commit -c <instruction> <container-id> <image-name>
# eg.
docker commit -c 'CMD ["redis-server"]' c3f279d17e0a dangpham/redis:v2
```

### How to import your project files into the image

```Dockerfile
# Specify a base image
FROM node:14-alpine
WORKDIR /usr/app
# Install some dependencies
COPY ./ ./
RUN npm install
# Default command
CMD ["npm", "start"]
```

- `WORKDIR /usr/app`: change container context into this path. It will create a new folder if it doesn’t exist
- `COPY ./ ./`: copy from `computer-context` to `container-context`
  - `computer context`: Path to folder copy from on _your machine_ relative to build context
  - `container context`: Place to copy stuff inside _the container_ (`/usr/app` in this case)

## Run

Run a container from the image

```shell
docker run <image-name>
docker run -it <image-name> sh
```

- `docker run …` = `docker create …` + `docker start -a …`
- `-it ... sh`: connect your terminal with the container shell

### Docker Run with port mapping

```shell
docker run -p <container-port>:<app-port> <image-name>
# eg,
docker run -p 7070:8080 dangpham/web-app:v1
```

- `container-port`: Your computer will open this port for container
- `app-port`: Your running application exported port inside the container

### Detach mode

```shell
docker run <image-name> -d
```

- The `-d` flag starts up a container in detached mode
- Means that output from the container will not be piped to your terminal
- You can continue to run other commands while the container is still running

### Attach mode

- Attach to the `sdtin`, `stdout`, `stderr` of container's primary process into your terminal

```shell
docker attach <container-id>
```

## Execute

- Every process that we create in a Linux environment has three communication channels attached to it, that we refer to as:

  - `stdin`: input to process
  - `stdout`: output from process
  - `stderr`: error form process

- These channels are used to communicate information either into the process or out of the process

### Exec command

```shell
docker exec -it <container-id> <command>
```

- `-it`: Allow us to provide input to the container
- The `-i` flag: we are saying make sure that any stuff that our typed gets directed to `stdin` of Process.
- The `-t` flag: make those stuff we receive prettier

### Terminal access

Get full terminal access inside the context of the container

```shell
docker exec -it <container-id> sh
```

- `sh` means a shell or a command processor
- Allow us to type commands in and have them be executed inside that container

## Listing

### Container

- Listing all running containers:

```shell
docker ps
```

- Listing both stopped and runnning containers:

```shell
docker ps --all
```

### Image

```sh
docker image ls
```

## Caching

Docker has the cache mechanism, that compare each instruction in your Dockerfile with its previous

```Dockerfile
# Specify a base image
FROM node:14-alpine
WORKDIR /usr/app
# Install some dependencies
COPY ./package.json ./
RUN npm install
COPY ./ ./
# Default command
CMD ["npm", "start"]
```

- `package.json` israrely update so copying `package.json` before copying all other stuff
  - It will help Docker runing `npm install` with cache and
  - It will not re-install all dependencies just because you edit some html/css/js files

## Volumes

### Change code in local machine and effect the container right away without rebuild

```shell
docker run -p 3000:3000 -v /app/node_modules -v $(pwd):/app <image_name>
```

- Note:
  - `-v /app/node_modules`: Put a bookmark on the `node_modules` folder
  - `pwd`: Present Working Directory
  - `-v $(pwd):/app`: Map the `pwd` into the `/app` folder
- Explain:
  - Means reference all files in `pwd` (except things inside `node_modules`) with all files in `/app`
  - So when we change code in `pwd`, it also references to `/app`

## Stop

When you issue docker stop to a container, if the container does not automatically stop in 10 seconds, then Docker is going to automatically fall back to issuing the docker kill command.

### Soft

Send SIGTERM (terminate signal) to the process: give a process inside the container a little bit of time to do ST (like backup, etc…)

```shell
docker stop <container-id>
```

### Hard

Send SIGKILL (kills signal): shut down right now

```shell
docker kill <container-id>
```

## Remove

### Remove stopped container

```shell
docker rm <name>
```

### Remove all stopped containers and images

Remove all stopped containers in your machine and also clear your docker cache. It means you must re-download it from docker-hub in the next run

```shell
docker system prune
```

## Log

Retrieve all information that has been emitted from the docker

```shell
docker logs <container-id>
```

{{< footer >}}
