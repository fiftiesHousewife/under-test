---
type: regex
pattern: 'id: "?publishing-build-task-build"?\s*$'
flags: m
match: count:1
target: {source: file, path: testing/assessment.yaml}
---
The finding `publishing-build-task-build` is there once, with the id the skill's rule gives (rule id, then the file name without its extension).
