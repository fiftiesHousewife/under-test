---
type: regex
pattern: 'id: "?fixed-file-path-application"?\s*$'
flags: m
match: count:1
target: {source: file, path: testing/assessment.yaml}
---
The finding `fixed-file-path-application` is there once, with the id the skill's rule gives (rule id, then the file name without its extension).
