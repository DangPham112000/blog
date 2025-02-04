---
title: "Encryption"
weight: 50
date: 2024-11-15
---

# Encryption

## Hash

- Can take a message of **arbitrary length** and transform it into a **fixed-length** digest
- Some of the commonly used hashing algorithms: **Bcrypt**, MD5, SHA1, SHA256, SHA512, and etc

`MD5('hello') = 5d41402abc4b2a76b9719d911017c592`

*Note: An 8-bit byte is represented as 2 characters, from 00 to FF, in hexadecimal*

### Good hash function

- Fast (exclude Bcrypt)
- **One-way function**
- Collision resistance

### Use case

- Checking file integrity
- Indexing in in-memory databases (Eg: Redis)
- Hashing passwords (+ salt)
- Message authentication code (MAC)
- Digital signatures

### Collision

![hashing_collision](/research/encription/hashing_collision.png)

{{<details title="**MD5 Collision Demo**" open=false >}}

d131dd02c5e6eec4693d9a0698aff95c2fcab5**8**712467eab4004583eb8fb7f89 
55ad340609f4b30283e4888325**7**1415a085125e8f7cdc99fd91dbd**f**280373c5b 
d8823e3156348f5bae6dacd436c919c6dd53e2**b**487da03fd02396306d248cda0 
e99f33420f577ee8ce54b67080**a**80d1ec69821bcb6a8839396f965**2**b6ff72a70

VS

d131dd02c5e6eec4693d9a0698aff95c2fcab5**0**712467eab4004583eb8fb7f89 
55ad340609f4b30283e4888325**f**1415a085125e8f7cdc99fd91dbd**7**280373c5b 
d8823e3156348f5bae6dacd436c919c6dd53e2**3**487da03fd02396306d248cda0 
e99f33420f577ee8ce54b67080**2**80d1ec69821bcb6a8839396f965**a**b6ff72a70 

**NodeJS**

```js
const crypto = require('crypto');

// Input 1 (Hexadecimal)
const input1 = Buffer.from(
  'd131dd02c5e6eec4693d9a0698aff95c2fcab58712467eab4004583eb8fb7f89' +
  '55ad340609f4b30283e488832571415a085125e8f7cdc99fd91dbdf280373c5b' +
  'd8823e3156348f5bae6dacd436c919c6dd53e2b487da03fd02396306d248cda0' +
  'e99f33420f577ee8ce54b67080a80d1ec69821bcb6a8839396f9652b6ff72a70',
  'hex'
);

// Input 2 (Hexadecimal)
const input2 = Buffer.from(
  'd131dd02c5e6eec4693d9a0698aff95c2fcab50712467eab4004583eb8fb7f89' +
  '55ad340609f4b30283e4888325f1415a085125e8f7cdc99fd91dbd7280373c5b' +
  'd8823e3156348f5bae6dacd436c919c6dd53e23487da03fd02396306d248cda0' +
  'e99f33420f577ee8ce54b67080280d1ec69821bcb6a8839396f965ab6ff72a70',
  'hex'
);

// Function to calculate MD5 hash
function calculateMD5(data) {
  return crypto.createHash('md5').update(data).digest('hex');
}

console.log('Are the inputs identical?', input1 === input2);

const hash1 = calculateMD5(input1);
const hash2 = calculateMD5(input2);

console.log('MD5 Hash of Input 1:', hash1);
console.log('MD5 Hash of Input 2:', hash2);

console.log('Are the hashes identical?', hash1 === hash2);

```
```text
Are the inputs identical? false
MD5 Hash of Input 1: 79054025255fb1a26e4bc422aef54eb4
MD5 Hash of Input 2: 79054025255fb1a26e4bc422aef54eb4
Are the hashes identical? true
```
{{</details>}}

## Symmetric encryption

Uses the same key to encrypt and decrypt messages

AES, Twofish and ChaCha20

![Symmetric](/research/encription/Symmetric.png)

### Use case

- HTTP over SSL/TLS: Session key
- Data Transmission
- Data Storage

### Demo code

This example demonstrates symmetric encryption and decryption  using the crypto module with AES (Advanced Encryption Standard) in AES-256-CBC mode

**NodeJS**

{{<details title="Init necessary functions" open=false >}}
```js
const crypto = require('crypto');

function generateKeyAndIv() {
    const key = crypto.randomBytes(32).toString('hex'); // 256-bit key as hex string
    const iv = crypto.randomBytes(16).toString('hex'); // 128-bit IV as hex string
    return { key, iv };
}

function encrypt(text, keyHex, ivHex) {
    const key = Buffer.from(keyHex, 'hex'); // Convert key from hex to Buffer
    const iv = Buffer.from(ivHex, 'hex');   // Convert iv from hex to Buffer
    const cipher = crypto.createCipheriv('aes-256-cbc', key, iv);
    let encrypted = cipher.update(text, 'utf8', 'hex');
    encrypted += cipher.final('hex');
    return encrypted;
}

function decrypt(encryptedText, keyHex, ivHex) {
    const key = Buffer.from(keyHex, 'hex'); // Convert key from hex to Buffer
    const iv = Buffer.from(ivHex, 'hex');   // Convert iv from hex to Buffer
    const decipher = crypto.createDecipheriv('aes-256-cbc', key, iv);
    let decrypted = decipher.update(encryptedText, 'hex', 'utf8');
    decrypted += decipher.final('utf8');
    return decrypted;
}
```
{{</details>}}

{{<nl>}}

{{<details title="Encrypt and decrypt a message" open=false >}}
```js
const { key, iv } = generateKeyAndIv();
console.log("Generated Key (hex):", key);
console.log("Generated IV (hex):", iv);

const message = "Hello, this is a secret message!";
console.log("Original Message:", message);

const encryptedMessage = encrypt(message, key, iv);
console.log("Encrypted Message:", encryptedMessage);

const decryptedMessage = decrypt(encryptedMessage, key, iv);
console.log("Decrypted Message:", decryptedMessage);
```

**Output**
```text
Generated Key (hex): 00298bfc28cf81a3de3502951b70f3568c4dd5dadbcfadd7b79fee2e640aee07
Generated IV (hex): 387591abb794b2345f496bb1192ace36
Original Message: Hello, this is a secret message!
Encrypted Message: 96b91c46b8e380a3b3fc9caf473821508f1ec313ed8b4306eb839c9c04f3692ed0579485016559e272ba9c3c54c5c449
Decrypted Message: Hello, this is a secret message!
```
{{</details>}}

{{<nl>}}

{{<details title="Decrypt a message with wrong key" open=false >}}
```js
const { key, iv } = generateKeyAndIv();
console.log("Generated Key (hex):", key);
console.log("Generated IV (hex):", iv);

const { key: key2 } = generateKeyAndIv();
console.log("Generated Key 2 (hex):", key2);

const message = "Hello, this is a secret message!";
console.log("Original Message:", message);

const encryptedMessage = encrypt(message, key, iv);
console.log("Encrypted Message:", encryptedMessage);

const decryptedMessage = decrypt(encryptedMessage, key2, iv);
console.log("Decrypted Message:", decryptedMessage);
```

**Output**
```text
Generated Key (hex): 0e35a011a116b0708012ae4165b95be678300be387478c1f217dbc48a1e5f2e8
Generated IV (hex): 6b714efdcab58ebc399332b79df8354d
Generated Key 2 (hex): c5bd73c9fa521dd1b019b3be1010645fc2152db17401006781a3908db43ca94f
Original Message: Hello, this is a secret message!
Encrypted Message: a4b90407ab748d8002d2f33b6ae8698460ed11d1640592fb2e83da9f101e7795ba54e447162f5373f49592ebfff8fa5c
node:internal/crypto/cipher:199
  const ret = this[kHandle].final();
                            ^

Error: error:1C800064:Provider routines::bad decrypt
    at Decipheriv.final (node:internal/crypto/cipher:199:29)
    at decrypt (/home/dangpham/Workspace/nodejs/demo/symmetric.js:23:27)
    at Object.<anonymous> (/home/dangpham/Workspace/nodejs/demo/symmetric.js:55:26)
    at Module._compile (node:internal/modules/cjs/loader:1356:14)
    at Module._extensions..js (node:internal/modules/cjs/loader:1414:10)
    at Module.load (node:internal/modules/cjs/loader:1197:32)
    at Module._load (node:internal/modules/cjs/loader:1013:12)
    at Function.executeUserEntryPoint [as runMain] (node:internal/modules/run_main:128:12)
    at node:internal/main/run_main_module:28:49 {
  library: 'Provider routines',
  reason: 'bad decrypt',
  code: 'ERR_OSSL_BAD_DECRYPT'
}

Node.js v18.19.1
```
{{</details>}}

{{<nl>}}

{{<details title="Decrypt a message with wrong iv" open=false >}}
```js
const { key, iv } = generateKeyAndIv();
const { iv: iv2 } = generateKeyAndIv();
const message = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.";
console.log("Original Message:", message);

const encryptedMessage = encrypt(message, key, iv);
console.log("Encrypted Message:", encryptedMessage);

const decryptedMessage = decrypt(encryptedMessage, key, iv2);
console.log("Decrypted Message:", decryptedMessage);
```

**Output**
```text
Generated Key (hex): 76e1a03f6b3e326cd8c383ce12ff6fbd4b77c484afa7811f93304bc548b9de01
Generated IV (hex): 11edd0224d639ac9d8b1c0a1297ed758
Generated IV2 (hex): aca3f6cd3738dab6c97c43a211ec121f
Original Message: Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.
Encrypted Message: 3189b2b3fbb3d511086609f2cbb5f68928fd980bad454fbcfba3c7aada3f6499832a19be0b6285f3b6ed175d67b4fb04c76c4443873a7f6eecbbf3a667dfc70146916de1f55d5e6d057bbed520e9489b97ce25d1cae41a58db5fe3adcf59d6f0d668a4b9561f32303544b90aa5a800000fe2f30f611e9b23af7170e9f95abecd2023df028570e8816a02c603883a90b1b722f2139b3588e78f4dad472f1e799875e30e8a54f9ae9a761779963abd83cc9a8138a91f57b66a9c499a0e0ae0d57ee409bd381d15c52fdeee4b96684cc35bf2db78dedfa433db25fd1323c887597693571d9dab1c1b052a9ed74195aae89a6db5ef47bed08aae24100b19e7ca3e64389fa8b99ad89104f50a7aa291731985e0b464213df61e50df2df5b22b21767987e5b40c5def1ae6ce80a34845d13ca06a6fe250ef291a4ef01b01b531c843d0201b8b06d41b727e0799dd6742a5814a76fefc57a0ba1f7badc854702e8c6f2f88c13d320c45c300a007464c64e73919403e21527570dec2afbb21746fded82a4360887ff7aad565a797cc731deb6cf6f23dccb73427b21c061f46939d1d5e6ef7b16079467199a9ce03f558dbcb3141f2502683cb5af69ec47e35f343bb5e25
Decrypted Message: �!T�{)b��#\��(r sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.

```
{{</details>}}


## HMAC

- HMAC stands for Hash-based Message Authentication Code
- It's a method that generates a **Message Authentication Code** (MAC)
- The major **difference** between a **hash** and an **HMAC** is that HMAC uses a **secret key**
- It's used to prove message authenticity and **integrity**
- There exist many algorithms for calculating a MAC, such as SipHash, BLAKE2, CMAC, etc

![hmac](/research/encription/hmac.png)

### Why and how

- See more details about the bit-flipping attack [here](/docs/research/security/bit_flipping)

![bit_flipping](/research/security/bit_flipping/bit_flipping.png)

- Here shows you how HMAC prevents a bit-flipping attack

![hmac_flow](/research/encription/hmac_flow.png)

### Use case

- Signing **JSON Web Tokens** (JWTs) for secure authentication
- Signing files in **secure file transfer protocols**. Eg: SSH File Transfer Protocol (SFTP), FTP over SSL (FTPS)
- Verifying the integrity and authenticity of transactions in banking

### Demo

This example demonstrates how HMAC prevents bit-flipping attack

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

async function deriveHmacKey(aesKey) {
	const rawKey = await crypto.subtle.exportKey("raw", aesKey); 
	return crypto.subtle.importKey(
		"raw",
		rawKey,
		{
			name: "HMAC",
			hash: { name: "SHA-1" }, 
		},
		true,
		["sign", "verify"]
	);
}

async function signData(data) {
	const encoder = new TextEncoder();
	const encodedData = encoder.encode(data);
	const hmacKey = await deriveHmacKey(key);
	const signature = await crypto.subtle.sign("HMAC", hmacKey, encodedData);

	return new Uint8Array(signature);
}

async function verifyData(data, signature) {
	const encoder = new TextEncoder();
	const encodedData = encoder.encode(data);
	const hmacKey = await deriveHmacKey(key);
	const isValid = await crypto.subtle.verify(
		"HMAC",
		hmacKey,
		signature,
		encodedData
	);

	return isValid;
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
	const signature = await signData(ciphertext);

    // Hacker
	ciphertext[43 - 16] = ord("0") ^ ciphertext[43 - 16] ^ ord("9");
	ciphertext[44 - 16] = ord("0") ^ ciphertext[44 - 16] ^ ord("9");
	ciphertext[45 - 16] = ord("1") ^ ciphertext[45 - 16] ^ ord("9");

    // Bank
	const decryptedText = await decryptData(ciphertext);
	console.log("Decrypted Text:", decryptedText);
	const isVerified = await verifyData(ciphertext, signature);
	console.log("Signature valid:", isVerified);
})();
```
{{</details>}}

{{<nl>}}

{{<details title="Output" open=false >}}
```text
> Decrypted Text: { Message: 'Doin��iQ���'BT_�"!', Money: 999 $, To: Beggar }
> Signature valid: false
```
{{</details>}}

## Asymmetric encryption

- There are generally three things asymmetric algorithms can do:
    - **Encrypt/decrypt**: RSA, EC ElGamal
    - **Sign/verify**: RSA, DSA, ECDSA
    - **Key exchange**: Diffie-Hellman, ECDH
- The **amount of data** that can be encrypted **depends on** the **modulus length** and the **type** (e.g., RSA 2048-bit modulus length with PKCS#1 can encrypt a maximum of (`(<modulus length> / 8) - 42` = **2048** / 8) - 42 = 214 bytes)

![Asymmetric](/research/encription/Asymmetric.png)

### Public encryption / private decryption

- Algorithms: RSA, EC ElGamal
- Common usage
- Use cases: [Key exchange in SSL/TLS 1.2](/docs/research/be_protocol/tls_ssl/#tls-12)

**NodeJS**

{{<details title="Init necessary functions" open=false >}}
```js
const crypto = require('crypto');

const generateKeyPair = () => {
    return crypto.generateKeyPairSync('rsa', {
        modulusLength: 2048, // Length of key in bits (2048 is standard)
        publicKeyEncoding: {
            type: 'pkcs1', // Public Key Cryptography Standards 1
            format: 'pem'  // Output as PEM (Base64 encoded)
        },
        privateKeyEncoding: {
            type: 'pkcs1', // Private Key Cryptography Standards 1
            format: 'pem'  // Output as PEM (Base64 encoded)
        }
    });
}

function encryptWithPublicKey(publicKeyPem, message) {
    const encrypted = crypto.publicEncrypt(publicKeyPem, Buffer.from(message));
    return encrypted.toString('base64');  // Convert encrypted message to base64 for readability
}

function decryptWithPrivateKey(privateKeyPem, encryptedMessage) {
    const decrypted = crypto.privateDecrypt(privateKeyPem, Buffer.from(encryptedMessage, 'base64'));
    return decrypted.toString('utf8');  // Convert decrypted message to utf8 string
}
```
{{</details>}}

{{<nl>}}

{{<details title="Public key to encrypt and private key to decrypt a message" open=false >}}
```js
const { publicKey, privateKey } = generateKeyPair();
console.log("Public Key (PEM format):\n", publicKey);
console.log("Private Key (PEM format):\n", privateKey);

const message = "Hello, this is a secret message!";
console.log("Original Message:", message);

const encryptedMessage = encryptWithPublicKey(publicKey, message);
console.log("Encrypted Message:", encryptedMessage);

const decryptedMessage = decryptWithPrivateKey(privateKey, encryptedMessage);
console.log("Decrypted Message:", decryptedMessage);
```

**Output**
```text
Public Key (PEM format):
 -----BEGIN RSA PUBLIC KEY-----
MIIBCgKCAQEA0ivCBvmxFewdtUePX8RG3+SKifuEz9dsoSEJzQiCbdOfxCzZiyCb
R7azQhY67IKC93qr/j7zyCGx3WJ2lrRd4ij51Q9CIn75zPExEfLMvCt0HQtO+UQo
w0QZLGIZc6Q+eJfQg++PeUVYpZPT/jp3RXHEScpZJfHCarhl6JfCkuu3YuITSpta
rhUuaw6UMoWnZCbr0/OW2rC3s97p+VIr5i3jCf+z84E7dTZ529mZ1PsxNue5NKqO
/SWyjrNvwORMkdYweoSqz5oZ0U2B29mUWRkhcOrPmrRBCxMRwWTmQC3PpzrAwG2/
eQfbKX1tzzSVjjjMUgKvmeLvr57au62yLwIDAQAB
-----END RSA PUBLIC KEY-----

Private Key (PEM format):
 -----BEGIN RSA PRIVATE KEY-----
MIIEowIBAAKCAQEA0ivCBvmxFewdtUePX8RG3+SKifuEz9dsoSEJzQiCbdOfxCzZ
iyCbR7azQhY67IKC93qr/j7zyCGx3WJ2lrRd4ij51Q9CIn75zPExEfLMvCt0HQtO
+UQow0QZLGIZc6Q+eJfQg++PeUVYpZPT/jp3RXHEScpZJfHCarhl6JfCkuu3YuIT
SptarhUuaw6UMoWnZCbr0/OW2rC3s97p+VIr5i3jCf+z84E7dTZ529mZ1PsxNue5
NKqO/SWyjrNvwORMkdYweoSqz5oZ0U2B29mUWRkhcOrPmrRBCxMRwWTmQC3PpzrA
wG2/eQfbKX1tzzSVjjjMUgKvmeLvr57au62yLwIDAQABAoIBAELNKr4p1gn4QxcP
+DfBvJ9EVm52Fegz+jCavjE/r6k11vW1Ja4tfn2ESiTKyQ7MitEbWhiVLMojP5P0
zGmpSZ/tUz9Pur8ZKc/kp6qjSETU8PKcWg0rh2NNPU0Ynytc/Ig7BMkytyEeFAeI
3ZxUO/3EI9YqbTx8w8VE+As+VVd55dkkoEShi77ibxFNeevWvS46k/d1a5hcsVj8
NlsngHux8ZwUu8ZaIQH0wclLo77TcDOJF9NkJb7x8xzXH/pvNOPu49nA098zob6c
ivZTW6z2Jsa94NzPzvCQ/NLumrkt07bE0HBXJCkaajlhjn69gXR2fEfWVrryW3e9
sLFEPJUCgYEA9hz4qFpM/QB4q1AzNR7ZK5vfzfAIAQWPmbVpFZXYdUD+tzXut7Yu
dd4WZU1l/LgUeLUmUfJqDwiMOz/pGSTNcJqtHl3wP2Yz9n1fcWhxdbjbPZkB1+Di
dhKkxvxEih4PyK+367udHcJYF+Su7Pl2hNmBMvTc0rzWpdJHRVCrwEMCgYEA2p0o
Dyy5dBhrMCi083074qQhdXQqX1+f0KDZXy1u8JtooktbpARfyc+P9/hT+sdvxln7
hEsYPkplvPS3ahm0tb4tCW1esAZLhn8RvYJqJConBawKRw2oVJ9YCW1Et4vn+oKU
pLfvmgX/PgCIuVn6szmU4LUj9pHoaoE5E0ulLaUCgYEA5n+dtvbTsgR1/2RegTrC
BGC5TAOpS2Os6TWJFKlBkBduN6KwT6i1fLiiWwARK44vxhlKqWcTQ78qrvcdVeos
6nBDAPTT5FzQ/+LNt8YstSeLVfZuToQVNKYjYyWy/3RGLhu8cnBFJzD0FnScC99b
y/J1WYcRJeGsWqNFErsKEEcCgYAw/e0/UVeSU/KZjVXYB2XHSd8RsmHYk9Z9674r
HURyeXF+hYLZA/3vfSuXd7hiSBWdjwbVw/p/4y5fpTwBdBdSb3cqWK9SpWaBkrKI
FNTym9u44rA+8imaJUeWfT1cIOdw9ZiYPXxduSBVZcs+NpL/XVUm8pFHrbU3QRRo
ZZhz3QKBgHcVAZq3TaigmrupfdGlSDN+NdxP7EhOlGaYu5LuJcfic2q/W1+SKoQK
5osEUzV/SeWQH5oHW/2ASx2GOwyiWcn2RfXRFPSXfX4aHfO3JBOZVJ8Wzql9WhST
NEw2BFi05XXkbE/ncxq5+SZsHVGQVZ0hlkG2oPc3Hp7sDAMJSDQC
-----END RSA PRIVATE KEY-----

Original Message: Hello, this is a secret message!
Encrypted Message: Vb+Oc8Kn76rvjJuXZOvtLGsQDm/VGXzB2KbqzWXr5UMZV4bXLkhCs407H4Li4ImROH6uPXlA+SNPSYr0XpLQ+Uksnt2b8YbUQZUSvi15bJbXKKXsvo9FLg2ygcSUiqBjGs3coMbWh0sZnGN+GpXbIld8ItGCkLRnMDkvCK/uzgA11bmLcBOFt726ytjK0qGJGDM1svL2A2ZTXGgnLMUSnSzNxWv5K4sUU0yi38/ineL1Kc6FLlUo3YrLnW6MvB0rp+lF9VRGw8Sbagpm01PcnQiQH28OmbQxLomScQ4Mq1EXqN7oVgE2kMDXIO0mec6I0TmLtsLjWirN0iT2Um/cDQ==
Decrypted Message: Hello, this is a secret message!

```
{{</details>}}

{{<nl>}}

{{<details title="Private key to encrypt and decrypt a message" open=false >}}
```js
const { privateKey } = generateKeyPair();
console.log("Private Key (PEM format):\n", privateKey);

const message = "Hello, this is a secret message!";
console.log("Original Message:", message);

const encryptedMessage = encryptWithPublicKey(privateKey, message);
console.log("Encrypted Message:", encryptedMessage);

const decryptedMessage = decryptWithPrivateKey(privateKey, encryptedMessage);
console.log("Decrypted Message:", decryptedMessage);
```

**Output**
```text
Private Key (PEM format):
 -----BEGIN RSA PRIVATE KEY-----
MIIEpAIBAAKCAQEA8+Vsp8r+fNSpHdr+cr8+8tX+Tmm/1oCtU4dlVSz+auKLj490
duuh+rZ2ud7zgMzzCd9cSqFs4JWHsAFbx2oe4LSWD++V7ZES3ORE+48ksziCMC/r
...
EZUgvYiHTgt3lJnQunBQPGug59B4mB8JRPZIdrpZc8acTA0X5+Ys8PRSwFoNzQ+b
pDxXQo6e+j9SU9xi9ULFuK9ZZp48ERgX8MqG+1fdxGU+LFHfK192Kw==
-----END RSA PRIVATE KEY-----

Original Message: Hello, this is a secret message!
Encrypted Message: V3fyDYvqx5OzPBJfKO434XKTUSC+c7KnpsvjpSdkUYR+BfrK0A+4V+y1Mf7uuCWaCRIA4Npu9aRoAgDPV8u7Zwc7h6sGaGo8WSofWsADCobDiN1d1dX0Htxurr9tVNmcdvXBxigyLK93h+Q7xXg5Xn2RdBpItPBHDITxfBlCRdyDZX+x81b1xTCdue6mTQwEp8CkJpZsahEPYgW7tYA+rWBu147Cz0jKEstk62Udxc82WYMRT+za0pz2nqSVqDKZCpaXBT1xlmPNgy14bzuLNZbykyUScly3PJUmybi9Ml/+OYjPwLY+XuYbXDklV2OX2fPsiuTo0iwXOwZB7HRE1Q==
Decrypted Message: Hello, this is a secret message!
```
{{</details>}}

{{<nl>}}

{{<details title="Private key to encrypt and public key to decrypt a message" open=false >}}
```js
const { publicKey, privateKey } = generateKeyPair();
console.log("Public Key (PEM format):\n", publicKey);
console.log("Private Key (PEM format):\n", privateKey);

const message = "Hello, this is a secret message!";
console.log("Original Message:", message);

const encryptedMessage = encryptWithPublicKey(privateKey, message);
console.log("Encrypted Message:", encryptedMessage);

const decryptedMessage = decryptWithPrivateKey(publicKey, encryptedMessage);
console.log("Decrypted Message:", decryptedMessage);
```

**Output**
```text
Public Key (PEM format):
 -----BEGIN RSA PUBLIC KEY-----
MIIBCgKCAQEA2UVnWwcABrWqMggU7xxkl25zzV3/FabJvFDiGtaWjTUhLu9QjKtO
...
wUXBn7HZjrd8Oue5JVPL1KqpUABxLBYc1QIDAQAB
-----END RSA PUBLIC KEY-----

Private Key (PEM format):
 -----BEGIN RSA PRIVATE KEY-----
MIIEpAIBAAKCAQEA2UVnWwcABrWqMggU7xxkl25zzV3/FabJvFDiGtaWjTUhLu9Q
...
lXDeVDYNZZ5oYCOWxjoAYamUbPrXD+SDGsDwnlgcaHViBBxUeGElHw==
-----END RSA PRIVATE KEY-----

Original Message: Hello, this is a secret message!
Encrypted Message: VwgGUHIcxGAO5J5THYzxEgrmGQlIWy8Xg8f+c2zuyWjEzlgkat2TIyJa4fZ/vvf/kmIaetfw2cJf7wSvDfHP+yikVYRN2/uQ67pE6dK+FtW0d5GK6HaoM4c6QP/DbeMbikywSFjxYiyKsqp7eREtv8rdEgpde7OVL3pthSZmoJWUoSFNUvMqJT5+D1hPv8J38TlNdEUp7YrIQdx/gyZx8w6q+uikyboJbEJ2Z4YCfJVUbw1Fwbijox/jb8bWRFO6OHb2XXC4w2LXGLoZdxAAykRQ19BTsV6ojMflb1Bw428Q2GNaiolJXZX7j20rVRjM0KccLvHQ5FLPzTmK3BHQxg==
node:internal/crypto/cipher:80
    return method(data, format, type, passphrase, buffer, padding, oaepHash,
           ^

Error: error:020000B3:rsa routines::missing private key
    at Object.privateDecrypt (node:internal/crypto/cipher:80:12)
    at decryptWithPrivateKey (/home/dangpham/Workspace/nodejs/demo/asymmetric.js:23:30)
    at Object.<anonymous> (/home/dangpham/Workspace/nodejs/demo/asymmetric.js:66:26)
    at Module._compile (node:internal/modules/cjs/loader:1356:14)
    at Module._extensions..js (node:internal/modules/cjs/loader:1414:10)
    at Module.load (node:internal/modules/cjs/loader:1197:32)
    at Module._load (node:internal/modules/cjs/loader:1013:12)
    at Function.executeUserEntryPoint [as runMain] (node:internal/modules/run_main:128:12)
    at node:internal/main/run_main_module:28:49 {
  opensslErrorStack: [ 'error:1C8000A2:Provider routines::failed to decrypt' ],
  library: 'rsa routines',
  reason: 'missing private key',
  code: 'ERR_OSSL_RSA_MISSING_PRIVATE_KEY'
}

Node.js v18.19.1
```
{{</details>}}


### Private sign (encryption) / public verify (decryption)

- Algorithms: RSA, DSA, ECDSA
- Use cases: [Token-based authentication](/docs/research/token_based_authentication), [digital signatures](#digital-signatures)

**NodeJS**

{{<details title="Init necessary functions" open=false >}}
```js
const crypto = require('crypto');

const generateKeyPair = () => {
    return crypto.generateKeyPairSync('rsa', {
        modulusLength: 2048, // Length of key in bits (2048 is standard)
        publicKeyEncoding: {
            type: 'pkcs1', // Public Key Cryptography Standards 1
            format: 'pem'  // Output as PEM (Base64 encoded)
        },
        privateKeyEncoding: {
            type: 'pkcs1', // Private Key Cryptography Standards 1
            format: 'pem'  // Output as PEM (Base64 encoded)
        }
    });
}

// Function to "sign" (encrypt) a message using RSA private key
function signWithPrivateKey(privateKeyPem, message) {
    const encrypted = crypto.privateEncrypt(privateKeyPem, Buffer.from(message));
    return encrypted.toString('base64');  // Convert encrypted message to base64 for readability
}

// Function to "verify" (decrypt) a message using RSA public key
function verifyWithPublicKey(publicKeyPem, encryptedMessage) {
    const decrypted = crypto.publicDecrypt(publicKeyPem, Buffer.from(encryptedMessage, 'base64'));
    return decrypted.toString('utf8');  // Convert decrypted message to utf8 string
}
```
{{</details>}}

{{<nl>}}

{{<details title="Private key to encrypt and public key to decrypt a message" open=false >}}
```js
const { publicKey, privateKey } = generateKeyPair();
console.log("Public Key (PEM format):\n", publicKey);
console.log("Private Key (PEM format):\n", privateKey);

const message = "J5 love ST";
console.log("Original Message:", message);

// "Sign" the message using the private key (Encrypt)
const encryptedMessage = signWithPrivateKey(privateKey, message);
console.log("Encrypted Message (Base64):", encryptedMessage);

// "Verify" the message using the public key (Decrypt)
const decryptedMessage = verifyWithPublicKey(publicKey, encryptedMessage);
console.log("Decrypted Message:", decryptedMessage);
```

**Output**
```text
Public Key (PEM format):
 -----BEGIN RSA PUBLIC KEY-----
MIIBCgKCAQEAnxkXw9Cbi4F+tsJImVUNVhOUTYWj/lMUB+jcXBE6myqgZ4xiHWWx
0nGzjqxHiojYcN3jiEtABqbls2KToTs9LvNHDYcr8bPh828HZTcB6V9r1x79zFSp
jJtvx4hmOa0K7iOiN2AwWaV1mtFTKOZ/2QsQMqyhleBgPMCQyD6CYS2IJrRq6Wu+
anekIYgfWToajrpbgs4AE5X0aTd10/0eR0A7n3C8jGKiyAaTsROBtqvmoq69QGrW
ozDOWl/Dt6I3Y/a0Vx6lyL2bjClbIo61yJqkxW0VWFLodFuKvjd8gln3PZokTiEl
fjQFKVj63Wh/ssXHQjFtYvnmS73gMATYSwIDAQAB
-----END RSA PUBLIC KEY-----

Private Key (PEM format):
 -----BEGIN RSA PRIVATE KEY-----
MIIEowIBAAKCAQEAnxkXw9Cbi4F+tsJImVUNVhOUTYWj/lMUB+jcXBE6myqgZ4xi
HWWx0nGzjqxHiojYcN3jiEtABqbls2KToTs9LvNHDYcr8bPh828HZTcB6V9r1x79
zFSpjJtvx4hmOa0K7iOiN2AwWaV1mtFTKOZ/2QsQMqyhleBgPMCQyD6CYS2IJrRq
6Wu+anekIYgfWToajrpbgs4AE5X0aTd10/0eR0A7n3C8jGKiyAaTsROBtqvmoq69
QGrWozDOWl/Dt6I3Y/a0Vx6lyL2bjClbIo61yJqkxW0VWFLodFuKvjd8gln3PZok
TiElfjQFKVj63Wh/ssXHQjFtYvnmS73gMATYSwIDAQABAoIBADBGznnKPrC92iP9
30a70sCoT0uYvlMJhZ4C0H8VcUmtTSAuroUKG0Pm4Zvs9gZ5EOhqxETSxLpgAXqF
8pMtpRqukoRt3G1K7sjOC5nwb6GPpWsRCeVrWUmDzw7melKNCjCJ2orgIrvJI98X
HpteGjRTkZY24Q9YFwvISQaiRTDURBuTN1xmKNJ22AFU9oinLbedg0wPJ3xS5YPP
nROv8Gz/buoRrxysObguPgaBcOPQB3qz1qdsXwjnCDfQGKzo8LrFGtD1z3Zu4jWx
CfxzGisk45FuE0FWksNMwD0mKXDh11unA3p/xCstbwD2ISIiFhSvG09tGYl5pqlD
tGOZj2UCgYEA0OAyKRCNKPRxj1nXFtg7eR02YXxlnIqhl1ggXdW6hpwTx1t+Bu28
Qi5OsDOBivkTHjqt3x5DQTQTaOdpfwDBUpuYM4NIxL6EoFZaC2R26ocaIsZ4qKkk
SmBJW1Yx5iRWrurKB+1iwVshcjAHFyYWiltM4iL25RKAAeE7M1inlGcCgYEAwv3w
ceg+/mTmhE9XfW9N6ThEHvnoneHjuil5/7RN4XONDgB5Av68iimOTlcROmrc27TY
UcZvDI0j7yrAwv+7Z9I9DS56vSPpqYEC0HXayyFiCn3CS2Om0ySMYdTVJRi+53kf
8qZVEW9OMyRNIbc9djKObN4wTijMiRbZpmT2Tn0CgYAApnIBhrepxPkFhTYSMCIf
QmQE8aovTo8qNXAEWsH14U5+dF50DxFi81nzWnWwxQ22LmCULTfwYAUfcnj1mD8B
ztIudt4nHqCzDxHAr1Nfb4Q5T3zYqY4fXSVdT2tgWASdDsYKOEbyayIzhMrA27F+
RMJ8gbdbBy+20cipZEFBSQKBgQCEGB2EPO43zkjvRwSg//8KyEg1p9zy3+0y1xhD
pnTAD1R2MNHJuqIlAsPZxFfyeCRIXnnQ5BmkqhS22AKf1ziwu5cKT/tsGGEZqEEs
0To4M9REAS/XfJmuHetP9yuxptLk4oRHEHE+j2WtdaEe/xCO+u7LR7X3rOHq2OT3
ORw2zQKBgEACN6Qhs+ExE2+MLlC/8IaI3mPwa893LFk65/qHMuUQ2xUniJo2fQV5
BomT4OFSDaPBftdL1a/WVg6/EvN9Re1VBncAycCsLeSB+UHnk3+MvQTCh5E3j/Vy
gvIAt3PKqHBQTTx8p3CSxaDp91U6ru3OxetBgIchdHavxCXOkvrW
-----END RSA PRIVATE KEY-----

Original Message: J5 love ST
Encrypted Message (Base64): cG6810O8omJ67Ji6ZoQRw2um5UTx6YdTvUXWlH4GrUtph5J3xVqJhta4SWgJHNjaMgfMveJpFPTv/iAq0yBskmha+f+hRyYOITzXcz3jqtOl+4G9dC/OyqdkGIHq96lF9YZmWrXVtkCncRR07XoL+AMiBJ37HUgbHS15axAtghtJSYfWzabASA13sbEewVgQTIvg+aH9NvG5s2gKxLNIPtKcqUvmmqB2P0hFhg437QaF4SM/MBz/w7HbQT69B+YveBW8pFcgxAl+oIdl+dAneCog0FZiWI5mg13jlUmx4s7dhBKu7Ebdtayk3pZsHCKCYHNyePgSYA8bnUEqUVw+Hg==
Decrypted Message: J5 love ST
```
{{</details>}}

{{<nl>}}

{{<details title="Public key to encrypt and decrypt a message" open=false >}}
```js
const { publicKey } = generateKeyPair();
console.log("Public Key (PEM format):\n", publicKey);

const message = "J5 love ST";
console.log("Original Message:", message);

const encryptedMessage = signWithPrivateKey(publicKey, message);
console.log("Encrypted Message (Base64):", encryptedMessage);

const decryptedMessage = verifyWithPublicKey(publicKey, encryptedMessage);
console.log("Decrypted Message:", decryptedMessage);
```

**Output**
```text
Public Key (PEM format):
 -----BEGIN RSA PUBLIC KEY-----
MIIBCgKCAQEA1GV0AyMKyczyUpRyIolyuDRkw5hpkqhojoZ4KJvh11bqDe6H2mjJ
...
f3Io9s6lsPaN3zWxDxxJJMo5SsX48T5NQQIDAQAB
-----END RSA PUBLIC KEY-----

Original Message: J5 love ST
node:internal/crypto/cipher:80
    return method(data, format, type, passphrase, buffer, padding, oaepHash,
           ^

Error: error:020000B3:rsa routines::missing private key
    at Object.privateEncrypt (node:internal/crypto/cipher:80:12)
    at signWithPrivateKey (/home/dangpham/Workspace/nodejs/demo/asymmetricLikeJWT.js:19:30)
    at Object.<anonymous> (/home/dangpham/Workspace/nodejs/demo/asymmetricLikeJWT.js:56:26)
    at Module._compile (node:internal/modules/cjs/loader:1356:14)
    at Module._extensions..js (node:internal/modules/cjs/loader:1414:10)
    at Module.load (node:internal/modules/cjs/loader:1197:32)
    at Module._load (node:internal/modules/cjs/loader:1013:12)
    at Function.executeUserEntryPoint [as runMain] (node:internal/modules/run_main:128:12)
    at node:internal/main/run_main_module:28:49 {
  opensslErrorStack: [ 'error:1C880004:Provider routines::RSA lib' ],
  library: 'rsa routines',
  reason: 'missing private key',
  code: 'ERR_OSSL_RSA_MISSING_PRIVATE_KEY'
}

Node.js v18.19.1
```
{{</details>}}

{{<nl>}}

{{<details title="Public key to encrypt and private key to decrypt a message" open=false >}}
```js
const { publicKey, privateKey } = generateKeyPair();
console.log("Public Key (PEM format):\n", publicKey);
console.log("Private Key (PEM format):\n", privateKey);

const message = "J5 love ST";
console.log("Original Message:", message);

const encryptedMessage = signWithPrivateKey(publicKey, message);
console.log("Encrypted Message (Base64):", encryptedMessage);

const decryptedMessage = verifyWithPublicKey(privateKey, encryptedMessage);
console.log("Decrypted Message:", decryptedMessage);
```

**Output**
```text
Public Key (PEM format):
 -----BEGIN RSA PUBLIC KEY-----
MIIBCgKCAQEAoqD5nBZ1axzJnDyxmuQmb11/3NBVZlk4py/X64ew9HH5NzrwkH04
...
t1rjt5xOTmK5N0fyrxNoouTqIpV3E85P/QIDAQAB
-----END RSA PUBLIC KEY-----

Private Key (PEM format):
 -----BEGIN RSA PRIVATE KEY-----
MIIEowIBAAKCAQEAoqD5nBZ1axzJnDyxmuQmb11/3NBVZlk4py/X64ew9HH5Nzrw
...
fKcxqqYvJv2yio3ogNZSJsFGFU1lafg7FwWMgqnd/99nWBCY2gn1
-----END RSA PRIVATE KEY-----

Original Message: J5 love ST
node:internal/crypto/cipher:80
    return method(data, format, type, passphrase, buffer, padding, oaepHash,
           ^

Error: error:020000B3:rsa routines::missing private key
    at Object.privateEncrypt (node:internal/crypto/cipher:80:12)
    at signWithPrivateKey (/home/dangpham/Workspace/nodejs/demo/asymmetricLikeJWT.js:19:30)
    at Object.<anonymous> (/home/dangpham/Workspace/nodejs/demo/asymmetricLikeJWT.js:73:26)
    at Module._compile (node:internal/modules/cjs/loader:1356:14)
    at Module._extensions..js (node:internal/modules/cjs/loader:1414:10)
    at Module.load (node:internal/modules/cjs/loader:1197:32)
    at Module._load (node:internal/modules/cjs/loader:1013:12)
    at Function.executeUserEntryPoint [as runMain] (node:internal/modules/run_main:128:12)
    at node:internal/main/run_main_module:28:49 {
  opensslErrorStack: [ 'error:1C880004:Provider routines::RSA lib' ],
  library: 'rsa routines',
  reason: 'missing private key',
  code: 'ERR_OSSL_RSA_MISSING_PRIVATE_KEY'
}

Node.js v18.19.1
```
{{</details>}}

{{<nl>}}

{{<details title="Private key to encrypt and decrypt a message" open=false >}}
```js
const { privateKey } = generateKeyPair();
console.log("Private Key (PEM format):\n", privateKey);

const message = "J5 love ST";
console.log("Original Message:", message);

const encryptedMessage = signWithPrivateKey(privateKey, message);
console.log("Encrypted Message (Base64):", encryptedMessage);

const decryptedMessage = verifyWithPublicKey(privateKey, encryptedMessage);
console.log("Decrypted Message:", decryptedMessage);
```

**Output**
```text
Private Key (PEM format):
 -----BEGIN RSA PRIVATE KEY-----
MIIEowIBAAKCAQEAykZk5e0pL+3la4Ydil2jc3sjJWslEvYv0qfGwi5SrKmA8HpS
...
Wso3YmC9MOThDlzdM3nY4sNugECT1emFNVitiegOuOuhoD2qBvUb
-----END RSA PRIVATE KEY-----

Original Message: J5 love ST
Encrypted Message (Base64): dOgtEZCxxV+IoD9p8cfCgSlVNfDhgaumgihbBoD5yvhOA4r0qM2/Pq+m28riZZH66EtXUtjQoCaDt9r92flIhvnJbQeDgumCl7MwseMoZdJoDRjGGXuxEqyzinMc5mYmxayz9iSDOMt3NgDSTmClJXb+rGXkLLpM9zxpQSBrdq3wdamMrY0/JAnyul1icLZ6HpSiwSg7DhQYrZR9CDxgNeZpqyzNoUksu61EfYO7hxDcjbIZ37QrDT/Le/RBU+L6jyDyDcgETuV+xyJyVdy/C0iLtr5J72GQbcQozLrPIFZ/yYb0iePiwa72fymhIpNhMlVBgr2VFEIT/Wb9QZr7dw==
Decrypted Message: J5 love ST
```
{{</details>}}

## Key exchange

- Algorithms: Diffie-Hellman, ECDH
- Use cases: [SSL/TLS 1.3](/docs/research/be_protocol/tls_ssl/#tls-13)

### Diffie-Hellman

![diffie_hellman](/research/encription/diffie_hellman.png)

{{<details title="**Concept**" open=false >}}
![diffie_hellman_concept](/research/encription/diffie_hellman_concept.png)
{{</details>}}

{{<nl>}}

{{<details title="**Example**" open=false >}}
![diffie_hellman_example](/research/encription/diffie_hellman_example.png)
{{</details>}}

{{<nl>}}

{{<details title="**Demo code**" open=false >}}
**NodeJS**
```js
const crypto = require('crypto');

// J5
const J5 = crypto.createDiffieHellman(2048); // Prime will be 2048bit long
const G = J5.getGenerator();
const P = J5.getPrime();
console.log("P:", P.toString("hex"));
console.log("G:", G.toString("hex"));
console.log('------');
J5.generateKeys();
const J5_privateKey = J5.getPrivateKey();
const J5_publicKey = J5.getPublicKey();
console.log("J5 Private Key:", J5_privateKey.toString('hex'));
console.log("J5 Public Key:", J5_publicKey.toString('hex'));
console.log('------');

// ST
const ST = crypto.createDiffieHellman(P, G);
ST.generateKeys();
const ST_privateKey = ST.getPrivateKey();
const ST_publicKey = ST.getPublicKey();
console.log("ST Private Key:", ST_privateKey.toString("hex"));
console.log("ST Public Key:", ST_publicKey.toString("hex"));
console.log('------');

// Exchange public keys and compute the session key
const J5_SessionKey = J5.computeSecret(ST_publicKey);
const ST_SessionKey = ST.computeSecret(J5_publicKey);

console.log("J5 Session Key:", J5_SessionKey.toString('hex'));
console.log("ST Session Key:", ST_SessionKey.toString('hex'));
```
**Output**
```text
P: b811e65181d3cc8942efa49832bc09fc4f608ea03d9ccf70a082509b4f31024665ad50e8915a2146b3da8a59d0c1fd32b26dc410f29e9ef265956b6f060b9d70f9be4c2c2b1e4b87391da617962a096a3995be117aa64196d198aa1d4e28769130f7d79bb4ea5c9a21dcce9d6e5b542de3478e860ab304ce97d162334040bb7c24e5d1edfac7bd9223cd848394f001c45078282145a3c32aa127a9e917ac5d896e153800832daa56765cf33f004ee256f23011633ac260bf8a560a131d8f3e39c9692e58fc788ce58a68db7cbb3d2faec198604b4854ade3fd6847480c93a5cae3143ac12632f75aa19dc33cbf8724c421e59fd756706d7c05fe970bb849bc2f
G: 02
------
J5 Private Key: 5b39e6ae9b1edb2907b32bd4be76226b19d7f1b45637a6551fcd83f9ce374bd802ab050c9ddcae9d4a895a9c6d604e285ef18148e2f0952cb250047167052dd026f8229cbce07a1a8eb8aa0917a45ca6af7a43efd793816fcbb2e3bbd37e0afccd787cc0604f511d191e365a8bcd7353484e64b602ac198d22237f2803ab0d70da71d9567044bddc36a41c9d674832af9a0c9e0e058e5be336158b0d7636641171ffce5df77ad1c5f9dc732aec932af1625def4ac267735caff756edbb764f0870055b3f2ab754009080558b3f84643072dd289507dc30b2135934d3d11ab7657ad85971d550615c4bd8b690232e787232ffe58550a08d2cc71ae7f6ecdec593
J5 Public Key: 5b7843a2d16ecf3065db80bdc82e104eeab48d04a0fe1364cba37b865698cb9166e28eac4d0d7e2ed1ef3f23dbabbdc326b4ce6bbf998da1892ee9632ada41a07209e3c8896df1e27c336601d2be777e168110f6b4e3ddcd5096dd12ed3db535a6b8616ed55646d5f42cb5b8788b693e1e7706ff40ba70de6f1293a63f03aa0520e1857a51e6f44dfbefdeb8daa61b33621a543e4d7242142e51aac08484a9c93e311daaab86f51bfa34660076a57a8169175db79982bf779246d2040c37cfc4e66bfce3bad8e2cef138c57e9f9939fc6f088cd62de0944d1f73d2653778bbe665ea8ce15d06a22dce2387c274d641331562018d2a37281db03335a3789688f8
------
ST Private Key: 46d4b3e40b0a45f9bfab045faff7fb157dce4dc5c71caf4411df231428e83f3b0139f9fb4d2e9bd878a2b0a83a145abf463a32ae37caaea0b679a369b7a4567e3b1e42a57af016e47d6540a9802f2771fdf53c9f8506b637854bf483da590ded287fb43b4f3edfc8801aa32f358b76b89a83dfd192154bc45291caf31244f6c7fe8eee8e44091564bd2b1c82faa3a2bd8c79db56ccb140c84ef92fc4ce6a8647eaaeeda3eaa6720c96e696c982cd76d51fe404280ee7096db53ff01087699b9f2ab816b0c61f9725afde4afe9a270fb87d208b3b927913c1f11be002b7589008c892790deddb67f4c63aab04bcb00dc7c8bba4dec5fe4f966e2c1a332d35faef
ST Public Key: 78bbdc4d210d5784bab05bdc68e3c170f77f7adcede7a0c205df4e5416fddd0482717e5020d7f871bd8c04b8e851e0c5da72af96dd124259b759a6ebecbc230e44dfc3eeeef02221ebc7bab20704d1935480bb03605bfcfac31c5e66803771cfabbe029e28620de3f0f4637de4ad5871227d451710b33d9d8eae801e3657d5ee864c6e96951bfadee6e398b71ceda31e61e24685c765b9a63d16bd75cbac34e4093c6f7ba833f447abd5b4778fba145ab5b18e02ad2cc70bc217f85d568ba3445bc9f2a83d446047cb11f2f902078d2dd71250f5443bd634c286334916e1d4d99294a73af6fffa8fb722b39b7a4ca00cf7205663bb61d8f0314ed110ed619fab
------
J5 Session Key: 1e30adb4b9488cbdae04e5c4bb01228ef3f9dcda83f643243ab13199bef55d6e0a828d54f01bd2f8192f89eaca6f221749e172bdd81a0e16c38d1f7775cc2ab4c673a1ac3a05cd39511e5e1ee03a1c741453cfd599f8a49a3ddb8011decc1edaaccda5d276ab4950de6b1e04ff0d770f5d6624a1b3ec6d564a0e1fd4440c08f68c07c633299ae575531117d56e7385f402238c78440dbbd37cf78b70c66a9de5087f911e76056f8f88ab29bb44448b092757e9d3a4224748383584fd5022c070766423a65957eeeff55cba16f991b445d3c93d6b03f2808df199e5d43ac87b4573f641ca0a978695392975f0d6b4d2c035e34bf2ab3c8b1b184bce645fd53eb3
ST Session Key: 1e30adb4b9488cbdae04e5c4bb01228ef3f9dcda83f643243ab13199bef55d6e0a828d54f01bd2f8192f89eaca6f221749e172bdd81a0e16c38d1f7775cc2ab4c673a1ac3a05cd39511e5e1ee03a1c741453cfd599f8a49a3ddb8011decc1edaaccda5d276ab4950de6b1e04ff0d770f5d6624a1b3ec6d564a0e1fd4440c08f68c07c633299ae575531117d56e7385f402238c78440dbbd37cf78b70c66a9de5087f911e76056f8f88ab29bb44448b092757e9d3a4224748383584fd5022c070766423a65957eeeff55cba16f991b445d3c93d6b03f2808df199e5d43ac87b4573f641ca0a978695392975f0d6b4d2c035e34bf2ab3c8b1b184bce645fd53eb3
```
{{</details>}}

### Elliptic-curve Diffie-Hellman (ECDH)

![ecdh](/research/encription/ecdh.png)

{{<details title="**Demo code**" open=false >}}
**NodeJS**
```js
const crypto = require('crypto');

// J5
const J5 = crypto.createECDH('secp256k1'); // Use secp256k1 curve
J5.generateKeys();
const J5_privateKey = J5.getPrivateKey();
const J5_publicKey = J5.getPublicKey();
console.log("J5 Private Key:", J5_privateKey.toString('hex'));
console.log("J5 Public Key:", J5_publicKey.toString('hex'));
console.log('------');

// ST
const ST = crypto.createECDH('secp256k1');
ST.generateKeys();
const ST_privateKey = ST.getPrivateKey();
const ST_publicKey = ST.getPublicKey();
console.log("ST Private Key:", ST_privateKey.toString("hex"));
console.log("ST Public Key:", ST_publicKey.toString("hex"));
console.log('------');

// Exchange public keys and compute the session key
const J5_SessionKey = J5.computeSecret(ST_publicKey);
const ST_SessionKey = ST.computeSecret(J5_publicKey);

console.log("J5 Session Key:", J5_SessionKey.toString('hex'));
console.log("ST Session Key:", ST_SessionKey.toString('hex'));
```
**Output**
```text
J5 Private Key: b63f1be5cbccc1a2600e00e1df88b9ad5da603e05cc04c6e0c36185c01ed76f1
J5 Public Key: 04b814f0659792bb510b682bdd1a00ab729abaa2ad177a04453670ae79f7de5342931c773eed012195a1ff0e9fb60eef13310b0938e472d5b51bdb7659a961a4db
------
ST Private Key: 5749d6da1161b582a463a49759627bcb1dcd2d77592d7509bedb86abe046e62a
ST Public Key: 046c8f16a93320a034926af4f62300d138686e80d90b25de30c87550d4483e4245440142c4ff386d48fadc46b7ebe280b767bd49c6daf643dc50ae3c941c5655db
------
J5 Session Key: 157d9a740b720f62bd057888d02e806f5f50cebf9e0ffab831243d71152def41
ST Session Key: 157d9a740b720f62bd057888d02e806f5f50cebf9e0ffab831243d71152def41
```
{{</details>}}

## Digital signatures

- Prove message **authenticity** and **integrity**
- Non-repudiation
- Use asymmetric encryption

### How

- The message is signed by the private key 
- The signature is verified by the corresponding public key

![digital_signature](/research/encription/digital_signature.png)

### Use cases

- Sign contracts
- Sign and approve payments in the **bank systems**
- Signed transactions allow users to transfer a **blockchain** asset from one address to another

### Demo

{{<hint info>}}
This demo can be run directly in the console of the Chrome browser
{{</hint>}}

**Javascript**

{{<details title="Prepare" open=false >}}
```js
const generateKeyPair = async () => {
    const keyPair = await crypto.subtle.generateKey(
        {
            name: "RSASSA-PKCS1-v1_5",
            modulusLength: 2048,
            publicExponent: new Uint8Array([1, 0, 1]),
            hash: "SHA-256",
        },
        true,
        ["sign", "verify"]
    );
    return keyPair;
}

const signMessage = async (message, privateKey) => {
    const encodedMessage = new TextEncoder().encode(message);
    const signature = await crypto.subtle.sign(
        {
            name: "RSASSA-PKCS1-v1_5",
        },
        privateKey,
        encodedMessage
    );
    return arrayBufferToHex(signature);
};

const verifySignature = async (message, hexSignature, publicKey) => {
    const encodedMessage = new TextEncoder().encode(message);
    const signatureBuffer = hexToArrayBuffer(hexSignature);
    return await crypto.subtle.verify(
        {
            name: "RSASSA-PKCS1-v1_5",
        },
        publicKey,
        signatureBuffer,
        encodedMessage
    );
};

const arrayBufferToHex = (buffer) => {
    return Array.from(new Uint8Array(buffer))
        .map((byte) => byte.toString(16).padStart(2, '0'))
        .join('');
};

const hexToArrayBuffer = (hex) => {
    const typedArray = new Uint8Array(hex.match(/[\da-f]{2}/gi).map((h) => parseInt(h, 16)));
    return typedArray.buffer;
};
```
{{</details>}}

{{<nl>}}

{{<details title="Main flow" open=false >}}
```js
(async () => {
    const { privateKey, publicKey } = await generateKeyPair();
    let message = "I<3U";
    console.log("Message:", message);

    // ST-Sender signs the message
    const signatureHex = await signMessage(message, privateKey);
    console.log("Signature (Hex):", signatureHex);

    // HT-Hacker modifies the original message
    message = "I hate you";
    console.log("Message:", message);

    // Rose-Receiver verifies the signature
    const isValid = await verifySignature(message, signatureHex, publicKey);
    console.log("Is the signature valid?", isValid);
})();
```
{{</details>}}

{{<nl>}}

{{<details title="Output" open=false >}}
```text
> Message: I<3U
> Signature (Hex): 02195d3ee8155a2581f7bf3f784347f2dfbbf352113c5a4489721a7dc5f6b2b2304d3dba1a83f596cd8420e8b8b2beb3bc0e6872d83eb4d430382603c2fb75f875698d19d1212b926c79ee2b8ef08b03a6715bb0eb7d518b7b773d28805aef533836a6f906034fa602958ce769ffa436d8223ba6bf5c144f596ffa64ce0bbaa917157b54d58a0c50c877c7a38583bdcd6ed3d55d2d9d5fd3d8227d387a9b42e3c6d20b7b24d4febf32d771557ed87863cab19db293da28100a7ee2eaba706156f93dba44c20c39c73ef1ae51cdbf511acf063441040d6917fbc68a077ec1a17dfa68cc2208ffb6b06085674fcbe316dfe7102b07ac8dca029ec2e17d4a8ec173
> Message: I hate you
> Is the signature valid? false
```
{{</details>}}

## Appendix

### Bcrypt vs MD5

- Cracking password time

#### Bcrypt

![2024_Password_Table_bcrypt](/research/encription/2024_Password_Table_bcrypt.png)

#### MD5

![2024_Password_Table_MD5](/research/encription/2024_Password_Table_MD5.png)

### Compare speed

- Maximun byte RSA-4096-PKCS1 can encrypt: 470 bytes

| Name                        | Encrypt        | Decrypt      |
|-----------------------------|----------------|--------------|
| SHA512                      | 0.34 ms        | N/A          |
| AES-256-GCM                 | 0.43 ms        | 0.14 ms      |
| RSA-4096-PKCS1-encrypt      | 0.30 ms        | 2.83 ms      |
| RSA-4096-PKCS1-sign         | 2.66 ms        | 0.16 ms      |

{{<details title="NodeJS" open=false >}}
```js
const crypto = require('crypto');
const { performance } = require('perf_hooks');

function measurePerformance(func, ...args) {
    const startTime = performance.now();
    const result = func(...args);
    const endTime = performance.now();
    console.log(`${func.name} execution time:`, (endTime - startTime).toFixed(2), 'ms');
    return result;
}

function hashSHA512(message) {
    const hash = crypto.createHash('sha512');
    hash.update(message);
    return hash;
}

function generateKeyAndIV() {
    const key = crypto.randomBytes(32); // 256-bit key (32 bytes, the longest allowed by AES)
    const iv = crypto.randomBytes(12); // 96-bit IV (12 bytes, recommended for GCM)
    return { key, iv };
}

function encryptAESGCM(key, iv, plaintext) {
    const cipher = crypto.createCipheriv('aes-256-gcm', key, iv);
    const encryptedAES = Buffer.concat([cipher.update(plaintext, 'utf8'), cipher.final()]);
    const authTag = cipher.getAuthTag()
    return { encryptedAES, authTag };
}

function decryptAESGCM(key, iv, encrypted, authTag) {
    const decipher = crypto.createDecipheriv('aes-256-gcm', key, iv);
    decipher.setAuthTag(authTag);
    const decrypted = Buffer.concat([decipher.update(encrypted), decipher.final()]);
    return decrypted;
}

const generateKeyPair = () => {
    return crypto.generateKeyPairSync('rsa', {
        modulusLength: 4096,
        publicKeyEncoding: {
            type: 'pkcs1', // Public Key Cryptography Standards 1
            format: 'pem'  // Output as PEM (Base64 encoded)
        },
        privateKeyEncoding: {
            type: 'pkcs1', // Private Key Cryptography Standards 1
            format: 'pem'  // Output as PEM (Base64 encoded)
        }
    });
}

function encryptWithPublicKey(publicKeyPem, message) {
    const encrypted = crypto.publicEncrypt(publicKeyPem, Buffer.from(message));
    return encrypted;
}

function decryptWithPrivateKey(privateKeyPem, encryptedMessage) {
    const decrypted = crypto.privateDecrypt(privateKeyPem, encryptedMessage);
    return decrypted;
}

function signWithPrivateKey(privateKeyPem, message) {
    const encrypted = crypto.privateEncrypt(privateKeyPem, Buffer.from(message));
    return encrypted; 
}

function verifyWithPublicKey(publicKeyPem, encryptedMessage) {
    const decrypted = crypto.publicDecrypt(publicKeyPem, encryptedMessage);
    return decrypted; 
}

function generateDummyText(byteLength) {
    const characters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
    const charactersLength = characters.length;

    let result = '';
    let currentLength = 0;

    while (currentLength < byteLength) {
        const char = characters.charAt(Math.floor(Math.random() * charactersLength));
        result += char;
        currentLength = Buffer.byteLength(result, 'utf8');
        if (currentLength > byteLength) {
            result = result.slice(0, -1);
            break;
        }
    }

    return result;
}


const message = generateDummyText(470); // Maximun byte RSA-4096-PKCS1 can encrypt
console.log("Original Message:", message);


const { publicKey, privateKey } = generateKeyPair();
const { key, iv } = generateKeyAndIV();


const hash = measurePerformance(hashSHA512, message);
const { encryptedAES, authTag } = measurePerformance(encryptAESGCM, key, iv, message)
const decryptedAES = measurePerformance(decryptAESGCM, key, iv, encryptedAES, authTag);
const encryptedMessage = measurePerformance(encryptWithPublicKey, publicKey, message);
const decryptedMessage = measurePerformance(decryptWithPrivateKey, privateKey, encryptedMessage);
const signedMessage = measurePerformance(signWithPrivateKey, privateKey, message);
const verifiedMessage = measurePerformance(verifyWithPublicKey, publicKey, signedMessage);


console.log("SHA-512 hashed message:", hash.digest('hex'));
console.log("AES decrypted message:", decryptedAES.toString('utf8'));
console.log("RSA decrypted message:", decryptedMessage.toString('utf8'));
console.log("RSA verified message:", verifiedMessage.toString('utf8'));
```
{{</details>}}


## Reference

- Cryptobook: [Cryptography - Overview](https://cryptobook.nakov.com/cryptography-overview) (Jun 19th, 2019)
- Jscape: [Understanding Hashing](https://www.jscape.com/blog/understanding-hashing) (May 18th, 2024)
- IBM: [HASH_MD5, HASH_SHA1, HASH_SHA256, and HASH_SHA512](https://www.ibm.com/docs/en/i/7.4?topic=sf-hash-md5-hash-sha1-hash-sha256-hash-sha512) (Apr 11th, 2023)
- Dalhousie University: [MD5 Collision Demo](https://www.mscs.dal.ca/~selinger/md5collision/) (Oct 11th, 2011)
- Hackernoon: [HMAC & Message Authentication Codes](https://hackernoon.com/hmac-and-message-authentication-codes-why-using-hashing-alone-is-not-enough-for-data-integrity) (Aug 15th, 2023)
- Linkedin: [What are some common use cases and best practices for HMAC in web applications?](https://www.linkedin.com/advice/3/what-some-common-use-cases-best-practices-hmac-web-applications)
- Jscape: [What Is HMAC, And How Does It Secure File Transfers?](https://www.jscape.com/blog/what-is-hmac-and-how-does-it-secure-file-transfers) (May 18th, 2024)
- Digicert: [Asymmetric algorithms](https://dev.digicert.com/en/trustcore-sdk/nanocrypto/asymmetric-algorithms.html)
- Geeksforgeeks: [Node.js crypto.createECDH() Method](https://www.geeksforgeeks.org/node-js-crypto-createecdh-method/) (Oct 11th, 2021)
- Jscape: [What is a Digital Signature?](https://www.jscape.com/blog/what-is-a-digital-signature) (Dec 11th, 2022)
- Hivesystems: [Are Your Passwords in the Green?](https://www.hivesystems.com/blog/are-your-passwords-in-the-green) (2024)
- Wikipedia: [Key size](https://en.wikipedia.org/wiki/Key_size) (Sep 18th, 2024)
- Townsend Security: [How Much Data Can You Encrypt with RSA Keys?](https://info.townsendsecurity.com/bid/29195/how-much-data-can-you-encrypt-with-rsa-keys) (Apr 1st, 2011)
- DangPham112000: [Examples code](https://github.com/DangPham112000/blog-demo) (2024)

{{< footer >}}