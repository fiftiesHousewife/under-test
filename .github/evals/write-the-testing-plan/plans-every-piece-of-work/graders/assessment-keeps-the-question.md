---
type: regex
pattern: '^  questions/refund-rounding:\n    state: proposed\n    drafted_by: ai\n    question: Partial refunds round down to the penny today, but the policy says round\n      to nearest\. Keep today.s behaviour or fix it\?$'
flags: m
match: contains
target: {source: file, path: testing/assessment.yaml}
---
The assessment file keeps the open question, unchanged and unanswered.
