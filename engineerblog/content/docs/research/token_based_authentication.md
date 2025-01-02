---
title: "Token Based Authentication"
weight: 60
date: 2024-10-17T01:47:46+07:00
---

# Token based authentication

## Basic flow
![basic_flow](/research/token_based_authentication/basic_flow.png)

## Token expired
![token_expired](/research/token_based_authentication/token_expired.png)

## Threat mitigation strategy
![threat_mitigation](/research/token_based_authentication/threat_mitigation.png)

### Access Token

#### Pros
Do you notice some web page allow you go to a route like dashboard immediately just because you has been login before, but some other web app also have dashboard but they request you login every time you go to them

--> Bad UX

If we use AT, they do not need re-login

#### Cons

If we only use AT for authentication
So when hacker stolen AT successfully, they can impersonate the user

How about short-term AT?
- Each time we grant AT we need to force user re-login
--> Bad UX

How about combine short-term AT and store AT in DB?
Our server can grant several AT and somehow one of them be stolen by hacker, if we store current AT-list and used-AT list. Then if we renew an AT for hacker or user and then another try to renew a used AT we can clear all of them and then force user to re-login
- This approach is totally possible
--> BUT we will increase the I/O cost in DB because too much AT used to check and store

--> So we design RT

### Refresh Token

In order to prevent hacker stolen AT, we decide AT only live in a short time
So refresh token born as a factor to re-grant AT when they are expired and user then can be continue their session with our resource without re-login and don't worry about impersonation

#### Each RT can only be used once

Whenever we see the reused RT, we must right away clear all token and it's keys, then force user to re-login to the system

### Third party authen concept

![3rd_auth](/research/token_based_authentication/3rd_auth.png)

## Reference

- : []() ()

{{< footer >}}