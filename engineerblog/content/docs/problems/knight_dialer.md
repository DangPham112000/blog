---
title: "Knight Dialer"
weight: 20
date: 2023-11-15T01:47:46+07:00
---

# Knight dialer

## Description

The chess knight has a **unique movement**, it may move two squares vertically and one square horizontally, or two squares horizontally and one square vertically (with both forming the shape of an **L**). The possible movements of chess knight are shown in this diagaram:

A chess knight can move as indicated in the chess diagram below:{{<nl>}}
![chess_table](/problems/knight_dialer/chess_table.jpg)

We have a chess knight and a phone pad as shown below, the knight **can only stand on a numeric cell** (i.e. blue cell).{{<nl>}}
![phone](/problems/knight_dialer/phone_pad.jpg)

Given an integer `n`, return how many distinct phone numbers of length `n` we can dial.

You are allowed to place the knight **on any numeric cell** initially\
and then you should perform `n - 1` jumps to dial a number of length n. All jumps should be **valid** knight jumps.

As the answer may be very large, **return the answer modulo** {{< katex >}}10^9 + 7{{< /katex >}}

**Example 1:**

> **Input**: n = 1\
> **Output**: 10\
> **Explanation**: We need to dial a number of length 1, so placing the knight over any numeric cell of the 10 cells is sufficient

**Example 2:**

> **Input**: n = 2\
> **Output**: 20\
> **Explanation**: All the valid number we can dial are [04, 06, 16, 18, 27, 29, 34, 38, 40, 43, 49, 60, 61, 67, 72, 76, 81, 83, 92, 94]

**Example 3:**

> **Input**: n = 3131\
> **Output**: 136006598\
> **Explanation**: Please take care of the mod

**Constraints**:

- `1 <= n <= 5000`

## Solution

### High level

- Có thể thấy bàn phím điện thoại khá nhỏ
- Ta có thể tận dụng các giới hạn này để giải quyết bài toán thay vì đâm đầu vào một công thức tổng quát:
  - Ở một vị trí chỉ có thể nhảy đến 1 tập giới hạn các vị trí khác
  - Số cách di chuyển ở mỗi vị trí là hằng số và có thể liệt kê được

### Low level

> Ta nên bắt đầu bằng 1 ví dụ: đẹp nhất là `n = 3`

- Ở lần đầu thì vị trí có thể là tất cả các nút
- Ở lần 2 thì cần duyệt qua từ 0 đến 9
  - vị trí 0 sẽ có thể nhảy đến 4 và
  - vị trí 1 sẽ có thể nhảy đến 8 và
  - ...
- Ở lần 3 thì
  - ta sẽ duyệt tiếp bên trong vị trí 0 ở lần 2
    - vị trí 4 sẽ có thể nhảy đến 3, 9 và 0
    - vị trí 6 sẽ có thể nhảy đến 1, 7 và 0
  - trong vị trí 1 ở lần 2
    - 8 => 1, 3
    - 6 => 1, 7, 0
  - ...

Các kết quả cần tìm

- Với n = 1, return 10
- Với n = 2,
  - 0 có thể đến 4 và 6,
  - 1 có thể đến 8 và 6
- Với n = 3,
  - 0 có thể đến 3, 9, 0, 1, 7, 0
  - 1 có thể đến 1, 3, 1, 7, 0

Kết quả là tổng sống lượng vị trí có thể đến

- Cần tạo 1 mảng chứa các vị trí khả dụng qua mỗi lần lặp n

> Có thể thấy ta có thể tạo 2 mảng

- Mảng số vị trí khả dụng kế tiếp khi ở vị trí i: `[[4, 6], [8, 6], []]`
- Mảng số cách nhảy khả dụng khi ở vị trí i: `[2, 2, ]`
  - Có thể thay thế bằng length của mỗi phần tử trong mảng 1 để giảm space consume
- Có thể thấy để dùng được mảng vị trí khả dụng thì n phải >= 2
- Vậy thì thuật toán cần tìm phải bắt đầu từ 2

{{<details title="**Code**" open=false >}}

```javascript
/**
 * @param {number} n
 * @return {number}
 */
var knightDialer = function (n) {
  const nextPlaces = [
    [4, 6],
    [6, 8],
    [7, 9],
    [4, 8],
    [0, 3, 9],
    [],
    [0, 1, 7],
    [2, 6],
    [1, 3],
    [2, 4],
  ];

  if (n === 1) return 10;

  const validPlaces = JSON.parse(JSON.stringify(nextPlaces));
  for (let time = 3; time <= n; time++) {
    for (let place = 0; place <= 9; place++) {
      const newPlaces = [];
      for (let i = 0; i < validPlaces[place].length; i++) {
        newPlaces.push(...nextPlaces[validPlaces[place][i]]);
      }
      validPlaces[place] = newPlaces;
    }
  }
  const totalWays =
    validPlaces.reduce((acc, currentArray) => acc + currentArray.length, 0) %
    (Math.pow(10, 9) + 7);
  return totalWays;
};
```

{{</details >}}

## Reference

- [Leetcode](https://leetcode.com/problems/knight-dialer)
