---
type: regex
pattern: 'id: "?native-library-loaded-orderreminderjob"?\s*$'
flags: m
match: count:1
target: {source: file, path: testing/assessment.yaml}
---
The finding `native-library-loaded-orderreminderjob` is there once, with the id the skill's rule gives (rule id, then the file name without its extension).
