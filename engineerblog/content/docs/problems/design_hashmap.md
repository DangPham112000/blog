---
title: "Design HashMap"
weight: 100
date: 2024-02-12T01:47:46+07:00
---

# Design HashMap

## Overview

- Its other names: hash table, map, unordered map, dictionary

- A hash table is a data structure that you can use to store data in key-value format with direct access to its items in constant time

- The most valuable aspect of a hash table over other abstract data structures is its speed to perform insertion, deletion, and search operations. Hash tables can do them all in constant time

**Time complexity**

| Operation | Average | Worst case |
| --------- | ------- | ---------- |
| Search    | O(1)    | O(n)       |
| Insert    | O(1)    | O(n)       |
| Delete    | O(1)    | O(n)       |

**Space complexity**

| Space | O(n) | O(n) |
| ----- | ---- | ---- |

## Design requirement

Let's begin with a hash map for storing phone books

{{<img src="/problems/design_hashmap/hashmap_example.png" alt="hashmap_example" caption="Hash map for storing phone books">}}

- Not using any built-in hash map libraries
- `HashMap()` initializes the object with an empty map
- `void put(string key, string value)` inserts a (key, value) pair into the HashMap. If the key already exists in the map, update the corresponding value
- `string get(key)` returns the value to which the specified key is mapped, or empty string if this map contains no mapping for the key
- `void remove(key)` removes the key and its corresponding value if the map contains the mapping for the key

## Design hashing function

## Hash collisions

### Problem

### Solution

- Open addressing
  - Linear probing
  - Plus 3 rehash
  - Quadratic probing (failed attempts)
  - Double hashing
- Closed addresing

## Use cases

## Sets

A **set** is like a hash map except it only stores keys, without values

## Reference

- Leetcode: [Design HashMap](https://leetcode.com/problems/design-hashmap/description/?envType=daily-question)
- Interviewcake: [Hash Table](https://v8.dev/features/modules) (2018 Jun 18)
- Freecodecamp: [JavaScript Hash Table – Associative Array Hashing in JS](https://www.freecodecamp.org/news/javascript-hash-table-associative-array-hashing-in-js/)
- Wikipedia: [Hash table](https://en.wikipedia.org/wiki/Hash_table)
- Khalilstemmler: [Hash Tables | What, Why & How to Use Them](https://khalilstemmler.com/blogs/data-structures-algorithms/hash-tables/#:~:text=Why%20use%20hash%20tables%3F,them%20all%20in%20constant%20time.) (Jan 19th, 2022)
- Youtube: [Hash Tables and Hash Functions](https://www.youtube.com/watch?v=KyUTuwz_b7Q) (Mar 5th, 2017)
