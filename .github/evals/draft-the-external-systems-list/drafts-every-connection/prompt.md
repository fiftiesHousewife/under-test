---
runs: 5
max_turns: 40
timeout_seconds: 900
allowed_tools: [Read, Glob, Grep, Write, Edit, Bash, Skill]
---
This repo's tests and application have been run under the airgap agent, which refuses every call off the machine
and reports it. Its reports are `build/airgap/test/calls.jsonl` and `build/airgap/bootRun/calls.jsonl`, one JSON
object per line. From them, draft the repo's external systems list in `testing/external-systems.calm.json`, which must match
`schema/external-systems-list.schema.json`, with a proposed test stand-in for each connection
(`decision-guides/0036-order-of-preference-for-test-stand-in-approaches.md`) and the addresses tests must never reach
(`decision-guides/0031-the-external-systems-list-says-what-tests-use-for-each-system-and-which-addresses-tests-must-never-reach.md`).
Also record what the code tried to reach in the `running_offline` section of `testing/assessment.yaml`, which must
match `schema/assessment.schema.json`, and in `testing/tests.yaml` (`schema/tests.schema.json`) which tests reached
each system. Don't build or run anything, and leave the rest of the repo alone. Then tell
me briefly what the code tried to reach and what needs confirming.
