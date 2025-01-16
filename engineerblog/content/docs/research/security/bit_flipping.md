---
title: "Bit Flipping"
weight: 900
date: 2025-01-16
---

# Bit Flipping Attack

- As you can see in the [Packet Sniffing](/docs/research/security/packet_sniffing/) section, we have a discussion about how messages that go through the internet can easily be seen by hackers. One of our protection solutions is to **encrypt all packets that go through the internet**, but **is it enough?**

## Use case

- Attacking financial systems

## How it works

- An attacker alters bits in the ciphertext to produce a predictable change in the plaintext
- By flipping specific bits, the attacker can control certain parts of the plaintext, potentially altering critical information
- This manipulation allows the attacker to modify the encrypted message without needing to decrypt it first

![bit_flipping](/research/security/bit_flipping/bit_flipping.png)


## Prevention

- Implement [HMAC](/docs/research/encryption/#hmac)

## Demo

{{<hint danger>}}
**DISCLAIMER**: This demo is for educational purposes only. The techniques should only be tested on systems you own or have explicit permission to analyze. Misuse of this information is unethical, may violate the law, and could lead to serious consequences. The author takes no responsibility for any damages or misuse arising from this content
{{</hint>}}

{{<hint info>}}
This demo can be run directly in the console of the Chrome browser
{{</hint>}}

**Javascript**

{{<details title="Prepare" open=false >}}
```js
const iv = crypto.getRandomValues(new Uint8Array(16));
let key;

(async () => {
	key = await crypto.subtle.generateKey(
		{
			name: "AES-CBC",
			length: 128,
		},
		true,
		["encrypt", "decrypt"]
	);
})();

async function encryptData(plaintext) {
	const encoder = new TextEncoder();
	const data = encoder.encode(plaintext);
	const ciphertext = await crypto.subtle.encrypt(
		{
			name: "AES-CBC",
			iv,
		},
		key,
		data
	);

	return new Uint8Array(ciphertext);
}

async function decryptData(ciphertext) {
	const plaintextBuffer = await crypto.subtle.decrypt(
		{
			name: "AES-CBC",
			iv,
		},
		key,
		ciphertext
	);

	const decoder = new TextDecoder();
	return decoder.decode(plaintextBuffer);
}

function ord(string) {
	return string.charCodeAt(0);
}
```
{{</details>}}

{{<nl>}}

{{<details title="Main flow" open=false >}}
```js
(async () => {
    // User
	const plaintext = "{ Message: 'Doing  charity  work!', Money: 001 $, To: Beggar }";
	const ciphertext = await encryptData(plaintext);

    // Hacker
	ciphertext[43 - 16] = ord("0") ^ ciphertext[43 - 16] ^ ord("9");
	ciphertext[44 - 16] = ord("0") ^ ciphertext[44 - 16] ^ ord("9");
	ciphertext[45 - 16] = ord("1") ^ ciphertext[45 - 16] ^ ord("9");

    // Bank
	const decryptedText = await decryptData(ciphertext);
	console.log("Decrypted Text:", decryptedText);
})();
```
{{</details>}}

{{<nl>}}

{{<details title="Output" open=false >}}
```text
> Decrypted Text: { Message: 'Doin��iQ���'BT_�"!', Money: 999 $, To: Beggar }
```
{{</details>}}


## References

- Twingate: [What Is A Bit Flipping Attack? How It Works & Examples](https://www.twingate.com/blog/glossary/bit-flipping-attack) (Aug 15th, 2024)
- Hackernoon: [Why Using Hashing Alone is NOT Enough for Data Integrity](https://hackernoon.com/hmac-and-message-authentication-codes-why-using-hashing-alone-is-not-enough-for-data-integrity) (Aug 15th, 2023)
- Bigous: [A deep look into Cipher Block Chaining (CBC) Algorithm Bit Flipping](https://www.bigous.me/2023/11/17/CBC-bit-flipping-en.html) (Nov 17th, 2023)

{{< footer >}}
