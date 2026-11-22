---
type: regex
pattern: 'id: "?windows-file-share-application"?\s*$'
flags: m
match: count:1
target: {source: file, path: testing/assessment.yaml}
---
The finding `windows-file-share-application` is there once, with the id the skill's rule gives (rule id, then the file name without its extension).
