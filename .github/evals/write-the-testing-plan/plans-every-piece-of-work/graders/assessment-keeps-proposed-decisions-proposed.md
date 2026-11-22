---
type: regex
pattern: '^    state: proposed$'
flags: m
match: count:26
target: {source: file, path: testing/assessment.yaml}
---
No proposed decision is marked decided: approving the plan does that, not writing it.
