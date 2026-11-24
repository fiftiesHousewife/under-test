---
type: regex
pattern: 'test: "com\.example\.orders\.RatesClientTest\.readsARate"(?:(?!- test:)[\s\S])*?grade: "?may-reach"?\s*\n\s*reason: "?run-time"?'
match: contains
target: {source: file, path: testing/tests.yaml}
---
The rates address comes from a system property, so only measurement can tell.
