---
runs: 5
max_turns: 30
timeout_seconds: 600
allowed_tools: [Read, Glob, Grep, Write, Edit, Bash, Skill]
---
Before any of this repo's code is built or run, record what in it could reach production or real data: its safety
inventory. The scans are already done, because gitleaks isn't installed here. `secrets.json` is
`gitleaks git` over the whole history, `safety-inventory.json` is `gitleaks dir` over the current files, and
`keystores-ever-added.txt` lists every keystore ever committed, with the commit that added it. Write the results
into the `safety` section of `testing/assessment.yaml`, which must match `schema/assessment.schema.json`. Don't build
or run anything, and leave the repo's other files alone. Then tell me briefly what blocks the repo.
