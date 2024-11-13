---
title: "TLS - SSL - Draft"
weight: 3
date: 2023-11-15T01:47:46+07:00
---

# TLS - SSL

## Overview

- A protocol for encrypting, securing, and authenticating communications that take place on the Internet
- SSL was replaced by an updated protocol called TLS some time ago, SSL is still a commonly used term for this technology

![evolution](/research/be_protocol/tls_ssl/evolution.png)

## TLS 1.2

![tls_1.2_handsake](/research/be_protocol/tls_ssl/tls_1.2_handsake.png)

## TLS 1.3

### Diffie Hellman

### TLS 1.3

## SSL Certificate

An SSL certificate contains:
- Domain name it's issued for
- Certificate Authority (CA)
- Validity Period
- Website's public key
- Other information

![certificate](/research/be_protocol/tls_ssl/certificate.png)

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

### Why we need SSL Certificate?

- Prevent: 
    - [On-path attack](https://www.cloudflare.com/learning/security/threats/on-path-attack/)  <!-- Todo: [Malicious Network Redirects](/docs/research/security/#malicious-network-redirects) -->
    - Domain spoofing
    - Other methods attackers use to impersonate a website and trick users
- Establish HTTPS

### [How to setup SSL Cert?](/docs/tips/004_ops/#ssl-certificate)

## Reference

- Cloudflare: [How does SSL work?](https://www.cloudflare.com/learning/ssl/how-does-ssl-work/)
- Cloudflare: [Types of SSL certificates: SSL certificate types explained](https://www.cloudflare.com/learning/ssl/types-of-ssl-certificates/)
- Gigamon: [What Is TLS 1.2, and Why Should You (Still) Care?](https://blog.gigamon.com/2021/07/14/what-is-tls-1-2-and-why-should-you-still-care/)
- Wikipedia: [Transport Layer Security](https://en.wikipedia.org/wiki/Transport_Layer_Security) (Mar 1st, 2024)
- Youtube: [Let's Encrypt Explained: Free SSL](https://www.youtube.com/watch?v=jrR_WfgmWEw) (Oct 25th, 2020)
- Youtube: [Are Free SSL Certificates Really Good Enough for Your Website?](https://www.youtube.com/watch?v=yjk36fv3Km4) (Sep 1st, 2022)
- Mozilla: [SSL Configuration Generator](https://ssl-config.mozilla.org/) (Nov 13th, 2024)