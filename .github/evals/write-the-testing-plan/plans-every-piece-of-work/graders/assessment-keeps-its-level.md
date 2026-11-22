---
type: regex
pattern: '^level:\n  found_by:\n    tool: measurement-run\n    version: 0\.1\.0\n    commit: 1a2b3c4\n  reached: 0$'
flags: m
match: contains
target: {source: file, path: testing/assessment.yaml}
---
The assessment file keeps the level it has reached, unchanged.
