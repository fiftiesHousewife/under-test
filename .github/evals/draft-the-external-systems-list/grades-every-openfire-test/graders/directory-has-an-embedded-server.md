---
type: regex
pattern: '\breason:\s*"?embedded-server\b'
match: count:9
target: {source: file, path: testing/tests.yaml}
---
The nine tests that reach the directory start an embedded LDAP server, so they cannot reach the real one.
