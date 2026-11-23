---
type: regex
pattern: 'StockLevelTest\.java:9["''](?:(?!\n[ \t]*- at:)[\s\S])*?no-real-assertion'
match: count:1
target: {source: file, path: testing/anti-pattern-tests.yaml}
---
The list of tests has StockLevelTest.java:9, whose body is empty, under no-real-assertion.
