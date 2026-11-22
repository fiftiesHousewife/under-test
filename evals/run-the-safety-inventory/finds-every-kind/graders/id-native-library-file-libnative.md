---
type: regex
pattern: 'id: "?native-library-file-libnative"?\s*$'
flags: m
match: count:1
target: {source: file, path: testing/assessment.yaml}
---
The finding `native-library-file-libnative` is there once, with the id the skill's rule gives (rule id, then the file name without its extension).
