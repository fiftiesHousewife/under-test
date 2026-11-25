---
type: regex
pattern: '"unique-id":\s*"directory-ldap-host"'
match: contains
target: {source: file, path: testing/external-systems.calm.json}
---
The directory, whose address is the setting ldap.host, has the id the rule gives.
