# Evaluation: find-test-anti-patterns

Does the [find-test-anti-patterns](../../.github/skills/find-meaningless-and-unreliable-tests/SKILL.md) skill save an AI assistant
effort and give the same result each time? It was tried against the same task done without it.

## How it was tried

The repo was [a sample of 22 JUnit 4 tests](find-meaningless-and-unreliable-tests/sample-repo) with a known number of each
anti-pattern: 4 disabled, 2 with no real assertion, 2 that sleep, 3 that depend on run order, 2 that reach a shared
database, 2 in a class with six mocks, and 2 copy-pasted. It also has tests that must not count: one that expects an
exception, and one that calls `localhost`. Each agent got the same task and the toolkit; the agent without the skill
was told not to read the skills or this folder. Each result was compared with the known counts and checked against
the assessment file's schema, and the tests were checked unchanged.

## Results

| Run | Tool calls | Tokens | Time | Result |
|---|---|---|---|---|
| Without the skill | 8 | 60,500 | 79 s | Every count right, plus two weaknesses outside the list; `found_by` names an invented tool, and ids are its own |
| With the skill | 7 | 56,200 | 47 s | Every count right, ids and proposals as the skill sets them; nothing outside the list |
| With the skill, after adding "note what the list misses" | 6 | 60,900 | 76 s | Every count right, plus five weaknesses outside the list and three questions for the Application Owner |

## What it shows

* **Counting the listed anti-patterns doesn't need the skill:** a capable assistant gets the same counts from the
  guide alone. The skill's value is that the counts are defined, so every repo and every re-run is counted the same
  way, with the same ids, the same `found_by` and the same proposed decisions.
* **A fixed list can make an assistant look less.** The first version of the skill found only what it listed, and
  missed an expected value bent to pass and a test needing a server nothing starts, which the assistant without the
  skill noticed. The skill now asks for those explicitly, as `other` findings, and the second trial found more than
  either earlier run.
* Neither run changed a test or ran anything.
