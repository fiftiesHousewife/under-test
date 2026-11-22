---
type: regex
pattern: '^[ \t]*["'']?techniques/embedded-jakarta-ee-tests["'']?:[ \t]*\n(?:(?![ \t]*["'']?[a-z-]+/[a-z0-9-]+["'']?:)(?:[ \t]+[^\n]*)?\n)*?[ \t]+choice:[ \t]*["'']?reject["'']?[ \t]*$'
flags: m
match: contains
target: {source: file, path: testing/assessment.yaml}
---
The decision `techniques/embedded-jakarta-ee-tests` proposes reject. Every `needed_when` is known false: a Spring Boot service, with no EJB, CDI, JMS or JNDI in its build, whose 212 tests run without a deployed server.
