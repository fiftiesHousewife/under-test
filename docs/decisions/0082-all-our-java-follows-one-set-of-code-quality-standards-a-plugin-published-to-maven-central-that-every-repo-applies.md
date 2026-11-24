---
status: accepted
decision-makers: Toolkit maintainers
group: How we work
---

# All our Java follows one set of code-quality standards: a plugin published to Maven Central that every repo applies

**Decided by:** Toolkit maintainers · **Status:** accepted (chosen in discussion)

*This is a decision about the toolkit itself, made by its maintainers.*

## Context and Problem Statement

The toolkit, connection-paths, under-test-tools and the lessons repo each hold a copy of the same Gradle conventions
and quality rules (`build-logic/` and `config/quality/`). A convention plugin in `build-logic/` is shared by the
modules of one build, not between repos, so the copies drift: connection-paths is already tightening its own. The
backlog's convention plugin every repo applies is a different thing, for the old repos the journey works on (JDK 8,
old Gradle; coverage, mutation testing, the airgap agent), and comes later.

## Considered Options

* **A code-quality plugin for our own repos, now, in its own repo**  
  One source for the rules; each repo applies a pinned version instead of a copy
* **One plugin for our repos and the target repos**  
  One artifact, but it must then run on old Gradle and JDK 8, which our own repos don't need
* **Keep the copies, synchronised by a script**  
  Nothing to publish; the copies can still drift between runs of the script

## Decision Outcome

Chosen in discussion: a code-quality plugin for our own repos, now, in its own repo, published to Maven Central.

* **It applies to all our Java:** the toolkit's own tools, connection-paths, under-test-tools, the lessons repo's
  examples, and every repo of ours to come.
* **Its rules** are today's (Checkstyle, PMD and its copy-paste detector, SpotBugs with FindSecBugs, forbidden
  APIs, JaCoCo's coverage floor, at most three parameters, records of at most three components, `assertAll` for
  several assertions, Lombok `@Slf4j`, an injected `Clock`), tightened as connection-paths now has them: packages by
  area, methods of 20 lines or fewer, files of 150 lines or fewer, no comments on fields, Javadoc only on public API,
  streams rather than for-each loops, and one assertion, or one `assertAll`, per test.
* **Published to Maven Central**, signed, with its Gradle plugin marker, so an organisation mirrors it with everything
  else; each repo pins its version and adds `mavenCentral()` to `pluginManagement` in its settings.
* **Proposed names:** the repo `java-conventions`; the plugin keeps the id the copies use now,
  `io.github.fiftieshousewife.java-conventions`. The rule files ship inside the plugin's jar.
* An organisation may apply it to new code of its own, one of the choices in
  [Code-quality standards can be the toolkit's, the organisation's, or the organisation's own plugin](0013-code-quality-standards-can-be-the-toolkits-the-organisations-or-the-organisations-own-plugin.md).
  The convention plugin for target repos stays separate.

### Consequences

* A new repo, created by a maintainer, seeded from connection-paths' conventions once its restructure is done.
* Each repo of ours replaces its `build-logic/` copy and `config/quality/` with the plugin, fixing what the tighter
  rules find; [AGENTS.md](../../AGENTS.md)'s code standards follow when this repo does.
* The lessons repo's copy of the build conventions ends.

## More Information

* Builds on: [The toolkit is AI first: its steps are skills that run existing tools, and code lives in its own repos](0040-the-toolkit-is-ai-first-its-steps-are-skills-that-run-existing-tools-and-code-lives-in-its-own-repos.md), [Lessons live in their own repo, with a copy of the build conventions](0017-lessons-live-in-their-own-repo-with-a-copy-of-the-build-conventions.md), [This repo's own upkeep is kept apart from what adopting organisations use](0034-this-repos-own-upkeep-is-kept-apart-from-what-adopting-organisations-use.md)
* Later decisions that build on this: none yet
* Background: nothing
