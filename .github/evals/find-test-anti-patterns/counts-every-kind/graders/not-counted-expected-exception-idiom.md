---
type: regex
pattern: 'NotificationTest\.rejectsAnEmptyAddress|NotificationTest\.java:31'
match: not_contains
target: {source: file, path: testing/tests.yaml}
---
NotificationTest.rejectsAnEmptyAddress uses the try, fail, catch idiom for an expected exception: a correct test, so the list of tests leaves it out.
