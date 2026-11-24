---
type: regex
pattern: '@Ignore\("flaky on CI"\)\n    @Test\n    public void cancelsOrder\(\)'
match: contains
target: {source: file, path: src/test/java/com/example/orders/OrderServiceTest.java}
---
The disabled test is left disabled: no test is changed.
