---
title: "Unit Test"
weight: 20
date: 2023-11-15T01:47:46+07:00
---

# Unit Test

## Sinon stub

### stub function được gọi bởi một func khác trong cùng 1 module

Using `this.[func_name]` when calling it

### stub an export default function

```javascript
import * as query from "/database/query";
makeQueryStub = sandbox.stub(query, "default").resolves([]);
```
