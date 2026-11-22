---
type: regex
pattern: '### [0-9]+\. Check in production'
match: not_contains
target: {source: file, path: testing/TESTING-PLAN.md}
---
A workstream with no work isn't shown.
