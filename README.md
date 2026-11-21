# under-test

[![Build](https://github.com/fiftiesHousewife/under-test/actions/workflows/build.yml/badge.svg)](https://github.com/fiftiesHousewife/under-test/actions/workflows/build.yml)
![Java 21](https://img.shields.io/badge/Java-21-blue)
![Gradle 9](https://img.shields.io/badge/Gradle-9-02303A)
[![Decision guides](https://img.shields.io/badge/decisions-MADR-informational)](docs/decisions/README.md)

**A toolkit for getting old code properly tested, one repo at a time.**

Many organisations have hundreds or thousands of repositories with few or weak tests. This toolkit helps a team, working
with AI coding assistance, find out what each repo needs, plan the work, and do it safely. It gives you:

- **Lessons on testing techniques**, each with a small runnable example showing a before and an after.
- **Decision guides:** short records of each choice the programme has to make, with the options and their consequences.
- **Tools and Gradle conventions** that measure test quality and enforce good practice in every build.
- **AI assistant skills** that let an AI help with the work, while a person reviews everything it produces.

The toolkit is generic. Each organisation keeps its own facts and choices (its CI platform, issue tracker and so on) in
a private overlay repo, so nothing organisation-specific lives here.

## Try it

You need JDK 21. The Gradle wrapper fetches everything else.

```bash
git clone https://github.com/fiftiesHousewife/under-test.git
cd under-test
./gradlew check
```

To install the external AI assistant skills this repo uses (see [`apm.yml`](apm.yml)), install [APM](https://microsoft.github.io/apm/) and run `apm install`.

`check` runs the tests and every quality check: coverage, style, complexity, copy-paste detection, bug and security-bug
analysis, and forbidden APIs. See [the code standards](AGENTS.md#code-standards-enforced-by-gradlew-check).

### See mutation testing catch weak tests

The [mutation testing lesson](techniques/mutation-testing/README.md) has two test suites with the same 100% line coverage.
One catches bugs; the other doesn't:

```bash
./gradlew :techniques:mutation-testing:pitest -Psuite=weak   # 5 of 13 deliberately introduced bugs caught
./gradlew :techniques:mutation-testing:pitest                # 13 of 13 caught
open techniques/mutation-testing/example/build/reports/pitest/index.html
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

## What's in this repo

| Folder | What you'll find |
|---|---|
| [`techniques/`](techniques/README.md) | One folder per testing technique: a lesson, a runnable example, and the rules for when to use it |
| [`docs/decisions/`](docs/decisions/README.md) | Decision guides, one small decision each, building from foundations upward |
| [`docs/REFERENCES.md`](docs/REFERENCES.md) | Background reading and sources, from legacy code to mutation testing at Google |
| [`GLOSSARY.md`](GLOSSARY.md) | The words we use, and the words we avoid |
| [`examples/organisation-overlay/`](examples/organisation-overlay/README.md) | How an organisation records its own facts and choices, privately |
| [`schema/`](schema/) | JSON Schemas for every YAML file the toolkit reads |
| [`tools/`](tools/) | Tools, including [the backlog importer](tools/backlog-import/README.md) |
| [`plan/backlog-seed.yaml`](plan/backlog-seed.yaml) | The starting list of work, to import into your issue tracker |
| [`build-logic/`](build-logic/), [`config/quality/`](config/quality/) | Gradle conventions and quality-check rules |
| [`AGENTS.md`](AGENTS.md) | How AI coding assistants (and people) should work here |

## How the programme works

1. **Set up:** agree the roles and the definition of "well tested", and make sure no old code can reach production while it runs.
2. **Find out what repos you have:** classify each repo by technology stack and application type, using existing tools.
3. **Pilot:** treat one real application for each common kind of repo by hand, and turn what you learn into testing guides.
4. **Roll out in batches:** measure each repo, generate a testing plan its owner approves, and track the work in your issue tracker.
5. **Hand over:** your own teams run the programme without outside help.

Each step is backed by [decision guides](docs/decisions/README.md). The roles, from Programme Sponsor to Application Owner,
are in [the glossary](GLOSSARY.md#engagement-roles).

## Load the starting backlog into GitHub Issues

```bash
python3 tools/backlog-import/import_to_github.py OWNER/REPO            # dry run
python3 tools/backlog-import/import_to_github.py OWNER/REPO --apply    # create or update issues
```

## Contributing

Read [AGENTS.md](AGENTS.md) and [GLOSSARY.md](GLOSSARY.md) first. In short: plain English, refer to things by name with a
link, a schema for every YAML file, nothing organisation-specific, and `./gradlew check` must pass.
