---
title: "TLS - SSL"
weight: 3
date: 2024-01-14
---

# TLS - SSL

## Problem

- If a website uses HTTP without SSL/TLS, all packets sent over the internet can easily be captured and read (see [packet sniffing demonstration](/docs/research/security/packet_sniffing/))
- How can a user determine if the website they are currently visiting is the original or a look-alike website created by a hacker to impersonate it? (see [dns poisoning demonstration](/docs/research/security/dns_poisoning/))

## Overview

- The internet's official birthday is January 1, 1983
- A protocol for encrypting, securing, and authenticating communications that take place on the Internet
- SSL was replaced by an updated protocol called TLS some time ago, SSL is still a commonly used term for this technology

![evolution](/research/be_protocol/tls_ssl/evolution.png)

- To see which TLS version of a website (on Chrome): 
    1. Open the **Developer Tools** (Ctrl+Shift+I) 
    2. Select the **Security** tab 
    3. Navigate to the **Origin** you want to inspect 
    4. At the **Connection** section, check the results which TLS protocol is used
    ![tls_demo_version_check](/research/be_protocol/tls_ssl/tls_demo_version_check.png)

## TLS 1.2

- Key exchange algorithm: [Utilize the encryption and decryption capabilities of asymmetric encryption](/docs/research/encryption/#public-encryption--private-decryption)
- Round trip time: 2 RTT
- Compatibility: [Supported by both older and newer versions of all browsers](https://caniuse.com/?search=tls%201.2)

### Flow

![tls_1_2_flow](/research/be_protocol/tls_ssl/tls_1_2_flow.png)

### Set up your server using TLS 1.2

{{<details title="**Nginx**" open=false >}}

1. Open Your Nginx Configuration

```sh
sudo vi /etc/nginx/sites-enabled/default
```

2. Update the `ssl_protocols` directive and configure cipher suites:
    - `ssl_protocols TLSv1.2;`
    - `ssl_ciphers 'ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256:DHE-RSA-AES256-GCM-SHA384:DHE-RSA-AES128-GCM-SHA256';`
    - When you set up a free SSL certificate with **Certbot** ([Let's Encrypt certificate](/docs/tips/004_ops/#lets-encrypt-ssltls-certificate)), **Certbot** automatically sets up `ssl_protocols` and `ssl_ciphers` for you (`include /etc/letsencrypt/options-ssl-nginx.conf;`). I commented this out to allow my demo to work correctly

```nginx
server {
    listen [::]:443 ssl ipv6only=on; # managed by Certbot
    listen 443 ssl; # managed by Certbot
    ssl_certificate /etc/letsencrypt/live/mnptt.io.vn/fullchain.pem; # managed by Certbot
    ssl_certificate_key /etc/letsencrypt/live/mnptt.io.vn/privkey.pem; # managed by Certbot
    #include /etc/letsencrypt/options-ssl-nginx.conf; # managed by Certbot
    ssl_dhparam /etc/letsencrypt/ssl-dhparams.pem; # managed by Certbot

    # Downgrade to TLS 1.2
    ssl_protocols TLSv1.2;
    ssl_ciphers 'ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256:DHE-RSA-AES256-GCM-SHA384:DHE-RSA-AES128-GCM-SHA256';

    root /var/www/html;
    index index.html index.htm index.nginx-debian.html;
    server_name mnptt.io.vn;

    location / {
        try_files $uri $uri/ =404;
    }
}
```

3. Test the configuration

```sh
sudo nginx -t
```

4. Reload Nginx

```sh
sudo systemctl reload nginx
```

5. Verify

![tls_1_2_setup](/research/be_protocol/tls_ssl/tls_1_2_setup.png)

{{</details>}}

## TLS 1.3

- Key exchange algorithm: [Diffie-Hellman, Elliptic-curve Diffie-Hellman (ECDH)](/docs/research/encryption/#key-exchange)
- Round trip time: 1 RTT
- Compatibility: [Supported by newer versions of most browsers](https://caniuse.com/?search=tls%201.3)

### Flow

![tls_1_3_flow](/research/be_protocol/tls_ssl/tls_1_3_flow.png)

### Set up your server using TLS 1.3

{{<details title="**Nginx**" open=false >}}

0. Requirements
    - `OpenSSL`: 1.1.1 or newer
    - `Nginx`: 1.13.0 or newer

1. Open Your Nginx Configuration

```sh
sudo vi /etc/nginx/sites-enabled/default
```

2. Update the `ssl_protocols` directive and configure cipher suites:
   - `ssl_protocols TLSv1.3 TLSv1.2;`
   - `ssl_ciphers 'TLS_AES_256_GCM_SHA384:TLS_CHACHA20_POLY1305_SHA256:TLS_AES_128_GCM_SHA256:ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384';`
    - When you set up a free SSL certificate with **Certbot** ([Let's Encrypt certificate](/docs/tips/004_ops/#lets-encrypt-ssltls-certificate)), **Certbot** automatically sets up `ssl_protocols` and `ssl_ciphers` for you (`include /etc/letsencrypt/options-ssl-nginx.conf;`). I commented this out to allow my demo to work correctly

```nginx
server {
    listen [::]:443 ssl ipv6only=on; # managed by Certbot
    listen 443 ssl; # managed by Certbot
    ssl_certificate /etc/letsencrypt/live/mnptt.io.vn/fullchain.pem; # managed by Certbot
    ssl_certificate_key /etc/letsencrypt/live/mnptt.io.vn/privkey.pem; # managed by Certbot
    #include /etc/letsencrypt/options-ssl-nginx.conf; # managed by Certbot
    ssl_dhparam /etc/letsencrypt/ssl-dhparams.pem; # managed by Certbot

    # Override settings for TLS 1.3
    ssl_protocols TLSv1.2 TLSv1.3;  # Enable TLS 1.3 and keep TLS 1.2
    ssl_ciphers 'TLS_AES_256_GCM_SHA384:TLS_CHACHA20_POLY1305_SHA256:TLS_AES_128_GCM_SHA256:ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384';

    root /var/www/html;
    index index.html index.htm index.nginx-debian.html;
    server_name mnptt.io.vn;

    location / {
        try_files $uri $uri/ =404;
    }
}
```

3. Test the configuration

```sh
sudo nginx -t
```

4. Reload Nginx

```sh
sudo systemctl reload nginx
```

5. Verify

![tls_1_3_setup](/research/be_protocol/tls_ssl/tls_1_3_setup.png)

{{</details>}}

## SSL Certificate

- A SSL certificate contains:
  - Domain name it's issued for
  - Certificate Authority (CA)
  - Validity period
  - Website's public key
  - Other information

![certificate](/research/be_protocol/tls_ssl/certificate.png)

{{<columns>}}

#### No certificate

![no_cert](/research/be_protocol/tls_ssl/no_cert.png)
<--->

#### Invalid certificate

![err_cert](/research/be_protocol/tls_ssl/err_cert.png)
<--->

#### Valid certificate

![valid_cert](/research/be_protocol/tls_ssl/valid_cert.png)
{{</columns>}}

### Validation levels

![validation_levels](/research/be_protocol/tls_ssl/validation_levels.png)

{{< hint info >}}
In terms of encryption strength, all three levels provide the same security
{{< /hint >}}

{{<columns>}}

#### Domain Validation

- Least-stringent level
- User only has to prove they control the domain
- Process can be automated

<--->

#### Organization Validation

- Manual vetting process

<--->

#### Extended Validation

- Full background check of the organization

{{</columns>}}

{{<columns>}}
![DV1](/research/be_protocol/tls_ssl/DV1.png)
<--->
![OV1](/research/be_protocol/tls_ssl/OV1.png)
<--->
![EV1](/research/be_protocol/tls_ssl/EV1.png)
{{</columns>}}

{{<columns>}}
![DV2](/research/be_protocol/tls_ssl/DV2.png)
<--->
![OV2](/research/be_protocol/tls_ssl/OV2.png)
<--->
![EV2](/research/be_protocol/tls_ssl/EV2.png)
{{</columns>}}

{{< hint info >}}
At higher levels, they give more verified information about the website owner's identity
{{< /hint >}}

### Types

#### Single Domain SSL Certificates

One domain and all pages

![single_domain](/research/be_protocol/tls_ssl/single_domain.png)

#### Wildcard SSL Certificates

One domain and all subdomains

![wildcard](/research/be_protocol/tls_ssl/wildcard.png)

#### Multi-Domain SSL Certificates

- It's a shared certificate
- Multiple distinct domains will be listed on a certificate

![multi-domain](/research/be_protocol/tls_ssl/multi-domain.png)

### How to setup SSL Certificate?

- [Free SSL Certificate](/docs/tips/004_ops/#lets-encrypt-ssltls-certificate)
- [SSL Certificate for localhost](/docs/tips/004_ops/#certificates-for-localhost)

## Reference

- Cloudflare: [How does SSL work?](https://www.cloudflare.com/learning/ssl/how-does-ssl-work/)
- Cloudflare: [Types of SSL certificates: SSL certificate types explained](https://www.cloudflare.com/learning/ssl/types-of-ssl-certificates/)
- Gigamon: [What Is TLS 1.2, and Why Should You (Still) Care?](https://blog.gigamon.com/2021/07/14/what-is-tls-1-2-and-why-should-you-still-care/)
- Xargs: [The Illustrated TLS 1.3 Connection](https://tls13.xargs.org/) (Nov 13th, 2024)
- Wikipedia: [Transport Layer Security](https://en.wikipedia.org/wiki/Transport_Layer_Security) (Mar 1st, 2024)
- Cloudflare: [A Detailed Look at RFC 8446 (a.k.a. TLS 1.3)](https://blog.cloudflare.com/rfc-8446-aka-tls-1-3/) (Aug 10th, 2018)
- Youtube: [Let's Encrypt Explained: Free SSL](https://www.youtube.com/watch?v=jrR_WfgmWEw) (Oct 25th, 2020)
- Youtube: [Are Free SSL Certificates Really Good Enough for Your Website?](https://www.youtube.com/watch?v=yjk36fv3Km4) (Sep 1st, 2022)
- Mozilla: [SSL Configuration Generator](https://ssl-config.mozilla.org/) (Nov 13th, 2024)
- Networkoptix: [How to check and/or change the TLS version](https://support.networkoptix.com/hc/en-us/articles/17314112665111-How-to-check-and-or-change-the-TLS-version) (Nov 11th, 2024)

{{< footer >}}
