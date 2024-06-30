---
title: "Encryption - Draft"
weight: 2000
date: 2023-11-15T01:47:46+07:00
---

# Encryption

## Hash

*Note: An 8-bit byte is represented as 2 characters, from 00 to FF, in hexadecimal*

### Collision

### Use case

- Checking file integrity

## HMAC

- HMAC stand for **H**ash-Based **M**essage **A**uthentication **C**odes

## Symmetric encryption

uses the same key to encrypt and decrypt messages

AES, Twofish and ChaCha20

### AES cipher with CBC 

## Asymmetric encryption

uses a public-key cryptosystem (like RSA or ECC) and a key-pair: public key (encryption key) and corresponding private key (decryption key)

Encryption algorithms are often combined in encryption schemes (like AES-256-CTR-HMAC-SHA-256, ChaCha20-Poly1305 or ECIES-secp256k1-AES-128-GCM).

### RSA cipher 

## Digital signatures

guarantee message authenticity, integrity and non-repudiation. 

Most digital signature algorithms (like DSA, ECDSA and EdDSA) use asymmetric key pair (private and public key):
- the message is signed by the private key 
- the signature is verified by the corresponding public key

Use cases:
- In the bank systems digital signatures are used to sign and approve payments. 
- In blockchain signed transactions allow users to transfer a blockchain asset from one address to another.

## Message Authentication

message authentication algorithms (like HMAC) and message authentication codes (MAC codes)

prove message authenticity, integrity and authorship

Authentication is used side by side with encryption, to ensure secure communication.

## Secure Random Numbers

Cryptography uses random numbers and deals with entropy (unpredictable randomness) and secure generation of random numbers (e.g. using CSPRNG). Secure random numbers are unpredictable by nature and developers should care about them, because broken random generator means compromised or hacked system or app.

Like `Math.random()` does not secure but `Crypto.getRandomValues()` does (Ref: [Math.random()](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Math/random))

## Key Exchange

Cryptography defines key-exchange algorithms (like Diffie-Hellman key exchange and ECDH) and key establishment schemes, used to securely establish encryption keys between two parties that intend to transmit messages securely using encryption. Such algorithms are performed typically when a new secure connection between two parties is established, e.g. when you open a modern Web site or connect to the WiFi network.

## Confusion and Diffusion in Cryptography

In cryptography the hashing, encryption algorithms and random generators follow the Shannon's principles of [confusion and diffusion](https://en.wikipedia.org/wiki/Confusion_and_diffusion). Confusion means that each bit in the output form a cipher should depend on several parts of the key and input data and thus direct mapping cannot be established. Diffusion means that changing one bit in the input should change approximately half of the bits in the output. These principles are incorporated in most hash functions, MAC algorithms, random number generators, symmetric and asymmetric ciphers.

## Appendix

### Why Bcrypt will take longer time to crack your password than MD5?

![2024_Password_Table_MD5](/research/encription/2024_Password_Table_MD5.png)
![2024_Password_Table_bcrypt](/research/encription/2024_Password_Table_bcrypt.png)
## Reference

- Okta: [HMAC (Hash-Based Message Authentication Codes) Definition](https://www.okta.com/identity-101/hmac/) (Sep 15, 2023)
- Cryptobook: [Cryptography - Overview](https://cryptobook.nakov.com/cryptography-overview) (Jun 19, 2019)
- Hivesystems: [Are Your Passwords in the Green?](https://www.hivesystems.com/blog/are-your-passwords-in-the-green) (2024)
