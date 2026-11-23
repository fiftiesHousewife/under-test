---
type: regex
pattern: 'ReportClientTest\.java:18["'']{1}(?:(?!\n[ \t]*- test:)[\s\S])*?host:[ \t]*["'']?reports\.corp'
match: count:1
target: {source: file, path: testing/tests.yaml}
---
The list of tests has ReportClientTest.java:18 reaching reports.corp, the default of a placeholder no properties file sets.
