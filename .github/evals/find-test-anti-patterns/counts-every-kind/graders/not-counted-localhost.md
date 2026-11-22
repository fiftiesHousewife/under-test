---
type: regex
pattern: '^[ \t]*(?:- )?id: ["'']?reaches-shared-system["'']?[ \t]*\n(?:[ \t]+(?:[^-\s]|- ["''])[^\n]*\n)*?[ \t]+(?:[^-\s]|- ["''])[^\n]*PaymentClientTest'
flags: m
match: not_contains
target: {source: file, path: testing/assessment.yaml}
---
PaymentClientTest calls http://localhost:8089, which the rule leaves out, so the reaches-shared-system finding does not cite it. (It may still appear as an `other` finding: a test needing a server nothing starts.)
