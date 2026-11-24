---
status: accepted
decision-makers: Toolkit maintainers
group: How we work
---

# All our Java applies the java-conventions plugin, which holds our code-quality standards

**Decided by:** Toolkit maintainers · **Status:** accepted (chosen in discussion)

*This is a decision about the toolkit itself, made by its maintainers.*

## Context and Problem Statement

The toolkit, under-test-external-calls, under-test-tools, the airgap agent and the lessons repo each held a copy of
the same Gradle conventions and quality rules (`build-logic/` and `config/quality/`). A convention plugin in
`build-logic/` is shared by the modules of one build, not between repos, so the copies drifted. Three records settled
the parts one at a time: one set of standards in a published plugin, for-each loops only flagged, and the Gradle
Plugin Portal allowed for the plugin's own Gradle plugins. This record states the whole of it in one place.

## Considered Options

* **One plugin, java-conventions, in its own repo, published to Maven Central, that every repo of ours applies**  
  One source for the rules; each repo pins a version
* **One plugin for our repos and the target repos**  
  One artifact, but it must then run on old Gradle and JDK 8, which our own repos don't need
* **Keep the copies, synchronised by a script**  
  Nothing to publish; the copies can still drift between runs of the script

## Decision Outcome

Chosen in discussion: one plugin, `io.github.fiftieshousewife.java-conventions`, from the
[java-conventions](https://github.com/fiftiesHousewife/java-conventions) repo.

* **It applies to all our Java:** the toolkit's own tools, under-test-external-calls, under-test-tools, the airgap
  agent, the lessons repo's examples, and every repo of ours to come. Each applies a pinned version and deletes its
  `build-logic/` and `config/quality/` copies in the same change.
* **Its rules and tool versions ship inside its jar**, and its README is the one list of the standards: short
  methods and files, low complexity, few parameters, one assertion per test, no field comments, Javadoc only on
  public API, no copy-pasted code, SpotBugs with FindSecBugs, forbidden APIs with an injected `Clock`, and a coverage
  floor.
* **For-each loops are flagged, not forbidden:** that rule reports in `pmdAdvice` and never fails the build; every
  other rule does.
* **It is published to Maven Central**, signed, with its Gradle plugin marker. Its own Gradle plugins (SpotBugs', the
  versions report's and PIT's) come from the Gradle Plugin Portal, so a repo applying it lists `gradlePluginPortal()`
  and `mavenCentral()` in `pluginManagement`. Organisations already proxy both.
* **A repo's own exceptions stay in the repo:** SpotBugs exclusions in `config/quality/spotbugs/exclude.xml`, or a
  suppression at the site with its reason.
* An organisation may apply it to new code of its own, one of the choices in
  [Code-quality standards can be the toolkit's, the organisation's, or the organisation's own plugin](0013-code-quality-standards-can-be-the-toolkits-the-organisations-or-the-organisations-own-plugin.md).
  The convention plugin for the old target repos the journey works on (JDK 8, old Gradle) stays separate and comes
  later.

This replaces
[All our Java follows one set of code-quality standards: a plugin published to Maven Central that every repo applies](0082-all-our-java-follows-one-set-of-code-quality-standards-a-plugin-published-to-maven-central-that-every-repo-applies.md),
[For-each loops are flagged, not forbidden](0083-for-each-loops-are-flagged-not-forbidden.md) and
[The quality plugin may pull Gradle plugins from the Gradle Plugin Portal](0084-the-quality-plugin-may-pull-gradle-plugins-from-the-gradle-plugin-portal.md),
and narrows [Lessons live in their own repo, with a copy of the build conventions](0017-lessons-live-in-their-own-repo-with-a-copy-of-the-build-conventions.md):
the lessons repo applies the plugin instead of keeping a copy.

### Consequences

* [AGENTS.md](../../AGENTS.md)'s code standards follow the plugin's README.
* Each repo's move to the plugin is a backlog item; under-test-external-calls and the airgap agent still keep their
  own copies until theirs is done.

## More Information

* Builds on: [The toolkit is AI first: its steps are skills that run existing tools, and code lives in its own repos](0040-the-toolkit-is-ai-first-its-steps-are-skills-that-run-existing-tools-and-code-lives-in-its-own-repos.md), [This repo's own upkeep is kept apart from what adopting organisations use](0034-this-repos-own-upkeep-is-kept-apart-from-what-adopting-organisations-use.md), [Code-quality standards can be the toolkit's, the organisation's, or the organisation's own plugin](0013-code-quality-standards-can-be-the-toolkits-the-organisations-or-the-organisations-own-plugin.md)
* Later decisions that build on this: none yet
* Background: none
