---
title: "Token-based Authentication"
weight: 60
date: 2025-01-03T01:47:46+07:00
---

# Token-based authentication

- Provide one-time login for user
- Less access to database for password checking, user info, user role 

## Basic flow
![basic_flow](/research/token_based_authentication/basic_flow.png)

## Token expired
![token_expired](/research/token_based_authentication/token_expired.png)

## Threat mitigation strategy
![threat_mitigation](/research/token_based_authentication/threat_mitigation.png)

### Access Token

#### Pros
Do you notice some web page allow you go to a route like dashboard immediately just because you has been login before, but some other web app also have dashboard but they request you login every time you go to them

--> Bad UX

If we use AT, they do not need re-login

#### Cons

If we only use AT for authentication
So when hacker stolen AT successfully, they can impersonate the user

How about short-term AT?
- Each time we grant AT we need to force user re-login
--> Bad UX

How about combine short-term AT and store AT in DB?
Our server can grant several AT and somehow one of them be stolen by hacker, if we store current AT-list and used-AT list. Then if we renew an AT for hacker or user and then another try to renew a used AT we can clear all of them and then force user to re-login
- This approach is totally possible
--> BUT we will increase the I/O cost in DB because too much AT used to check and store

--> So we design RT

### Refresh Token

In order to prevent hacker stolen AT, we decide AT only live in a short time
So refresh token born as a factor to re-grant AT when they are expired and user then can be continue their session with our resource without re-login and don't worry about impersonation

#### Each RT can only be used once

Whenever we see the reused RT, we must right away clear all token and it's keys, then force user to re-login to the system

### Third party authen concept

![3rd_auth](/research/token_based_authentication/3rd_auth.png)

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
        throw error;
    }
};

export const createTokenPair = async (payload, publicKey, privateKey) => {
	try {
		const accessToken = await jwt.sign(payload, privateKey, {
			algorithm: "RS256",
			expiresIn: "2 days",
		});
		const refreshToken = await jwt.sign(payload, privateKey, {
			algorithm: "RS256",
			expiresIn: "7 days",
		});

        // Just ensure the encryption is implemented correctly
		jwt.verify(accessToken, publicKey, (err, decode) => {
			if (err) {
				console.log("error verify: ", err);
			} else {
				console.log("decode verify: ", decode);
			}
		});

		return { accessToken, refreshToken };
	} catch (error) {
		throw error;
	}
};

export const authentication = async (req, res, next) => {
	const userId = req.headers[HEADER.CLIENT_ID];
	if (!userId) throw new AuthFailureError("Invalid request");

	const keyStore = await KeyTokenService.findByUserId(userId);
	if (!keyStore) throw new NotFoundError("Not found keyStore");

	const refreshToken = req.headers[HEADER.REFRESHTOKEN];
	if (refreshToken) {
		try {
			const decodeUser = jwt.verify(refreshToken, keyStore.publicKey);
			if (userId !== decodeUser.userId) {
				throw new AuthFailureError("Invalid userId");
			}
			req.keyStore = keyStore;
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
		req.keyStore = keyStore;
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
import {
	createTokenPair,
	genKeyPairRSA,
	verifyJWT,
} from "../auth/authUtils.js";


class AccessService {
    static login = async ({ email, password }) => {
        const foundUser = await findByEmail({ email });
        if (!foundUser) throw new BadRequestError("User not yet registered");

        const match = await bcrypt.compare(password, foundUser.password);
        if (!match) throw new AuthFailureError("Authentication error");

        const { privateKey, publicKey } = genKeyPairRSA();

        const { _id: userId } = foundUser;

        const tokens = await createTokenPair(
            { userId, email }, // for token payload
            publicKey, 
            privateKey
        );

        // Store publicKey, privateKey and refreshToken with correct userId to DB
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

	static handleRefreshToken = async ({ refreshToken, user, keyStore }) => {
		const { userId, email } = user;
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

		const tokens = await createTokenPair(
			{ userId: foundUser._id, email },
			keyStore.publicKey,
			keyStore.privateKey
		);
		await keyStore.updateOne({
			$set: {
				refreshToken: tokens.refreshToken,
			},
			$addToSet: {
				refreshTokensUsed: refreshToken,
			},
		});

		return {
			user,
			tokens,
		};
	};
}

export default AccessService;
```
{{</details>}}

{{<nl>}}

{{<details title="routes.js" open=false >}}
```js
import express from "express";
import accessController from "../../controllers/access.controller.js";
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

## Reference

- : []() ()

{{< footer >}}