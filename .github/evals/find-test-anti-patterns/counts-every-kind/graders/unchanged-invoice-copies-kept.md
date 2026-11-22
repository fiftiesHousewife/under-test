---
type: regex
pattern: 'assertEquals\(3, invoice\.getLines\(\)\.size\(\) \+ 1\);'
match: count:2
target: {source: file, path: src/test/java/com/example/orders/InvoiceTest.java}
---
Both copy-pasted invoice tests are still there, bent assertion and all: no test is changed or merged.
