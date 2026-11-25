---
type: regex
pattern: '\bgrade:\s*"?may-reach\b'
match: count:42
target: {source: file, path: testing/tests.yaml}
---
Forty-two entries may reach, all on ListingFunctionalTest's tests.
