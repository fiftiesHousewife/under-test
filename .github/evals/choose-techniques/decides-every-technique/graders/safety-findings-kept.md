---
type: regex
pattern: '^[ \t]*- id:[ \t]*["'']?(?:db-password|payments-keystore|reminder-job|flyway-at-start|publish-on-build|invoice-share|fixture-customers)["'']?[ \t]*$'
flags: m
match: count:7
target: {source: file, path: testing/assessment.yaml}
---
The seven safety findings are kept, once each.
