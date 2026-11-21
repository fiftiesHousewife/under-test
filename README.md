# under-test

[![Build](https://github.com/fiftiesHousewife/under-test/actions/workflows/build.yml/badge.svg)](https://github.com/fiftiesHousewife/under-test/actions/workflows/build.yml)
[![Licence: Apache-2.0](https://img.shields.io/badge/licence-Apache--2.0-blue)](LICENSE)
![Java 25](https://img.shields.io/badge/Java-25-blue)
![Gradle 9](https://img.shields.io/badge/Gradle-9-02303A)
![JUnit 6](https://img.shields.io/badge/JUnit-6-25A162)
[![Decision guides](https://img.shields.io/badge/decisions-MADR-informational)](docs/decisions/README.md)

**A toolkit for getting old code properly tested, one repo at a time.**

Many organisations have hundreds or thousands of repositories with few or weak tests. This toolkit helps a team,
working with AI coding assistance, find out what each repo needs, plan the work, and do it safely. It gives you:

- **Lessons on testing techniques**, each with a small runnable example showing a before and an after.
- **Decision guides:** one short record per choice the programme has to make, with the options and what follows from each.
- **Build conventions and tools** that measure test quality and apply good practice in every build.
- **A repo classifier** that says what kind of codebase a repo is, for people or for a survey tool to call.
- **AI assistant skills** that let an AI help with the work while a person reviews everything it produces.

The toolkit is **generic**. Nothing in it is specific to one organisation: each organisation adds its own facts and
choices in a private organisation repo. [ADOPTION.md](ADOPTION.md) walks through adopting it step by step, and
[docs/CORPORATE-USE.md](docs/CORPORATE-USE.md) explains how it works inside a locked-down corporate network: no
internet installs, no public code hosting, your own package repository, proxy, tracker and knowledge tools.

## Try it

You need JDK 25. The Gradle wrapper fetches everything else.

```bash
git clone https://github.com/fiftiesHousewife/under-test.git
cd under-test
./gradlew check
```

`check` runs the tests and every quality check: coverage, style, complexity, copy-paste detection, bug and
security-bug analysis (SpotBugs with FindSecBugs), and forbidden APIs. See [the code standards](AGENTS.md#code-standards-enforced-by-gradlew-check).

### See mutation testing catch weak tests

The [mutation testing lesson](techniques/mutation-testing/README.md) has two test suites with the same 100% line
coverage. One catches bugs; the other doesn't:

```bash
./gradlew :techniques:mutation-testing:pitest -Psuite=weak   # 5 of 13 deliberately introduced bugs caught
./gradlew :techniques:mutation-testing:pitest                # 13 of 13 caught
```

The difference comes down to tests like these:

```java
// Weak: passes for any positive discount, so a wrong percentage goes unnoticed
assertTrue(calc.discountPercent(200, false) > 0);

// Strong: checks both sides of each boundary, and reports every failure at once
assertAll(
        () -> assertThat(calc.discountPercent(49, false)).isZero(),
        () -> assertThat(calc.discountPercent(50, false)).isEqualTo(5),
        () -> assertThat(calc.discountPercent(100, false)).isEqualTo(10));
```

## Adopting it in your organisation

You don't change this repo to use it. You keep your organisation's details in a **private organisation repo** and point the
toolkit at it.

```
 this toolkit (public, generic)             your organisation repo (private)
 ──────────────────────────────             ─────────────────────────────────────────────
 decision guides             ◀── adopt, narrow or replace ──  your own decision records
 organisation profile schema ◀── checked against ───────────  organisation-profile.yaml
 convention plugin, skills   ◀── mirrored through ──────────  your package repository
 underTest { } settings      ◀── set from ──────────────────  your Gradle init script
```

1. **Create your organisation repo.** Copy [`examples/organisation-repo/`](examples/organisation-repo/README.md) into a new
   private repo and fill in `organisation-profile.yaml`: your issue tracker, code-hosting and CI platforms, package
   repository, approved AI assistants, whether every commit must name a work item, and who fills each engagement role.
   It is checked against [the organisation profile schema](schema/organisation-profile.schema.json).
2. **Keep your build environment.** Proxy, package repository and credentials stay in your existing Gradle init script
   or Maven `settings.xml`. The toolkit never sets them.
3. **Choose your code-quality standards.** The quality checks read one setting, which you can put in your init script
   so it applies to every build:

   ```properties
   underTest.codeStyle=ORGANISATION                      # TOOLKIT (ours), ORGANISATION (your rule files) or NONE (your own plugin)
   underTest.checkstyleConfig=/path/to/your/checkstyle.xml
   underTest.minLineCoverage=0.70
   ```

   The testing evidence the programme relies on (coverage, flaky-test detection, mutation sampling, checks on
   AI-written tests) always runs; only its thresholds follow your decisions.
4. **Record your choices.** Where a decision guide leaves a choice, for example how CI runs container tests on your
   platform, record it in your organisation repo with the
   [record-an-organisation-decision skill](.github/skills/record-an-organisation-decision/SKILL.md).
5. **Load the work.** Import [the starting backlog](plan/backlog-seed.yaml) into your issue tracker. Each repo's
   approved testing plan then adds its own work items. Importers exist per tracker; see
   [tools/backlog-import](tools/backlog-import/README.md).
6. **Follow the phases:** set-up, classifying your repos, pilots for each common kind of repo, rolling out in batches,
   and handing over to your own teams. Each step is backed by [decision guides](docs/decisions/README.md); the roles
   are in [the glossary](GLOSSARY.md#engagement-roles).

## Surveying many repos

Surveying every repo in an organisation is outside this toolkit. The toolkit's repo classifier works on one repo and
writes a result in [a published format](schema/repo-classification.schema.json), so any survey tool can call it.
[A design for such a tool](docs/design/survey-tool.md) shows how to survey a GitHub organisation.

## What's in this repo

| Folder | What you'll find |
|---|---|
| [`techniques/`](techniques/README.md) | One folder per testing technique: a lesson, a runnable example, and the rules for when to use it |
| [`docs/decisions/`](docs/decisions/README.md) | Decision guides, one small decision each, building from foundations upward |
| [`docs/CORPORATE-USE.md`](docs/CORPORATE-USE.md) | How the toolkit is used inside a locked-down corporate network |
| [`docs/design/`](docs/design/survey-tool.md) | Designs for tools that sit outside the toolkit |
| [`docs/REFERENCES.md`](docs/REFERENCES.md) | Background reading and sources |
| [`GLOSSARY.md`](GLOSSARY.md) | The words we use, and the words we avoid |
| [`examples/organisation-repo/`](examples/organisation-repo/README.md) | The shape of an organisation's private organisation repo |
| [`schema/`](schema/) | JSON Schemas for every YAML and JSON format the toolkit reads or writes |
| [`tools/`](tools/) | Tools, including [the backlog importers](tools/backlog-import/README.md) |
| [`plan/backlog-seed.yaml`](plan/backlog-seed.yaml) | The starting list of work, to import into your issue tracker |
| [`build-logic/`](build-logic/), [`config/quality/`](config/quality/) | Gradle conventions and quality-check rules |
| [`AGENTS.md`](AGENTS.md) | How AI coding assistants, and people, should work here |

## Licence

Apache License 2.0, for everything in this repository: code, tools, guides, lessons and videos. See [LICENSE](LICENSE)
and [NOTICE](NOTICE).

## Contributing

Read [AGENTS.md](AGENTS.md) and [GLOSSARY.md](GLOSSARY.md) first. In short: plain English, refer to things by name with
a link, a schema for every YAML file, nothing organisation-specific, and `./gradlew check` must pass.
