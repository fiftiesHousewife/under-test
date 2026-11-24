---
type: regex
pattern: '^@Ignore\npublic class RefundTest \{'
flags: m
match: contains
target: {source: file, path: src/test/java/com/example/orders/RefundTest.java}
---
The disabled class is left disabled: no test is changed.
