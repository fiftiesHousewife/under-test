---
type: regex
pattern: 'test: "com\.example\.orders\.PriceClientTest\.fetchesAPrice"(?:(?!- test:)[\s\S])*?grade: "?reaches"?\s*\n\s*reason: "?host"?'
match: contains
target: {source: file, path: testing/tests.yaml}
---
The code names the price service's host, so the test reaches a real system.
