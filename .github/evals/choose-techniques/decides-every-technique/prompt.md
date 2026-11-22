---
runs: 5
max_turns: 60
timeout_seconds: 1500
allowed_tools: [Read, Glob, Grep, Write, Edit, Bash, Skill]
---
We need to decide which testing techniques this repo's testing plan should use. Go through every technique in
`techniques/` (one `technique.yaml` per folder) and propose adopt, defer or reject for each, with the reason. What we
know about the repo is in `testing/assessment.yaml`, `testing/connections.calm.json` (its connection list) and
`testing/sources.yaml` (its source list), and its build is `build.gradle`. `decision-guides/` has our guides on the
target level for each business criticality and on the order of workstreams. Our CI can run container tests;
developers' machines can't run containers. Write the techniques section of `testing/assessment.yaml`, and a proposed
decision for each technique, so it still matches `schema/assessment.schema.json`. Don't build or run anything, and
leave the other sections and files alone. Then tell me briefly what to adopt, in the order the work should happen, and
what is deferred.
