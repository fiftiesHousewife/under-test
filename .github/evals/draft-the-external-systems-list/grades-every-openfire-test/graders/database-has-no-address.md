---
type: regex
pattern: '\breason:\s*"?no-address-for-tests\b'
match: count:228
target: {source: file, path: testing/tests.yaml}
---
Neither the database nor the directory has an address in the tests' settings, so their 228 entries not through a mock (219 for the database, 9 for the directory) cannot reach them.
