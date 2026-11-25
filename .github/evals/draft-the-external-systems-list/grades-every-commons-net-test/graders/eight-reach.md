---
type: regex
pattern: '\bgrade:\s*"?reaches\b'
match: count:8
target: {source: file, path: testing/tests.yaml}
---
Eight entries are graded reaches, all on the four tests whose servers are named in the code.
