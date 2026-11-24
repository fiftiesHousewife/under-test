# More than one module

Read this when the build has more than one module: `include` in `settings.gradle` or `settings.gradle.kts`, or
`<modules>` in a `pom.xml`.

* Before searching, ask the person which modules to search: one, several, or all, naming them. Don't ask when the
  person has already said.
* Search only the chosen modules' folders. Record them as `modules`, each module's folder from the repo root, in both
  sections of `testing/assessment.yaml` and in `found_by.find-meaningless-and-unreliable-tests.modules` in
  `testing/tests.yaml`.
* In `testing/tests.yaml`, replace `meaningless` and `unreliable` only in entries whose `at` is in a chosen module,
  keep the rest, and set `modules` to every module searched so far. Count the findings over all the entries.
