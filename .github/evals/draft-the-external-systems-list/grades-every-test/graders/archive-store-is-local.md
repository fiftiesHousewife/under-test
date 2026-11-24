---
type: regex
pattern: 'com\.example\.orders\.ArchiveStoreTest'
match: not_contains
target: {source: file, path: testing/tests.yaml}
---
The in-memory database stays on the machine, so it is no system and the test that uses it gets no entry.
