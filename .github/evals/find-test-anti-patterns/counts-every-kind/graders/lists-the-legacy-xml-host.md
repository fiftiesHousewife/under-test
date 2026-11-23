---
type: regex
pattern: 'LegacyRepositoryTest\.java:16["'']{1}(?:(?!\n[ \t]*- test:)[\s\S])*?host:[ \t]*["'']?ordersdb01\.corp(?:(?!\n[ \t]*- test:)[\s\S])*?through:[ \t]*["'']?spring-xml'
match: count:1
target: {source: file, path: testing/tests.yaml}
---
The list of tests has LegacyRepositoryTest.java:16 reaching ordersdb01.corp through the XML its Spring JUnit 3 base class loads from getConfigLocations.
