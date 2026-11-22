---
type: regex
pattern: 'id: "?database-dump-file-backup"?\s*$'
flags: m
match: count:1
target: {source: file, path: testing/assessment.yaml}
---
The finding `database-dump-file-backup` is there once, with the id the skill's rule gives (rule id, then the file name without its extension).
