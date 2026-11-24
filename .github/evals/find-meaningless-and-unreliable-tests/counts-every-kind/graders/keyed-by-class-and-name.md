---
type: regex
pattern: 'test:[ \t]*["'']?com\.example\.orders\.StockLevelTest\.reservesStock["'']?[ \t]*\n[ \t]+at:[ \t]*["'']src/test/java/com/example/orders/StockLevelTest\.java:9["'']'
match: count:1
target: {source: file, path: testing/tests.yaml}
---
The list of tests names each test by its fully qualified class and method, with path:line as where it is: StockLevelTest.reservesStock at StockLevelTest.java:9.
