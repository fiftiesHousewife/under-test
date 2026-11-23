---
type: regex
pattern: 'OrderApiTest\.java:20["'']{1}(?:(?!\n[ \t]*- test:)[\s\S])*?host:[ \t]*["'']?orders-db\.internal["'']?(?:(?!\n[ \t]*- test:)[\s\S])*?kind:[ \t]*["'']?database(?:(?!\n[ \t]*- test:)[\s\S])*?through:[ \t]*["'']?spring-boot-config'
match: count:1
target: {source: file, path: testing/tests.yaml}
---
The list of tests has OrderApiTest.java:20 reaching the database orders-db.internal through Spring Boot's settings: its test profile overrides only the mail host.
