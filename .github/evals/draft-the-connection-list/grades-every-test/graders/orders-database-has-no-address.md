---
type: regex
pattern: 'test: "com\.example\.orders\.OrderServiceTest\.countsOrders"(?:(?!- test:)[\s\S])*?grade: "?cannot-reach"?\s*\n\s*reason: "?no-address-for-tests"?'
match: contains
target: {source: file, path: testing/tests.yaml}
---
Only a placeholder gives the orders database its address, so the test cannot reach it.
