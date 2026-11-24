---
runs: 5
max_turns: 30
timeout_seconds: 600
allowed_tools: [Read, Glob, Grep, Write, Edit, Bash, Skill]
---
Score this repo's obstacles to testing, using the named list and scoring rules in the decision guide in
`decision-guides/`, from what is recorded in `testing/assessment.yaml` and `testing/external-systems.calm.json`. Write the
scores, with the evidence for each, into the `obstacles` section of `testing/assessment.yaml`, which must match
`schema/assessment.schema.json`. Don't change anything else. Then tell me briefly what makes this repo hardest to test.
