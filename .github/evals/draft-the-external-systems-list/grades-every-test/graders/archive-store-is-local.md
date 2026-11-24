---
type: regex
pattern: 'test: "com\.example\.orders\.ArchiveStoreTest\.archives"(?:(?!- test:)[\s\S])*?grade: "?cannot-reach"?\s*\n\s*reason: "?local"?'
match: contains
target: {source: file, path: testing/tests.yaml}
---
The in-memory database stays on the machine, so the test cannot reach a real system.
