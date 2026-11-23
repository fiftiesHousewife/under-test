---
type: regex
pattern: '(?:QuoteServiceTest\.java:20|OrderMailTest\.java:20)["'']{1}(?:(?!\n[ \t]*- test:)[\s\S])*?reaches-external-system'
match: not_contains
target: {source: file, path: testing/tests.yaml}
---
QuoteServiceTest's active test profile points its service at localhost:9090, and OrderMailTest's points mail at localhost:3025 with the database in memory, so neither reaches an external system. Either may be listed as other-server-nothing-starts, since nothing in the tests starts a server on those ports.
