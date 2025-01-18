---
title: "Packet Sniffing - Draft"
weight: 400
date: 2024-06-15T01:47:46+07:00
draft: true
---

# Packet Sniffing

- A type of MitM attack
- Description: The attacker uses tools like **Wireshark**, **tcpdump**, or **Kismet** to capture packets traveling through the Wi-Fi network
- Key Characteristics:
    - Often passive (doesn’t modify the traffic, just listens)
    - Works well on unencrypted networks or with weak encryption like WEP

## Prevention:

- Use strong encryption (WPA3 is ideal, WPA2 is acceptable)
- Avoid unencrypted public Wi-Fi
- Encrypt all messages that go through the internet

## Demo

{{<hint danger>}}
**DISCLAIMER**: This demo is for educational purposes only. The techniques should only be tested on systems you own or have explicit permission to analyze. Misuse of this information is unethical, may violate the law, and could lead to serious consequences. The author takes no responsibility for any damages or misuse arising from this content
{{</hint>}}

### Install necessary packages

```sh
sudo apt update
```

- Aircrack-ng:
    - Airmon-ng is a utility in the Aircrack-ng suite that helps set up a wireless network card into monitor mode
    - Airodump-ng: Captures data packets from nearby wireless networks

```sh
sudo apt install aircrack-ng
```

- Wireshark is a network packet analyzer

```sh
sudo apt install wireshark
```

### Let's go

```sh
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

# Capture packets
sudo airodump-ng wlo1mon
sudo wireshark
# -> Use Wireshark to capture packets on the wlo1mon interface
```

- Stop capturing packets (exit monitor mode)
```sh
sudo airmon-ng stop wlo1mon
sudo systemctl restart NetworkManager
```

## References

- Wireshark: [Turning on monitor mode](https://wiki.wireshark.org/CaptureSetup/WLAN#turning-on-monitor-mode) (Aug 11th, 2020)
- Linuxhint: [How to Install and Use Wireshark on Ubuntu](https://linuxhint.com/install_wireshark_ubuntu/) (2018)