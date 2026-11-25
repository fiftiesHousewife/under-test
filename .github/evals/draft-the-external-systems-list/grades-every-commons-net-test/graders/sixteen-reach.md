---
type: regex
pattern: '\bgrade:\s*"?reaches\b'
match: count:16
target: {source: file, path: testing/tests.yaml}
---
Sixteen entries are graded reaches, all on the four tests whose servers are named in the code.
