---
type: regex
pattern: '^[ \t]*["'']?techniques/(?:ai-written-tests|architecture-rules|automatic-test-generation|batch-file-in-file-out|business-rule-tests|characterisation-tests|contract-testing|database-unit-tests|differential-testing|embedded-jakarta-ee-tests|fake-behind-an-interface|feature-flags|in-memory-databases|junit-tags|machine-state-checks|mockito-well-used|mutation-testing|openapi-response-checks|post-release-checks|property-based-testing|recorded-http-responses|refactoring-for-testability|repeatable-tests|server-rendered-ui-tests|spring-tests-in-slices|stand-in-commands|structured-output-comparison|testcontainers|tests-from-cases|traffic-record-and-replay)["'']?:[ \t]*\n(?:(?![ \t]*["'']?[a-z-]+/[a-z0-9-]+["'']?:)(?:[ \t]+[^\n]*)?\n)*?[ \t]+state:[ \t]*["'']?proposed["'']?[ \t]*$'
flags: m
match: count:30
target: {source: file, path: testing/assessment.yaml}
---
Each of the 30 techniques has a decision `techniques/<id>` with `state: proposed`. Decision keys are unique in the YAML map, so 30 matches over the 30 named ids means every technique is there once.
