---
type: regex
pattern: 'id: "?keystore-file-old-client"?\s*$'
flags: m
match: count:1
target: {source: file, path: testing/assessment.yaml}
---
The finding `keystore-file-old-client` is there once, with the id the skill's rule gives (rule id, then the file name without its extension).
