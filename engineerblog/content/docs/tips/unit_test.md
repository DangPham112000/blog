---
title: "Unit Test"
weight: 20
date: 2023-11-15T01:47:46+07:00
---

# Unit Test

{{<hint danger>}}

## Reset all _global_ variables for each unit test case

{{</hint>}}

{{<hint danger>}}

## What environment the unit test cases are running on: Browser or Nodejs?

- Because Nodejs does not have browser APIs

{{</hint>}}

## Sinon stub

### Stub a function that is called by another function in the same module

Using `this.[func_name]` when calling it in your module

### Stub an export default function

```js
import * as query from "/database/query";
const makeQueryStub = sandbox.stub(query, "default").resolves([]);
```

## Work only when running alone

**Scenario:**
{{<hint warning>}}
A unit test case only **pass** when **running alone** but **fail** when **running with other** test cases
{{</hint>}}

**Check:**

- Restore after mocking function: `sandbox.restore()` at `afterEach`
- Reset global variables inner module: create a reset function to reset all variable of module to the initial value

## Mocha - Chai - Sinon sample

```js
import sinon from "sinon";
import { function_name, callback_function_name } from "../module_name.js";

const sandbox = sinon.createSandbox();

describe("module_name", function () {
  afterEach(function () {
    sandbox.restore();
  });
  describe("function_name", function () {
    it("Should be a function", function () {
      expect(function_name).to.be.a("function");
    });
    it("Should return this value if window.screen is undefined", function () {
      sandbox.stub(window, "screen").value(undefined);
      expect(function_name()).equal("expected string");
    });
    it("should return expected object when running callback function", function (done) {
      callback_function_name(function (returnedData) {
        expect(returnedData).to.deep.equal({ name: "expected object" });
        done();
      });
    });
  });
});
```

## Jest - Sinon sample

```js
import sinon from "sinon";
import { function_name, async_function_name } from "../module_name.js";

const sandbox = sinon.createSandbox();

describe("module_name", function () {
  afterEach(function () {
    sandbox.restore();
  });
  describe("function_name", function () {
    it("Should be a function", function () {
      expect(typeof function_name).toEqual("function");
    });
    it("Should return this value if window.screen is undefined", function () {
      sandbox.stub(window, "screen").value(undefined);
      expect(function_name()).toEqual("expected string");
    });
    it("should return expected object when handling function asynchronously", async () => {
      const returnedData = await async_function_name();
      expect(returnedData).toEqual({ name: "expected object" });
    });
  });
});
```
