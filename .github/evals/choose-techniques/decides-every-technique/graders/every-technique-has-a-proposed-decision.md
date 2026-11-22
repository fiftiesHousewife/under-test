---
type: regex
pattern: '^[ \t]*["'']?techniques/(?:ai-written-tests|architecture-rules|automatic-test-generation|batch-file-in-file-out|business-rule-tests|characterisation-tests|contract-testing|database-unit-tests|differential-testing|embedded-jakarta-ee-tests|fake-behind-an-interface|feature-flags|machine-state-checks|mutation-testing|post-release-checks|property-based-testing|recorded-http-responses|refactoring-for-testability|server-rendered-ui-tests|stand-in-commands|structured-output-comparison|testcontainers|traffic-record-and-replay)["'']?:[ \t]*\n(?:(?![ \t]*["'']?[a-z-]+/[a-z0-9-]+["'']?:)(?:[ \t]+[^\n]*)?\n)*?[ \t]+state:[ \t]*["'']?proposed["'']?[ \t]*$'
flags: m
match: count:23
target: {source: file, path: testing/assessment.yaml}
---
Each of the 23 techniques has a decision `techniques/<id>` with `state: proposed`. Decision keys are unique in the YAML map, so 23 matches over the 23 named ids means every technique is there once.
