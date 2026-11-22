# Technique rules

One folder per testing technique, holding `technique.yaml`: when to adopt, defer or reject the technique, the checks to
run first, and what to use instead. These are rules, not teaching material: the toolkit's planning tools will read them
to mark each technique adopt, defer or reject for a repo, and `./gradlew check` checks every file against
[the technique schema](../schema/technique.schema.json).

**Lessons** that teach each technique (an explanation, a runnable before-and-after example, slides and a narrated
video) are in their own repo, [under-test-lessons](https://github.com/fiftiesHousewife/under-test-lessons). The toolkit
doesn't record which lessons exist: each lesson names the technique ids it teaches in its own `lesson.yaml`, and the
lessons repo's build fails if its
[catalogue of every technique and its lessons](https://github.com/fiftiesHousewife/under-test-lessons/blob/main/lessons/CATALOGUE.md#every-toolkit-technique-and-its-lesson)
leaves out a technique here or names one that isn't. **Renaming or removing a technique id needs the same change in
the lessons repo.** See
[Each lesson names the toolkit techniques it teaches, and only the lessons repo records which lessons exist](../docs/decisions/0030-each-lesson-names-the-toolkit-techniques-it-teaches-and-only-the-lessons-repo-records-which-lessons-exist.md).

| Technique | Workstream | Evidence for maturity levels |
|---|---|---|
| [ai-written-tests](ai-written-tests/technique.yaml) | record current behaviour | 2 |
| [architecture-rules](architecture-rules/technique.yaml) | make code testable | 2–3 |
| [automatic-test-generation](automatic-test-generation/technique.yaml) | record current behaviour | 2 |
| [batch-file-in-file-out](batch-file-in-file-out/technique.yaml) | record current behaviour | 1–3 |
| [business-rule-tests](business-rule-tests/technique.yaml) | test against requirements | 3 |
| [characterisation-tests](characterisation-tests/technique.yaml) | record current behaviour | 1–2 |
| [contract-testing](contract-testing/technique.yaml) | make it run on its own | 3 |
| [database-unit-tests](database-unit-tests/technique.yaml) | test against requirements | 2–3 |
| [differential-testing](differential-testing/technique.yaml) | check in production | 3, 5 |
| [embedded-jakarta-ee-tests](embedded-jakarta-ee-tests/technique.yaml) | make it run on its own | 1–3 |
| [fake-behind-an-interface](fake-behind-an-interface/technique.yaml) | make it run on its own | 1–2 |
| [feature-flags](feature-flags/technique.yaml) | make code testable | 5 |
| [machine-state-checks](machine-state-checks/technique.yaml) | strengthen tests | 2 |
| [mutation-testing](mutation-testing/technique.yaml) | strengthen tests | 4 |
| [post-release-checks](post-release-checks/technique.yaml) | check in production | 5 |
| [property-based-testing](property-based-testing/technique.yaml) | test against requirements | 3 |
| [recorded-http-responses](recorded-http-responses/technique.yaml) | make it run on its own | 1–2 |
| [refactoring-for-testability](refactoring-for-testability/technique.yaml) | make code testable | 2–3 |
| [server-rendered-ui-tests](server-rendered-ui-tests/technique.yaml) | record current behaviour | 2–3 |
| [stand-in-commands](stand-in-commands/technique.yaml) | make it run on its own | 1–2 |
| [structured-output-comparison](structured-output-comparison/technique.yaml) | record current behaviour | 2 |
| [testcontainers](testcontainers/technique.yaml) | make it run on its own | 1–3 |
| [traffic-record-and-replay](traffic-record-and-replay/technique.yaml) | make it run on its own | 1–2 |
