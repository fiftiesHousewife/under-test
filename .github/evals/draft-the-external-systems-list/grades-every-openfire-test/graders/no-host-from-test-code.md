---
type: regex
pattern: '\bfound_by:\s*"?test-(code|settings)\b'
match: not_contains
target: {source: file, path: testing/tests.yaml}
---
No test gets an entry for a host in its own code: the addresses there are XMPP and mail addresses, namespaces, certificate names and comments, none of them an address to connect to.
