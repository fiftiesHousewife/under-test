---
type: regex
pattern: '^\s*- id: ["'']?scheduled-job-orderreminderjob["'']?\s*$'
flags: m
match: count:1
target: {source: file, path: testing/assessment.yaml}
---
The earlier safety finding is still there, once.
