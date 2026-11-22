---
type: regex
pattern: 'tests-fail-every-run'
match: not_contains
target: {source: file, path: testing/assessment.yaml}
---
The measurements have no `failing` count, so that obstacle is not scored.
