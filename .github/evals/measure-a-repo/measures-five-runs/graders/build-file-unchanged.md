---
type: regex
pattern: 'jacoco|pitest|info\.solidsoft'
match: not_contains
target: {source: file, path: build.gradle}
---
The repo's build file isn't changed: the tools come from init scripts.
