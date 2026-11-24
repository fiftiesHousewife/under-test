---
type: regex
pattern: 'LegacyRepositoryTest\.java:16["'']{1}(?:(?!\n[ \t]*- test:)[\s\S])*?never-runs'
match: not_contains
target: {source: file, path: testing/tests.yaml}
---
LegacyRepositoryTest extends Spring's JUnit 3 base class, so testFindsTheFirstOrder runs without @Test: it isn't never-runs.
