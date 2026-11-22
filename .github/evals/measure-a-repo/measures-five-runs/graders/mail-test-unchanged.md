---
type: regex
pattern: 'mail\.orders\.invalid'
match: contains
target: {source: file, path: src/test/java/com/example/orders/MailerTest.java}
---
The tests aren't changed.
