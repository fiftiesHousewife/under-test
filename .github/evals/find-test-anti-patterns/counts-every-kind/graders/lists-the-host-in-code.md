---
type: regex
pattern: 'OrderRepositoryIT\.java:13["'']{1}(?:(?!\n[ \t]*- test:)[\s\S])*?host:[ \t]*["'']?orders-uat\.internal["'']?(?:(?!\n[ \t]*- test:)[\s\S])*?through:[ \t]*["'']?code'
match: count:1
target: {source: file, path: testing/tests.yaml}
---
The list of tests has OrderRepositoryIT.java:13 reaching orders-uat.internal, named in the test's own code.
