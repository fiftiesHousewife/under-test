---
type: regex
pattern: 'public void logsOrder\(\) \{\n        service\.log\(service\.create\("customer-1", 1\)\);\n    \}'
match: contains
target: {source: file, path: src/test/java/com/example/orders/OrderServiceTest.java}
---
The test with no assertion is left as it is: no assertion added, test not deleted.
