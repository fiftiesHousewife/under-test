---
type: regex
pattern: '^[ \t]*- id:[ \t]*["'']?(?:orders-db|payments-api|smtp|no-real-assertion|disabled)["'']?[ \t]*$'
flags: m
match: count:5
target: {source: file, path: testing/assessment.yaml}
---
The three running-offline findings and the two meaningless-test findings are kept, once each.
