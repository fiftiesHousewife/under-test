---
runs: 5
max_turns: 40
timeout_seconds: 900
allowed_tools: [Read, Glob, Grep, Write, Edit, Bash, Skill]
---
Find what this repo's code connects to outside itself, and which of its tests can reach each of those systems. It is
in discovery: nothing of it has run, and nothing may. connection-paths isn't installed here, but it has already been
run on this commit with `--module .`: its facts are in `testing/connection-paths.json`, current. Draft the repo's
external systems list in `testing/external-systems.calm.json` (`schema/external-systems-list.schema.json`), with a proposed test
stand-in for each system (`decision-guides/0036-order-of-preference-for-test-stand-in-approaches.md`), and record each
test's connections, and whether it reaches, may reach or cannot reach each one, in `testing/tests.yaml`
(`schema/tests.schema.json`). Leave the rest of the repo alone. Then tell me briefly which tests can reach a real
system and what needs confirming.
