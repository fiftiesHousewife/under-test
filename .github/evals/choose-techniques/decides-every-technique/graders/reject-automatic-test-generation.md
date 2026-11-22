---
type: regex
pattern: '^[ \t]*["'']?techniques/automatic-test-generation["'']?:[ \t]*\n(?:(?![ \t]*["'']?[a-z-]+/[a-z0-9-]+["'']?:)(?:[ \t]+[^\n]*)?\n)*?[ \t]+choice:[ \t]*["'']?reject["'']?[ \t]*$'
flags: m
match: contains
target: {source: file, path: testing/assessment.yaml}
---
The decision `techniques/automatic-test-generation` proposes reject. `reject_or_defer_when` 'Framework-heavy code (Spring contexts)' is true and won't change: a Spring Boot service with Spring Data JPA.
