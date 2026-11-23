---
type: regex
pattern: '^[ \t]*- id:[ \t]*["'']?(?:orders-db|payments-api|smtp|no-real-assertion|disabled|reaches-external-system)["'']?[ \t]*$'
flags: m
match: count:6
target: {source: file, path: testing/assessment.yaml}
---
The three running-offline findings and three anti-pattern findings are kept, once each.
