---
title: "Security - Draft"
weight: 200
date: 2024-06-15T01:47:46+07:00
---

# Security

## Brute Force Attack

- Every password-based system and encryption key out there can be cracked using a brute force attack.
- There is only one problem with this attack: the time.

![2024-Crack-Password-Table](/research/security/2024-Crack-Password-Table.png)

- Why does the hashing method matter when cracking passwords with a brute force attack? [Bcrypt will take longer to crack than MD5](/docs/research/encryption/#why-bcrypt-will-take-longer-time-to-crack-your-password-than-md5)

### Use case

- Cracking passwords (SSH logins) 
- Cracking encryption keys (API keys)

### How it works

- The hacker have to run through every possible combination of characters before achieving their goal 
- These attacks are often carried out by scripts or bots that target specific systems or accounts

### Prevention

- **Longer password**
- **Delay response**: A system that responds immediately is not always good. Adding a delay when checking passwords, even a delay of a few seconds, can greatly weaken the effectiveness of a brute force attack
- **Stronger hashing method**
- **Two-factor authentication**
- **Rate limit**

## Dictionary attack

### Use case

- A dictionary attack is a method of breaking into a password-protected computer, network or other IT resource by systematically entering every word in a dictionary, or word list, as a password
- A dictionary attack can also be used in an attempt to find the key necessary to decrypt an encrypted message or document

### How it works

- If it targets an organization or a particular person, the dictionary can collect all the closely related words around the target they want to hack. It can then combine all of them in all possible ways and try each combination to guess the password or key they want to hack

### Prevention

- **Avoid passwords**: Passwords can't be hacked if we don't use them for login (I'm joking). From a system perspective, we can completely avoid them by using password-free authentication solutions and biometric logins
- **Random passwords**: From a user perspective, don't use closely related information (like names, pets, birthdays) or easy-to-predict words (like "password," "abcd," "xyz," "123") to create a password. Instead, use random strings. If you find them difficult to remember, you can use a third-party password manager to store them (of course, you need to choose a trustworthy one).
- **Two-factor authentication**
- **Limit login attempts**
- **Force resets**

## Malicious Network Redirects

Attackers can inject fake DNS responses, redirecting you to malicious versions of websites

### How it works

- Hacker hijacking the unsecured Wi-Fi you access
- Malware in your computer edit your Host file (the file work like the DNS in your computer)

### Prevention

- **Using SSL/TLS for website**: Even if SSL helps detect this (you’d see a certificate warning), many users may overlook or click through the warning, which could put them at risk

## DOS

### Prevention

- Rate limit

### DDOS

## Backdoor attack

## SQL injection

## Cross-site scripting (XSS) attack

## Cross-site request forgery (CSRF) attack

## IDOR attack

Authorize route

## Cross-domain access attack

## Syn flood attack

## Man in the middle attack

- [Packet Sniffing](/docs/research/security/packet_sniffing/)
- ARP Spoofing
- [Evil Twin Attack](/docs/research/security/evil_twin/)
- Deauthentication Attack
- DNS Spoofing
- TODO: Setup server in front of real server

## Replay attack

## Relay attack

### request modify

### response modify

## References

- Cloudflare: [What is a brute force attack?](https://www.cloudflare.com/learning/bots/brute-force-attack/)
- Hivesystems: [Are Your Passwords in the Green?](https://www.hivesystems.com/blog/are-your-passwords-in-the-green) (2024)
- Kaspersky: [What is a Dictionary Attack?](https://www.kaspersky.com/resource-center/definitions/what-is-a-dictionary-attack)