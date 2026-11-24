---
type: regex
pattern: 'test: "com\.example\.orders\.PaymentsSmokeTest\.paysThePartner"(?:(?!- test:)[\s\S])*?grade: "?reaches"?\s*\n\s*reason: "?host"?'
match: contains
target: {source: file, path: testing/tests.yaml}
---
The test itself names the partner's host.
