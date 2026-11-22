---
type: regex
pattern: '^\| 4 \|[^\n]*None adopted'
flags: m
match: contains
target: {source: file, path: testing/TESTING-PLAN.md}
---
No adopted technique gives level 4 evidence: mutation testing is deferred.
