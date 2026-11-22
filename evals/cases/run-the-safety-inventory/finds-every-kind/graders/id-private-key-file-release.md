---
type: regex
pattern: 'id: "?private-key-file-release"?\s*$'
flags: m
match: count:1
target: {source: file, path: testing/assessment.yaml}
---
The finding `private-key-file-release` is there once, with the id the skill's rule gives (rule id, then the file name without its extension).
