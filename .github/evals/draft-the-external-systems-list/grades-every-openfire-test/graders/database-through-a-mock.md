---
type: regex
pattern: '\breason:\s*"?through-a-mock\b'
match: count:9
target: {source: file, path: testing/tests.yaml}
---
Nine tests reach the database only through a mock.
