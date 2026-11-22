---
type: regex
pattern: '^(?=[\s\S]*^[ \t]+count:[ \t]*212[ \t]*$)(?=[\s\S]*^[ \t]+flaky:[ \t]*7[ \t]*$)(?=[\s\S]*^[ \t]+line_coverage:[ \t]*61[ \t]*$)(?=[\s\S]*^[ \t]+caught:[ \t]*23[ \t]*$)'
flags: m
match: contains
target: {source: file, path: testing/assessment.yaml}
---
The measured test results are unchanged: 212 tests, 7 flaky, 61% line coverage, 23 planted bugs caught.
