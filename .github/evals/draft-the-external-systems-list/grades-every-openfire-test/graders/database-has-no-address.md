---
type: regex
pattern: '\breason:\s*"?no-address-for-tests\b'
match: count:228
target: {source: file, path: testing/tests.yaml}
---
The database has no address in the tests' settings, so each of its 228 entries cannot reach it.
