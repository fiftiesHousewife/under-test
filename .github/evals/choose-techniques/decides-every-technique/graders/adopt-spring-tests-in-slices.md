---
type: regex
pattern: '^[ \t]*["'']?techniques/spring-tests-in-slices["'']?:[ \t]*\n(?:(?![ \t]*["'']?[a-z-]+/[a-z0-9-]+["'']?:)(?:[ \t]+[^\n]*)?\n)*?[ \t]+choice:[ \t]*["'']?adopt["'']?[ \t]*$'
flags: m
match: contains
target: {source: file, path: testing/assessment.yaml}
---
The decision `techniques/spring-tests-in-slices` proposes adopt. `needed_when` 'The application is built on Spring Boot' is true (the Spring Boot 2.3 plugin and starters in the build file), and `possible_when` 'Spring Boot 1.4 or newer, where the slice annotations exist' holds for 2.3. 'The application is about to move off Spring' isn't mentioned, so it is false.
