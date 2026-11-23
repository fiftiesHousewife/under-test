# More than one module

Read this when the build has more than one module: `include` in `settings.gradle` or `settings.gradle.kts`, or
`<modules>` in a `pom.xml`.

* Before running anything, ask the person which modules to cover: one, several, or all, naming them. Don't ask when
  the person has already said.
* Run connection-paths once per chosen module, with that module's classpath file, each writing
  `testing/connection-paths/<module folder, / as ->.json`. A module's tests reach only what that module and the modules
  it depends on open; give a module's dependencies on other modules of the repo as more `--main` folders.
* Record the modules covered so far, each module's folder from the repo root, in
  `found_by.draft-the-connection-list.modules` in `testing/tests.yaml`. Replace `connections` only in entries whose `at`
  is in a chosen module, and keep the rest.
* A system found from two modules is one node: merge their `opened-by`, `callers` and `tests`.
