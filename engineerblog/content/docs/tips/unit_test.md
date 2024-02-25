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
  - Using `Karma` to run browser's unit test
  - Using JS-DOM but it's missing a lot of browser APIs

{{</hint>}}

## Work only when running alone

**Scenario:**
{{<hint warning>}}
A unit test case only **pass** when **running alone** but **fail** when **running with other** test cases
{{</hint>}}

**Check:**

- {{<u "Restore all mocks after mocking things" >}}: `sandbox.restore()`, `jest.restoreAllMocks()`, `vi.restoreAllMocks()` and `vi.unstubAllGlobals()` at `afterEach`
- {{<u "Reset global variables inner module" >}}: create a reset function to reset all variable of module to the initial value

**Example:**

```js
// calculateThings.js
import cal1Thing from "./private/cal1Thing.js";

let cached = ""; // Global variable

export default (things) => {
  if (cached) return cached;
  let result = [];
  for (let i = 0; i < things.length; i++) {
    const calculatedThing = cal1Thing(things[i]);
    result.push(calculatedThing);
  }
  cached = result;
  return cached;
};

/* start-test-code */
export const testingOnly = {
  resetCached: () => {
    cached = "";
  },
};
/* end-test-code */
```

```js
// calculateThings.test.js
import calculateThings from "./calculateThings";
import cal1Thing from "./cal1Thing";
import { testingOnly } from "./calculateThings";

vi.mock("./cal1Thing");

describe("calculateThings", () => {
  const { resetCached } = testingOnly;
  afterEach(() => {
    vi.restoreAllMocks();
  });
  it("should work as expected", () => {
    cal1Thing.mockReturnValue("a string");
    const caledThings = calculateThings([1, 2, 3]);
    expect(caledThings).toEqual(["a string", "a string", "a string"]);
  });
  it("should return empty when empty cached and input is empty array", () => {
    resetCached(); // remember reset cached
    const caledThings = calculateThings([]);
    expect(caledThings).toEqual("");
  });
});
```

## Setup code for testing only

{{<hint info>}}
This setup will help you export function only when run test, not appear when build
{{</hint>}}

### Gulp - Rollup

```js
// rollup.bundle.js
import stripCode from "rollup-plugin-strip-code";
import {rollup} from rollup;

const stripcode = stripCode({
  start_comment: "start-test-code",
  end_comment: "end-test-code",
});

export default async () => {
  const bundle = await rollup({input: 'mainFilePath.js', plugins: [stripcode]});
  await bundle.write({
    file: 'dist/destinationName.js',
    format: 'iife',
    name: 'YourObjectName',
    sourcemap: false
  })
}
```

```js
// gulpfile.js
import rollupBundle from "./rollup.bundle.js";

const clean = () => {
    // remove all previous build files or ST like that
  },
  lint = () => {
    // run eslint warning
  };

export default () => {
  series(clean, rollupBundle, lint);
};
```

## Vite - Vitest

### Mock module

{{<hint danger>}}
When you mock a module, everything you exported in this module will be mocked and can not act like original (even if you call `vi.restoreAllMocks()`)
{{</hint>}}

**Solution:**

If your module exports alots, and you only want to mock one thing, you shoult split it into another module

**Example:**

```js
// calculateThings.js
import cal1Thing from "./private/cal1Thing.js";
export default (things) => {
  let result = [];
  for (let i = 0; i < things.length; i++) {
    const calculatedThing = cal1Thing(things[i]);
    result.push(calculatedThing);
  }
  return result;
};
```

```js
// calculateThings.test.js
import calculateThings from "./calculateThings";
import cal1Thing from "./cal1Thing";

vi.mock("./cal1Thing");

describe("calculateThings", () => {
  afterEach(() => {
    vi.restoreAllMocks();
  });
  it("should work as expected", () => {
    cal1Thing.mockReturnValue("a string");
    const caledThings = calculateThings([1, 2, 3]);
    expect(caledThings).toEqual(["a string", "a string", "a string"]);
  });
});
```

## Sinon

### Stub a function that is called by another function in the same module

Using `this.[func_name]` when calling it in your module

### Stub an export default function

```js
import * as query from "/database/query";
const makeQueryStub = sandbox.stub(query, "default").resolves([]);
```

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
