---
title: "HSTS"
weight: 800
date: 2024-06-15T01:47:46+07:00
---

# HTTP Strict-Transport-Security

## Overview

- **HSTS Header**: The server sends an Strict-Transport-Security header in its HTTPS response
- **HSTS Policy**: The browser enforces the HSTS policy for the specified domain by:
    - Automatically upgrading all HTTP requests to HTTPS
    - Refusing to connect to the site if a valid HTTPS connection cannot be established (e.g., if there are certificate issues)
- **Persistence**: The policy is cached in the browser for the duration specified by the max-age directive in the header

## Pros

- **Forces HTTPS**: Ensures all traffic to the site uses a secure connection.
- **Mitigates MitM Attacks**: Prevents attackers from intercepting or altering communication.
- **Protects Against Protocol Downgrade**: Blocks attackers from forcing the browser to switch from HTTPS to HTTP.

## Demo setup

{{<details title="Nginx" open=false >}}

```nginx
server {
    listen 443 ssl;
    server_name example.com;

    add_header Strict-Transport-Security "max-age=31536000; includeSubDomains; preload" always;
}
```

{{</details>}}

{{<nl>}}

{{<details title="NodeJS" open=false >}}

- Install the helmet middleware: `npm install helmet`

```js
const helmet = require('helmet');
app.use(helmet.hsts({
    maxAge: 31536000, // 1 year in seconds
    includeSubDomains: true,
    preload: true
}));
```

{{</details>}}

- Add your domain to the HSTS Preload List at [Hstspreload](https://hstspreload.org/)
- Verify at [Hardenize](https://www.hardenize.com/)

## Remove

- Set your header: `Strict-Transport-Security: max-age=0`
- You can remove HSTS at [Hstspreload-removal](https://hstspreload.org/removal/)

## References

- Mozilla: [Strict-Transport-Security](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Strict-Transport-Security) (Aug 1st, 2024)

{{< footer >}}
