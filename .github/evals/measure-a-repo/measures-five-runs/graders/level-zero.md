---
type: regex
pattern: '\breached: 0(\s*$|\s*,|\s*\})'
flags: m
match: contains
target: {source: file, path: testing/assessment.yaml}
---
It builds; level 1 needs a CI runner with no route out, so a run on a developer's machine shows 0.
