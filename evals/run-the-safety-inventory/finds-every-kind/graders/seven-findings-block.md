---
type: regex
pattern: 'effect: blocks'
match: count:7
target: {source: file, path: testing/assessment.yaml}
---
Exactly seven findings block the run: the two production credentials, the two sources of real personal data, the key
file and the two keystores. The rest are made harmless instead.
