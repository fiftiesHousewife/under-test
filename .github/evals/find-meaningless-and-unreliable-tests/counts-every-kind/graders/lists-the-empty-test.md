---
type: regex
pattern: 'StockLevelTest\.java:9["'']{1}(?:(?!\n[ \t]*- test:)[\s\S])*?no-real-assertion'
match: count:1
target: {source: file, path: testing/tests.yaml}
---
The list of tests has StockLevelTest.java:9, whose body is empty, under no-real-assertion.
