---
type: regex
pattern: '^(?=[\s\S]*^[ \t]*["'']?safety/db-password["'']?:[ \t]*$)(?=[\s\S]*^[ \t]*["'']?safety/reminder-job["'']?:[ \t]*$)(?=[\s\S]*^[ \t]*["'']?anti-patterns/disabled["'']?:[ \t]*$)(?=[\s\S]*^[ \t]*["'']?level/target["'']?:[ \t]*$)(?=[\s\S]*^[ \t]*["'']?questions/refund-rounding["'']?:[ \t]*$)'
flags: m
match: contains
target: {source: file, path: testing/assessment.yaml}
---
The five decisions that were there before are still there.
