---
type: regex
pattern: '\bfound_by:\s*"?test-(code|settings)\b'
match: not_contains
target: {source: file, path: testing/tests.yaml}
---
No test gets an entry from the search of its own code: what it finds there (such as =lst.length) is no address.
