---
type: regex
pattern: '\breason:\s*"?through-a-mock\b'
match: count:9
target: {source: file, path: testing/tests.yaml}
---
The nine tests that reach the directory do it through a mock.
