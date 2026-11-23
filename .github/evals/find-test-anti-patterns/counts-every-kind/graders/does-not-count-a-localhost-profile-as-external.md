---
type: regex
pattern: 'QuoteServiceTest\.java:20["'']{1}(?:(?!\n[ \t]*- test:)[\s\S])*?reaches-external-system'
match: not_contains
target: {source: file, path: testing/tests.yaml}
---
QuoteServiceTest's active test profile points its service at localhost, so it doesn't reach an external system. It may be listed as other-server-nothing-starts, since nothing in the test starts a server on localhost:9090.
