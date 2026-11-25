---
type: regex
pattern: '\breason:\s*"?no-address-for-tests\b'
match: count:219
target: {source: file, path: testing/tests.yaml}
---
The database has no address in the tests' settings, so its 219 entries not through a mock cannot reach it.
