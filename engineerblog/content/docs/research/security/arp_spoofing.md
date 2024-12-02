---
title: "ARP Spoofing - Draft"
weight: 600
date: 2024-06-15T01:47:46+07:00
---

# ARP Spoofing Attack

- ARP: Address Resolution Protocol
- A type of MitM attack

## How ARP Works
- ARP Basics:
    - ARP is used to map an IP address to a MAC address within a local network
    - When a device wants to communicate with another, it broadcasts an ARP request: "Who has IP 192.168.1.1? Tell me your MAC address."
    - The device with the corresponding IP replies with its MAC address
- Normal Communication:
    - Once ARP resolves the IP-to-MAC mapping, devices communicate directly using MAC addresses

## How ARP Spoofing Works
- The attacker sends forged ARP replies to the victim device and/or the router, claiming:
    - "I am the router (192.168.1.1)" to the victim
    - "I am the victim (192.168.1.100)" to the router
- Both the victim and the router update their ARP tables with the attacker's MAC address for the claimed IP
- As a result:
    - All traffic from the victim to the router (and vice versa) flows through the attacker
    - The attacker becomes a "man-in-the-middle" (MITM), able to intercept or modify traffic

## Diagram
Normal Traffic:
Victim → Router → Internet

ARP Spoofing:
Victim → Attacker → Router → Internet

## Prevention
- Static ARP Entries: Manually map critical IPs to MAC addresses to prevent changes
- Use Encryption: Secure protocols (e.g., HTTPS, SSH, VPN) ensure data confidentiality even if traffic is intercepted
- Enable Dynamic ARP Inspection (DAI): On managed switches, DAI verifies ARP packets against a trusted database

## Demo
```sh

# Fake dns
sudo bettercap -iface wlo1

# In bettercap:
net.probe on
net.show

set arp.spoof.targets 192.168.1.9
set dns.spoof.domains alo1411.team

arp.spoof on
# -> Output
[sys.log] [inf] arp.spoof arp spoofer started, probing 1 targets

dns.spoof on
# E.g output
[sys.log] [inf] dns.spoof alo1411.team -> 192.168.1.17

net.sniff
```

## References

- Bettercap: [dns.spoof](https://www.bettercap.org/modules/ethernet/spoofers/dns.spoof/)
- Bettercap: [arp.spoof](https://www.bettercap.org/modules/ethernet/spoofers/arp.spoof/)