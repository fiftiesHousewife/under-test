---
runs: 5
max_turns: 30
timeout_seconds: 1200
allowed_tools: [Read, Glob, Grep, Write, Edit, Bash, Skill]
---
How far can this repo's existing tests be trusted? Find its meaningless tests (they never run, can't fail, or check
only their mocks) and its unreliable tests (they sleep, or depend on the order tests run in), and record them in the
`meaningless_tests` and `unreliable_tests` sections of `testing/assessment.yaml`, which must match
`schema/assessment.schema.json`. Read the code only: don't build or run anything, and don't change any test. Then tell
me briefly what you found.
