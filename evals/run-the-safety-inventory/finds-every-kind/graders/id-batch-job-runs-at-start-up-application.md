---
type: regex
pattern: 'id: "?batch-job-runs-at-start-up-application"?\s*$'
flags: m
match: count:1
target: {source: file, path: testing/assessment.yaml}
---
The finding `batch-job-runs-at-start-up-application` is there once, with the id the skill's rule gives (rule id, then the file name without its extension).
