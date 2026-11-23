# More than one module

Read this when the build has more than one module: `include` in `settings.gradle` or `settings.gradle.kts`, or
`<modules>` in a `pom.xml`.

* Before searching, ask the person which modules to search: one, several, or all, naming them. Don't ask when the
  person has already said.
* Search only the chosen modules' folders. Record them as `modules`, each module's folder from the repo root, in the
  `anti_patterns` section and in `found_by.find-test-anti-patterns.modules` in `testing/tests.yaml`.
* In `testing/tests.yaml`, replace `anti_patterns` only in entries whose `at` is in a chosen module, keep the rest,
  and set `modules` to every module searched so far. Count the findings over all the entries with `anti_patterns`.
* A test class with a copy in another module counts as `copy-pasted` only when both modules have been searched.
