---
title: "Encryption - Draft"
weight: 50
date: 2023-11-15T01:47:46+07:00
---

# Encryption

- TODO: compare speed

## Hash

*Note: An 8-bit byte is represented as 2 characters, from 00 to FF, in hexadecimal*

### Collision

### Use case

- Checking file integrity

## HMAC

- HMAC stand for **H**ash-Based **M**essage **A**uthentication **C**odes

## Symmetric encryption

Uses the same key to encrypt and decrypt messages

AES, Twofish and ChaCha20

![Symmetric](/research/encription/Symmetric.png)

### Use case

- HTTPS with SSL/TLS: Session key
- Data Transmission
- Data Storage

### Demo code

This example demonstrates symmetric encryption and decryption in NodeJS using the crypto module with AES (Advanced Encryption Standard) in AES-256-CBC mode

{{<details title="Init necessary functions" open=false >}}

**NodeJS**
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
**NodeJS**
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
**NodeJS**
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
**NodeJS**
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


## Asymmetric encryption

Uses a public-key cryptosystem (like RSA or ECC) and a key-pair: encryption key and corresponding decryption key

Encryption algorithms are often combined in encryption schemes (like AES-256-CTR-HMAC-SHA-256, ChaCha20-Poly1305 or ECIES-secp256k1-AES-128-GCM)

![Asymmetric](/research/encription/Asymmetric.png)

### Demo of public key encryption and private key decryption

This example demonstrates asymmetric encryption using an RSA **public key to encrypt** and an RSA **private key to decrypt** a message in Node.js with the crypto module

{{<details title="Init necessary functions" open=false >}}
**NodeJS**
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
**NodeJS**
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
**NodeJS**
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
**NodeJS**
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

### Demo of private key encryption and public key decryption

This example demonstrates RSA encryption and decryption in a way that mimics JWT behavior, where the **private key is used to sign (encrypt)** the message, and the **public key is used to verify (decrypt)** it

{{<details title="Init necessary functions" open=false >}}
**NodeJS**
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
**NodeJS**
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
**NodeJS**
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
**NodeJS**
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
**NodeJS**
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

## Appendix

### Bcrypt cracking password time vs MD5

#### MD5

![2024_Password_Table_MD5](/research/encription/2024_Password_Table_MD5.png)

#### Bcrypt

![2024_Password_Table_bcrypt](/research/encription/2024_Password_Table_bcrypt.png)

## Reference

- Okta: [HMAC (Hash-Based Message Authentication Codes) Definition](https://www.okta.com/identity-101/hmac/) (Sep 15, 2023)
- Cryptobook: [Cryptography - Overview](https://cryptobook.nakov.com/cryptography-overview) (Jun 19, 2019)
- Hivesystems: [Are Your Passwords in the Green?](https://www.hivesystems.com/blog/are-your-passwords-in-the-green) (2024)
- DangPham112000: [Examples code](https://github.com/DangPham112000/blog-demo) (2024)
- Hackernoon: [HMAC & Message Authentication Codes](https://hackernoon.com/hmac-and-message-authentication-codes-why-using-hashing-alone-is-not-enough-for-data-integrity) (Aug 15th, 2023)