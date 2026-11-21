# Technique catalogue

One folder per testing technique. Each folder serves two readers:

| File | Reader | Purpose |
|---|---|---|
| `technique.yaml` | Tools and agents | When to adopt, defer or reject the technique; checks to run first; what to use instead. The planning tool reads these. Schema: [`schema/technique.schema.json`](../schema/technique.schema.json). |
| `README.md` | People | A lesson: what it catches, a walk-through of the example, how it fits the programme, common mistakes. |
| `example/` | People | A small runnable Gradle project (`:techniques:<id>`) with a before and an after. Runs on a developer machine with no container runtime. |
| `example-ts/` | People | A TypeScript version, where the technique applies to web UI or Node code. |

To add a lesson or example, follow [`.github/skills/write-a-technique-lesson`](../.github/skills/write-a-technique-lesson/SKILL.md). Words follow [GLOSSARY.md](../GLOSSARY.md).

| Technique | Workstream | Evidence for maturity levels | Java example | TypeScript example |
|---|---|---|---|---|
| [mutation-testing](mutation-testing/) | strengthen tests | 4 | ready | to do |
| [snapshot-testing](snapshot-testing/) | record current behaviour | 2 | to do | – |
| [ai-written-tests](ai-written-tests/) | record current behaviour | 2 | to do | – |
| [automatic-test-generation](automatic-test-generation/) | record current behaviour | 2 | to do | – |
| [recorded-http-responses](recorded-http-responses/) | make it run on its own | 1–2 | to do | to do |
| [testcontainers](testcontainers/) | make it run on its own | 1–3 | to do (container part) | – |
| [contract-testing](contract-testing/) | make it run on its own | 3 | to do | to do |
| [fake-behind-interface](fake-behind-interface/) | make it run on its own | 1–2 | to do | – |
| [traffic-record-and-replay](traffic-record-and-replay/) | make it run on its own | 1–2 | lesson only | – |
| [refactoring-for-testability](refactoring-for-testability/) | make code testable | 2–3 | to do | – |
| [feature-flags](feature-flags/) | make code testable | 5 | to do | – |
| [architecture-rules](architecture-rules/) | make code testable | 2–3 | to do | – |
| [property-based-testing](property-based-testing/) | test against requirements | 3 | to do | to do |
| [business-rule-tests](business-rule-tests/) | test against requirements | 3 | to do | to do |
| [differential-testing](differential-testing/) | check in production | 3, 5 | to do | – |
| [post-release-checks](post-release-checks/) | check in production | 5 | lesson only | – |
