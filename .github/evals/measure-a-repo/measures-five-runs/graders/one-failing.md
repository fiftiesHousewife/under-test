---
type: regex
pattern: '\bfailing: 1(\s*$|\s*,|\s*\})'
flags: m
match: contains
target: {source: file, path: testing/assessment.yaml}
---
The mail test fails in every run: the airgap agent refuses its mail server.
