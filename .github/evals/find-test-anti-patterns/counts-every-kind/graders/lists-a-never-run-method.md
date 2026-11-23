---
type: regex
pattern: 'LegacyDiscountTest\.java:20["'']{1}(?:(?!\n[ \t]*- at:)[\s\S])*?never-runs'
match: count:1
target: {source: file, path: testing/anti-pattern-tests.yaml}
---
The list of tests has LegacyDiscountTest.java:20, whose @Test is commented out, under never-runs.
