---
type: regex
pattern: '"programs-started"\s*:\s*\[[^\]]*"sendmail"'
match: contains
target: {source: file, path: testing/external-systems.calm.json}
---
The program the tests start, `sendmail`, is recorded on the application's own node as a program it starts.
