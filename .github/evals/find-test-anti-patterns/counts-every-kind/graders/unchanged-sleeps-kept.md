---
type: regex
pattern: 'Thread\.sleep\('
match: count:2
target: {source: file, path: src/test/java/com/example/orders/ReminderJobTest.java}
---
Both sleeps are still in ReminderJobTest: no test is changed.
