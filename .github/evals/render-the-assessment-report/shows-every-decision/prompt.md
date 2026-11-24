---
runs: 5
max_turns: 40
timeout_seconds: 900
allowed_tools: [Read, Glob, Grep, Write, Edit, Bash, Skill]
---
The Application Owner needs to review where this repo's testing stands. Make a self-contained page they can review,
showing the decisions they can change, from `testing/assessment.yaml`, `testing/external-systems.calm.json` and
`testing/sources.yaml`. Save it as `testing/assessment-report.html`, and leave those three files as they are. Then
tell me briefly: is it safe to run, does it run on its own, and can its tests be trusted?
