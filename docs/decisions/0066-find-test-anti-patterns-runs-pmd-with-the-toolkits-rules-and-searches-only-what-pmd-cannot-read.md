---
status: accepted
decision-makers: Toolkit maintainers
group: Using the toolkit in an organisation
---

# find-test-anti-patterns runs PMD with the toolkit's rules, and searches only what PMD cannot read

**Decided by:** Toolkit maintainers · **Status:** accepted (chosen in discussion)

*This is a decision about the toolkit itself, made by its maintainers.*

## Context and Problem Statement

find-test-anti-patterns found anti-patterns in Java tests with text searches and two small scripts that counted
braces to find method bodies: a home-made parser that misreads braces in strings, comments and lambdas. The toolkit
reuses existing tools before building new ones, and its own build already uses PMD, which parses Java properly and
has rules for tests with no assertion, detached tests and empty catch blocks, and a copy-paste detector. The safety
inventory already works the same way: a rule file the toolkit ships, run by an existing tool.

## Considered Options

* **PMD with a toolkit ruleset: PMD's own test rules and a few XPath rules of the toolkit's, plus its copy-paste detector**  
  Parser accuracy, one command over the test folders, hits with file and line; searches stay for what isn't Java
* **The searches and scripts**  
  Nothing to approve, but they misread real code, and the scripts are code the toolkit maintains
* **A test-smell detector from research (tsDetect, JNose)**  
  Unmaintained, or needing a newer JDK than the toolkit can assume

## Decision Outcome

Chosen in discussion: PMD with a toolkit ruleset,
[`tools/meaningless-and-unreliable-tests/rules.pmd.xml`](../../tools/meaningless-and-unreliable-tests/rules.pmd.xml), and CPD,
PMD's copy-paste detector, ignoring literals. Each rule's name starts with the kind of anti-pattern it finds. PMD
reads code only and runs nothing. Searches and the assistant cover what PMD cannot read: hosts in settings files,
Spring XML and Spring Boot's settings, Cucumber feature files, test folders and classes the build never runs, and the
four `other` cases. Where no `pmd` command is available, the skill falls back to searches and says so in its report.

### Consequences

* PMD is one more artifact an organisation mirrors; [pmd-install](../../tools/meaningless-and-unreliable-tests/pmd-install/build.gradle)
  puts it and a `pmd` command in a folder from the package repository.
* The skill's two scripts are removed; its eval case installs PMD into each run's workspace.
* On the example repo the ruleset gives every expected answer, including a test that asserts through a shared helper,
  the try, fail, catch idiom, MockMvc's `andExpect` and Spring's JUnit 3 base classes.

## More Information

* Builds on: [A skill finds what to read by searching, and reads only what the searches find](0054-a-skill-finds-what-to-read-by-searching-and-reads-only-what-the-searches-find.md), [We reuse existing tools before building new ones](0021-we-reuse-existing-tools-before-building-new-ones.md)
* Later decisions that build on this: none yet
* Background: [the prior art](../PRIOR-ART.md)
