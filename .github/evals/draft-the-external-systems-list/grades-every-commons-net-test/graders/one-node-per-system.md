---
type: regex
pattern: '"node-type"'
match: count:45
target: {source: file, path: testing/external-systems.calm.json}
---
One node for each of the 44 systems in the facts, and one for the application.
