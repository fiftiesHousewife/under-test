---
type: regex
pattern: 'test: "com\.example\.orders\.OrderServiceTest\.confirmsByMail"(?:(?!- test:)[\s\S])*?grade: "?cannot-reach"?\s*\n\s*reason: "?through-a-mock"?'
match: contains
target: {source: file, path: testing/tests.yaml}
---
The notifier is a Mockito mock, so the chain to the mail server never runs.
