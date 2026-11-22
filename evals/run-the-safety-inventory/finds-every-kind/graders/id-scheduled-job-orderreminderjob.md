---
type: regex
pattern: 'id: "?scheduled-job-orderreminderjob"?\s*$'
flags: m
match: count:1
target: {source: file, path: testing/assessment.yaml}
---
The finding `scheduled-job-orderreminderjob` is there once, with the id the skill's rule gives (rule id, then the file name without its extension).
