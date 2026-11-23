---
type: regex
pattern: 'OrderStoreRealDbTest\.java:21["'']{1}(?:(?!\n[ \t]*- test:)[\s\S])*?orders-db\.internal'
match: count:1
target: {source: file, path: testing/tests.yaml}
---
The list of tests has OrderStoreRealDbTest.java:21, a @DataJpaTest with replace = NONE, reaching the real database orders-db.internal.
