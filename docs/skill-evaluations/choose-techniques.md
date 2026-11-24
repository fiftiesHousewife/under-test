# Evaluation: choose-techniques

These runs come from before the skills' renames (find-test-anti-patterns, now find-meaningless-and-unreliable-tests;
draft-the-connection-list, now draft-the-external-systems-list), so they use the earlier names and words.

Does the [choose-techniques](../../.github/skills/choose-techniques/SKILL.md) skill make an AI assistant's choice of
techniques the same each time, and traceable to the toolkit's rules? It was tried against the same task done without
it, and run more than once with it, since a choice people can rely on must not depend on which run they got.

## How it was tried

The example order service: a Spring Boot 2.3 web service on JDK 8 with JUnit 4 and Oracle, high business criticality,
a decided target of level 4, flaky tests, weak tests, a connection list and a source list. Container tests run in CI
only. Each agent decided all 23 techniques in [`techniques/`](../../techniques/README.md). Agreement is the number of
techniques two runs chose the same way.

## Results

| Run | Tool calls | Tokens | Time | Result |
|---|---|---|---|---|
| Without the skill | 10 | 91,800 | 128 s | All 23 decided, with reasons; no `techniques` section; two questions and notes added |
| First version of the skill, two runs | 10 and 8 | 79,800 and 79,300 | 171 s and 168 s | All 23 each, every reason quoting its rule; the two runs agreed on 19 |
| Fixed skill, two runs | 8 and 9 | 73,400 and 77,200 | 135 s and 161 s | All 23 each, every reason quoting its rule; the two runs agreed on 22 |

## What it shows

* **The first version disagreed with itself on four techniques, for two reasons the trial exposed.** It deferred
  techniques whose work had to wait for earlier workstreams, such as characterisation tests waiting for the code to
  run on its own, which is the testing plan's job to order, not a reason to defer. And it said nothing about unknown
  facts, so one run rejected database unit tests and differential testing while the other deferred them. The skill
  now adopts a technique that belongs in the plan whatever must come first, and defers, never rejects, on an unknown.
* **Fixed, two runs agree on 22 of 23,** the one difference being whether a program the code starts needs a stand-in
  command now or after a check of how it is started. Every reason quotes the rule that decided it, so a person can see
  why and change it.
* It used about a fifth fewer tokens than the run without it, in about the same time. The run without it reasoned well
  but its reasons don't point at the rules, and it wrote no `techniques` section for the plan to read.
