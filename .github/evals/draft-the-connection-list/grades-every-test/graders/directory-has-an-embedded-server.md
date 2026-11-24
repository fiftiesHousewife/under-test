---
type: regex
pattern: 'test: "com\.example\.orders\.DirectoryTest\.findsAUser"(?:(?!- test:)[\s\S])*?grade: "?cannot-reach"?\s*\n\s*reason: "?embedded-server"?'
match: contains
target: {source: file, path: testing/tests.yaml}
---
The test starts its own embedded LDAP server, a stand-in already in place.
