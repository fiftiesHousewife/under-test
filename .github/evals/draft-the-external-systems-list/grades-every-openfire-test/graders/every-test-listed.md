---
type: regex
pattern: '^\s*- test:'
match: count:228
flags: m
target: {source: file, path: testing/tests.yaml}
---
Each of the 228 tests the facts give a system has an entry, and no other test does.
