---
title: "Security - Draft"
weight: 200
date: 2024-06-15T01:47:46+07:00
---

# Security

## Explore your site's vulnerabilities

```sh
# IPv4
sudo nmap --script vuln [IPv4] 
# IPv6 
sudo nmap -6 --script vuln [IPv6]
# E.g IPv4
sudo nmap --script vuln 18.141.184.34
# E.g IPv6
sudo nmap -6 --script vuln 2606:4700:3033::ac43:b865
```
{{<details title="Example output" open=false >}}

```sh
Starting Nmap 7.94SVN ( https://nmap.org ) at 2024-12-05 09:00 +07
Nmap scan report for ec2-18-141-184-34.ap-southeast-1.compute.amazonaws.com (18.141.184.34)
Host is up (0.033s latency).
Not shown: 997 filtered tcp ports (no-response)
PORT    STATE SERVICE
22/tcp  open  ssh
80/tcp  open  http
|_http-csrf: Couldn't find any CSRF vulnerabilities.
|_http-dombased-xss: Couldn't find any DOM based XSS.
| http-vuln-cve2011-3192: 
|   VULNERABLE:
|   Apache byterange filter DoS
|     State: VULNERABLE
|     IDs:  BID:49303  CVE:CVE-2011-3192
|       The Apache web server is vulnerable to a denial of service attack when numerous
|       overlapping byte ranges are requested.
|     Disclosure date: 2011-08-19
|     References:
|       https://www.securityfocus.com/bid/49303
|       https://www.tenable.com/plugins/nessus/55976
|       https://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2011-3192
|_      https://seclists.org/fulldisclosure/2011/Aug/175
|_http-stored-xss: Couldn't find any stored XSS vulnerabilities.
443/tcp open  https
|_http-csrf: Couldn't find any CSRF vulnerabilities.
|_http-stored-xss: Couldn't find any stored XSS vulnerabilities.
| http-vuln-cve2011-3192: 
|   VULNERABLE:
|   Apache byterange filter DoS
|     State: VULNERABLE
|     IDs:  BID:49303  CVE:CVE-2011-3192
|       The Apache web server is vulnerable to a denial of service attack when numerous
|       overlapping byte ranges are requested.
|     Disclosure date: 2011-08-19
|     References:
|       https://www.securityfocus.com/bid/49303
|       https://www.tenable.com/plugins/nessus/55976
|       https://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2011-3192
|_      https://seclists.org/fulldisclosure/2011/Aug/175
|_http-dombased-xss: Couldn't find any DOM based XSS.

Nmap done: 1 IP address (1 host up) scanned in 193.10 seconds
```
{{</details>}}

## Brute Force Attack

- Every password-based system and encryption key out there can be cracked using a brute force attack.
- There is only one problem with this attack: the time.

![2024-Crack-Password-Table](/research/security/2024-Crack-Password-Table.png)

- Why does the hashing method matter when cracking passwords with a brute force attack? [Bcrypt will take longer to crack than MD5](/docs/research/encryption/#bcrypt-vs-md5)

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

## Dictionary Attack

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

## Man In The Middle Attack (MITM)

- [Packet Sniffing](/docs/research/security/packet_sniffing/)
- [ARP Spoofing](/docs/research/security/arp_spoofing/)
- [Evil Twin](/docs/research/security/evil_twin/)
- [DNS Poisoning](/docs/research/security/dns_poisoning)
- [Bit Flipping](/docs/research/security/bit_flipping)

## Malicious Network Redirects

Attackers can inject fake DNS responses, redirecting you to malicious versions of websites

### How it works

- Hacker hijacking the unsecured Wi-Fi you access (more detail: [DNS Poisoning](/docs/research/security/dns_poisoning))
- Malware in your computer edit your Host file (the file work like the DNS in your computer)

### Prevention

- **Using SSL/TLS for website**: Even if SSL helps detect this (you’d see a certificate warning), many users may overlook or click through the warning, which could put them at risk

## Denial Of Service (DOS)

### Prevention

- Rate limit

### Distributed Denial Of Service (DDOS)

## Backdoor Attack

## SQL Injection

## IDOR Attack

Authorize route

## Cross-domain Access Attack

## Syn Flood Attack

## References

- Cloudflare: [What is a brute force attack?](https://www.cloudflare.com/learning/bots/brute-force-attack/)
- Hivesystems: [Are Your Passwords in the Green?](https://www.hivesystems.com/blog/are-your-passwords-in-the-green) (2024)
- Kaspersky: [What is a Dictionary Attack?](https://www.kaspersky.com/resource-center/definitions/what-is-a-dictionary-attack)

{{< footer >}}
