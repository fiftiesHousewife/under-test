---
type: regex
pattern: '\bnode:\s*"?directory-ldap-host\b'
match: count:9
target: {source: file, path: testing/tests.yaml}
---
Nine tests reach the directory whose address is the setting ldap.host.
