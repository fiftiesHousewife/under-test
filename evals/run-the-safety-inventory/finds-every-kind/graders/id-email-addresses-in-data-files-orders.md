---
type: regex
pattern: 'id: "?email-addresses-in-data-files-orders"?\s*$'
flags: m
match: count:1
target: {source: file, path: testing/assessment.yaml}
---
The finding `email-addresses-in-data-files-orders` is there once, with the id the skill's rule gives (rule id, then the file name without its extension).
