---
type: regex
pattern: 'InvoiceApiTest\.java:13["'']{1}(?:(?!\n[ \t]*- test:)[\s\S])*?reaches-external-system'
match: count:1
target: {source: file, path: testing/tests.yaml}
---
The list of tests has InvoiceApiTest.java:13, which inherits @SpringBootTest from AbstractIntegrationTest, as reaching an external system.
