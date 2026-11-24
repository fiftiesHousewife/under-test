---
status: accepted
decision-makers: Toolkit maintainers
group: Recording results and owning plans
---

# A repo with several applications keeps each application's testing files in their own folder under testing/

**Decided by:** Toolkit maintainers · **Status:** accepted (chosen in discussion)

*This is a decision about the toolkit itself, made by its maintainers.*

## Context and Problem Statement

Every skill reads and writes one set of testing files per repo: `testing/assessment.yaml`, `testing/connections.calm.json`,
`testing/sources.yaml`, `testing/TESTING-PLAN.md` and the report page. Organisations with monorepos (one repo holding
several applications, each with its own owner, connections and level) have nowhere to put the second application.
An application may span several modules of the build, and one module may be shared by several applications.

## Considered Options

* **A folder per application under the repo's `testing/`**  
  `testing/<application>/` holds that application's files, and its assessment file names the modules or folders its
  code is in; one place to find every application, and code-owner rules can give each folder to its team
* **A `testing/` folder next to each application's code**  
  Natural when each application is one module with its own team, but awkward when an application spans modules, and
  harder to find them all
* **One assessment file listing every application**  
  Nothing moves, but the file grows large, every team edits it, and every schema and skill changes shape

## Decision Outcome

Chosen in discussion: a folder per application under `testing/`. A repo with one application keeps its files directly
in `testing/`, as now. A repo with more than one has a folder for each, named after the application as its assessment
file names it, and nothing directly in `testing/`. Each application's assessment file names the
modules or folders that hold its code, and every skill works on one application folder at a time.

### Consequences

* The assessment file's schema gains the list of modules or folders the application's code is in.
* Every journey skill takes the application's folder, defaulting to `testing/` in a repo with one application, and
  only reads the code, reports and tests in that application's modules.
* Work-item keys in the testing plan already start with the application, so plans from different folders don't clash
  in the issue tracker.
* An eval case with a repo holding two applications checks that a skill touches only the folder it was given.

## More Information

* Builds on: [Each application's connections are recorded as a CALM connection list](../../decision-guides/0030-each-applications-external-systems-are-recorded-as-a-calm-list.md)
* Later decisions that build on this: none yet
* Background: none
