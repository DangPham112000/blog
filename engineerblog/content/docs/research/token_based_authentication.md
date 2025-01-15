---
title: "Token-based Authentication"
weight: 60
date: 2025-01-03T01:47:46+07:00
---

# Token-based authentication

- **Senario**: Each time a user accesses your website containing **sensitive** resources, such as posting a new blog, they are required to log in **repeatedly** every time they visit
- **Problem**: Is there a way to allow them to log in just **once** and avoid re-logging in, even if their previous session was two days ago?
- **Solution**: Access tokens were designed to solve this problem

## Access token

- Provide a one-time login for users
- Reduce database access for password verification, user information retrieval, and role checking

### Characteristics

- Short-lived
- Stored in client-side storage
- Contains the user's identity
- Contains a set of claims, permissions, or roles of the user
- **Grants access to the system**

#### New problems

- **Problem 1**: When a hacker successfully steals an access token, they can impersonate the user
- **Solution 1**: Use short-term access tokens to minimize the risk of misuse if a hacker steals one
- **Problem 2**: Requiring users to re-login every time an access token is granted leads to a poor user experience
- **Solution 2**: Refresh tokens were introduced to address this issue by allowing the generation of new access tokens without requiring the user to log in again

## Refresh token

- To prevent hackers from stealing access tokens, access tokens were designed to be valid for a short duration
- Refresh tokens were introduced to re-grant access tokens when they expire, allowing users to continue their sessions seamlessly without re-login while reducing the risk of impersonation.

### Characteristics

- Long-lived 
- Stored on the server and the client
- **Used to obtain a new pair of access and refresh tokens**

## How do they work together? 

### Basic flow

![basic_flow](/research/token_based_authentication/basic_flow.png)

- You may be curious why using separate keys for creating and verifying tokens (see [this use case](#authentication-server-standalone-concept))

### Token expired

![token_expired](/research/token_based_authentication/token_expired.png)

### Threat mitigation strategy

- Each refresh token (RT) can only be used once
- If a reused RT is detected, we must immediately clear all tokens and their associated keys, then force the user to re-login to the system

![threat_mitigation](/research/token_based_authentication/threat_mitigation.png)

{{<details title="Why does this only mitigate the hacking and not prevent it?" open=false >}}
- In the picture above, if you switch the positions of the hacker and the user, you'll see that if the hacker comes first, they will be granted a new AT and RT, and can access resources as many times as they want until the second token renewal process occurs, forcing them to re-login
{{</details>}}

### Authentication server standalone concept

- This explains why you should use a key pair to create and verify tokens separately, instead of using a single key for both actions

![authen_server_standalone](/research/token_based_authentication/authen_server_standalone.png)

## Demo code

- This code is intended to give you insight into implementing token-based authentication; it is not my full authentication implementation
- You can find my complete code implementation on [GitHub](https://github.com/DangPham112000/fakebut)

**NodeJS**

{{<details title="authUtils.js" open=false >}}
```js
import jwt from "jsonwebtoken";
import crypto from "crypto";

export const genKeyPairRSA = () => {
	try {
		const { privateKey, publicKey } = crypto.generateKeyPairSync("rsa", {
			modulusLength: 4096,
			publicKeyEncoding: {
				type: "pkcs1",
				format: "pem",
			},
			privateKeyEncoding: {
				type: "pkcs1",
				format: "pem",
			},
		});
		return { privateKey, publicKey };
	} catch (error) {
		throw new Error("crypto.generateKeyPairSync got error");
	}
};

export const createTokenPair = (payload, privateKey) => {
	try {
		const accessToken = jwt.sign(payload, privateKey, {
			algorithm: "RS256",
			expiresIn: "60000", // 1min
		});
		const refreshToken = jwt.sign(payload, privateKey, {
			algorithm: "RS256",
			expiresIn: "7 days",
		});

		return { accessToken, refreshToken };
	} catch (error) {
		throw new Error("jwt.sign got error");
	}
};

export const authentication = async (req, res, next) => {
	const userId = req.headers[HEADER.CLIENT_ID];
	if (!userId) {
		throw new AuthFailureError("Invalid request");
	}

	const keyStore = await KeyTokenService.findByUserId(userId);
	if (!keyStore) {
		throw new NotFoundError("Not found any keys and token match this user");
	}

	const refreshToken = req.headers[HEADER.REFRESHTOKEN];
	if (refreshToken) {
		try {
			const decodeUser = jwt.verify(refreshToken, keyStore.publicKey);
			if (userId !== decodeUser.userId) {
				throw new AuthFailureError("Invalid userId");
			}
			req.user = decodeUser; // {userId, email}
			req.refreshToken = refreshToken;
			return next();
		} catch (error) {
			throw error;
		}
	}

	const accessToken = req.headers[HEADER.AUTHORIZATION];
	if (!accessToken) throw new AuthFailureError("Invalid request");

	try {
		const decodeUser = jwt.verify(accessToken, keyStore.publicKey);
		if (userId !== decodeUser.userId) {
			throw new AuthFailureError("Invalid userId");
		}
		req.user = decodeUser; // {userId, email}
		return next();
	} catch (error) {
		throw error;
	}
};
```
{{</details>}}

{{<nl>}}

{{<details title="access.service.js" open=false >}}

```js
import bcrypt from "bcrypt";

import KeyTokenService from "./keyToken.service.js";
import { createTokenPair, genKeyPairRSA } from "../auth/authUtils.js";


class AccessService {
	static login = async ({ email, password }) => {
		const foundUser = await findByEmail({ email });
		if (!foundUser) {
			throw new BadRequestError("User not yet registered");
		}
		const match = await bcrypt.compare(password, foundUser.password);
		if (!match) {
			throw new AuthFailureError("Authentication error");
		}

		const { privateKey, publicKey } = genKeyPairRSA();

		const { _id: userId } = foundUser;

		const tokens = createTokenPair({ userId, email }, privateKey);

		await KeyTokenService.createKeyToken({
			userId,
			publicKey,
			privateKey,
			refreshToken: tokens.refreshToken,
		});

		return {
			user: foundUser,
			tokens,
		};
	};

	static handleRefreshToken = async ({ refreshToken, user }) => {
		const { userId, email } = user;
		const keyStore = await KeyTokenService.findByUserId(userId);

		if (keyStore.refreshTokensUsed.includes(refreshToken)) {
			await KeyTokenService.removeByUserId(userId);
			throw new ForbiddenError("Something wrong happen. Pls relogin");
		}

		if (keyStore.refreshToken !== refreshToken) {
			throw new AuthFailureError("Token is deleted or never exist");
		}

		const foundUser = await findByEmail({ email });
		if (!foundUser) {
			throw new AuthFailureError("User is deleted or never exist");
		}

		const newTokens = createTokenPair(
			{ userId: foundUser._id, email },
			keyStore.privateKey
		);

		await KeyTokenService.updateRefreshToken(
			userId,
			newTokens.refreshToken,
			refreshToken
		);

		return {
			user,
			tokens: newTokens,
		};
	};
}

export default AccessService;
```
{{</details>}}

{{<nl>}}

{{<details title="access.controller.js" open=false >}}
```js
import { CREATED, SuccessResponse } from "../core/success.response.js";
import AccessService from "../services/access.service.js";

class AccessController {
	login = async (req, res, next) => {
		new SuccessResponse({
			metatdata: await AccessService.login(req.body),
		}).send(res);
	};

	handleRefreshToken = async (req, res, next) => {
		new SuccessResponse({
			message: "Update token success",
			metatdata: await AccessService.handleRefreshToken({
				refreshToken: req.refreshToken,
				user: req.user,
			}),
		}).send(res);
	};
}

export default new AccessController();
```
{{</details>}}

{{<nl>}}

{{<details title="routes.js" open=false >}}
```js
import express from "express";

import accessController from "../../controllers/access.controller.js";
import postController from "../../controllers/post.controller.js";
import { authentication } from "../../auth/authUtils.js";

const router = express.Router();

const asyncHandler = (fn) => {
	return (req, res, next) => {
		fn(req, res, next).catch(next);
	};
};

router.post("/user/login", asyncHandler(accessController.login));

// Authenticate before using restricted resources
router.use(asyncHandler(authentication));

router.post("/user/handleRefreshToken", asyncHandler(accessController.handleRefreshToken));
router.post("", asyncHandler(postController.createPost));
router.patch("/:postId", asyncHandler(postController.updatePost));
router.get("/drafts/all", asyncHandler(postController.findAllDraftsOfUser));
```
{{</details>}}

## Discussion

- **Question**: Why do we need two tokens? Can we combine them?
- **New approach**: Use short-term access tokens (AT) and store them in the database. Track the current AT list and the used AT list. If one of the current tokens is stolen by a hacker and the hacker tries to renew the token, the old token will be stored in the used AT list. When the user attempts to renew using the old token, our server can invalidate all tokens and force both the user and the hacker to re-login

{{<details title="**Problem**" open=false >}}
- **This approach has one weakness**: Access tokens are exposed more frequently to retrieve resources, increasing the potential for them to be captured and stolen
- **Conclusion**: By keeping the refresh token separate and less exposed, the chances of a hacker being able to maintain access to our resources are reduced
- **Do you think this approach have any other weaknesses?**
{{</details>}}


## Reference

- Geeksforgeeks: [Access Token vs Refresh Token: A Breakdown](https://www.geeksforgeeks.org/access-token-vs-refresh-token-a-breakdown/) (27 Sep, 2024)
- Auth0: [What Are Refresh Tokens and How to Use Them Securely](https://auth0.com/blog/refresh-tokens-what-are-they-and-when-to-use-them/#When-to-Use-Refresh-Tokens) (Oct 7th, 2021)
- Medium: [Understanding Access Tokens and Refresh Tokens](https://medium.com/@lakshyakumarsingh.2003.va/understanding-access-tokens-and-refresh-tokens-2ec4bc4f9a4f) (Mar 23, 2024)

{{< footer >}}