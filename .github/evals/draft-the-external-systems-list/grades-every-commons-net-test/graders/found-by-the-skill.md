---
type: regex
pattern: '^\s+draft-the-external-systems-list:'
match: contains
flags: m
target: {source: file, path: testing/tests.yaml}
---
The file's found_by names the skill, as the one that wrote its entries.
