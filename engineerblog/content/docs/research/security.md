---
title: "Security - Draft"
weight: 200
date: 2024-06-15T01:47:46+07:00
---

# Security

## Brute Force Attack

Every password-based system and encryption key out there can be cracked using a brute force attack.

There are only one problem of this attack is the time

![2024-Crack-Password-Table](/research/security/2024-Crack-Password-Table.png)

- Why hashing method matter when cracking password with brute force attack. Bcrypt will take longer cracking time than MD5

### Use case

- Cracking passwords (SSH logins) 
- Cracking encryption keys (API keys)

### How it works

they may have to run through every possible combination of characters before achieving their goal. 

Brute force password attacks are often carried out by scripts or bots that target


### Prevention

- **Longer password**
- **Delay response**: The right away responsed system is not always good. Adding some delay point to when checking password, a delay of even a few seconds can greatly weaken the effectiveness of a brute force attack
- **Two-factor authentication**
- **Rate limit**

## Dictionary attack

### Use case

- A dictionary attack is a method of breaking into a password-protected computer, network or other IT resource by systematically entering every word in a dictionary, or word list, as a password
- A dictionary attack can also be used in an attempt to find the key necessary to decrypt an encrypted message or document

### How it works

- If it target to an orgization, or a paticulally person. the dictionary can collect all the `gan gui` words around the factor they want to hack, combination all of them in all the possible ways then try each to guess the pass or key they want to hack

### Prevention

- Avoid passwords: the passwords can be hacked if we dont use password for login (funy huh). At the system view we can totally avoid it by using password-free authentication solutions and biometric logins 
- Use random passwords: At the user view, dont you closely information like (name, pet, birthday) or the easy to predict words (like password, abcd, xyz, 123) to create a password. instead, using random string, if you see it's difficult to remember them then you can use some 3rd-party password manager to store them (of course, you need to choose the trustworthy one)
- Two-factor authentication
- Limit login attempts
- Force resets

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

## Relay attack

## Man in the middle attack

### request modify

### response modify

## References

- Cloudflare: [What is a brute force attack?](https://www.cloudflare.com/learning/bots/brute-force-attack/) ()
- Hivesystems: [Are Your Passwords in the Green?](https://www.hivesystems.com/blog/are-your-passwords-in-the-green) ()
- Kaspersky: [What is a Dictionary Attack?](https://www.kaspersky.com/resource-center/definitions/what-is-a-dictionary-attack) ()