# Technique rules

One folder per testing technique, holding `technique.yaml`: when to adopt, defer or reject the technique, the checks to
run first, and what to use instead. The toolkit's planning tools read these files; they are checked against
[the technique schema](../schema/technique.schema.json).

The lessons that teach each technique (explanation, runnable example, exercise, video) are in
[`lessons/`](../lessons/README.md).

| Technique | Workstream | Evidence for maturity levels | Java lesson | TypeScript lesson |
|---|---|---|---|---|
| [mutation-testing](mutation-testing/technique.yaml) ([lesson](../lessons/mutation-testing/README.md)) | strengthen tests | 4 | ready | to do |
| [snapshot-testing](snapshot-testing/) | record current behaviour | 2 | to do | – |
| [ai-written-tests](ai-written-tests/) | record current behaviour | 2 | to do | – |
| [automatic-test-generation](automatic-test-generation/) | record current behaviour | 2 | to do | – |
| [recorded-http-responses](recorded-http-responses/) | make it run on its own | 1–2 | to do | to do |
| [testcontainers](testcontainers/) | make it run on its own | 1–3 | to do (container part) | – |
| [contract-testing](contract-testing/) | make it run on its own | 3 | to do | to do |
| [fake-behind-interface](fake-behind-interface/) | make it run on its own | 1–2 | to do | – |
| [stand-in-commands](stand-in-commands/) | make it run on its own | 1–2 | to do | – |
| [traffic-record-and-replay](traffic-record-and-replay/) | make it run on its own | 1–2 | lesson only | – |
| [refactoring-for-testability](refactoring-for-testability/) | make code testable | 2–3 | to do | – |
| [feature-flags](feature-flags/) | make code testable | 5 | to do | – |
| [architecture-rules](architecture-rules/) | make code testable | 2–3 | to do | – |
| [property-based-testing](property-based-testing/) | test against requirements | 3 | to do | to do |
| [business-rule-tests](business-rule-tests/) | test against requirements | 3 | to do | to do |
| [differential-testing](differential-testing/) | check in production | 3, 5 | to do | – |
| [post-release-checks](post-release-checks/) | check in production | 5 | lesson only | – |
| [characterisation-tests](characterisation-tests/) | record current behaviour | 1–2 | to do | – |
| [database-unit-tests](database-unit-tests/) | test against requirements | 2–3 | to do | – |
| [batch-file-in-file-out-tests](batch-file-in-file-out-tests/) | record current behaviour | 1–3 | to do | – |
| [embedded-jakarta-ee-tests](embedded-jakarta-ee-tests/) | make it run on its own | 1–3 | to do | – |
| [machine-state-checks](machine-state-checks/) | strengthen tests | 2 | – | – |
| [server-rendered-ui-tests](server-rendered-ui-tests/) | record current behaviour | 2–3 | to do | to do |
