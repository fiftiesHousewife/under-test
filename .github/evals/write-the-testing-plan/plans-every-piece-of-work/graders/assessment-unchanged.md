---
type: regex
pattern: '^  safety/payments-keystore:\n    state: decided\n    by: Security and Platform Owner\n    choice: test keystore only; the real one is removed and the history rewritten\n    reason: A self-signed test keystore replaces it in the test profile\.$'
flags: m
match: contains
target: {source: file, path: testing/assessment.yaml}
---
The assessment file is left as it is: the decision on the payments keystore keeps every line.
