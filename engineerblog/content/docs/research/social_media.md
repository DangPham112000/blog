---
title: "Social Media - Draft"
weight: 1000
date: 2023-12-05T01:47:46+07:00
---

# Social Media: fakebut.site

## Architecture

- Frontend: Vite-ReactJS, Argon (Consider replace with TaiwinCSS)
- Backend: ExpressJS, Golang, MongoDB
- Ops: Git Action, Docker, EC2

### Login

- Front: Login/Register page
  - [Setup Vite](https://vitejs.dev/guide/#scaffolding-your-first-vite-project)
  - Routing handling
- Back: API login/register
- Cookie base
  - Consider the possibility?
  - Because the strickly of cookie when work with cross-origin (front-end origin vs backend origin)
  - Solution: using the nginx to become the gateway to serve backend api and frontend site
- Token base
- SSO

### Chat

- Websocket

### Post

### Comment

### Notification

### Admin management
