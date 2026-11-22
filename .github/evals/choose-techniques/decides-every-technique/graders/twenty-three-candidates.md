---
type: regex
pattern: '^[ \t]*- id:[ \t]*["'']?(?:ai-written-tests|architecture-rules|automatic-test-generation|batch-file-in-file-out|business-rule-tests|characterisation-tests|contract-testing|database-unit-tests|differential-testing|embedded-jakarta-ee-tests|fake-behind-an-interface|feature-flags|machine-state-checks|mutation-testing|post-release-checks|property-based-testing|recorded-http-responses|refactoring-for-testability|server-rendered-ui-tests|stand-in-commands|structured-output-comparison|testcontainers|traffic-record-and-replay)["'']?[ \t]*$'
flags: m
match: count:23
target: {source: file, path: testing/assessment.yaml}
---
The techniques section has a candidate for each of the 23 techniques, once each. No other id in the file is a technique id, so these lines can only be candidates.
