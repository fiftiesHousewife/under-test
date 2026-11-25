---
type: regex
pattern: '^\s*- test:'
match: count:28
flags: m
target: {source: file, path: testing/tests.yaml}
---
Each of the 28 tests the facts give a system has an entry, and no other test does.
