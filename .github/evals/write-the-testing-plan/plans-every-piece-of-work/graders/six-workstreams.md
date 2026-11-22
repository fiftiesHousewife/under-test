---
type: regex
pattern: '^### [0-9]+\. '
flags: m
match: count:6
target: {source: file, path: testing/TESTING-PLAN.md}
---
Six workstreams have work; check in production has none, so it is left out.
