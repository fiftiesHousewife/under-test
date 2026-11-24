---
type: regex
pattern: '"approach"\s*:\s*"not-chosen"'
match: count:1
target: {source: file, path: testing/external-systems.calm.json}
---
The UDP metrics collector fits none of the rule's cases, so it alone gets `not-chosen`. With the counts of the other two approaches, this means a stand-in is proposed for every connection.
