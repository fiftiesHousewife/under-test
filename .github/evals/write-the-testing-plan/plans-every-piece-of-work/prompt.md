---
runs: 5
max_turns: 40
timeout_seconds: 900
allowed_tools: [Read, Glob, Grep, Write, Edit, Bash, Skill]
---
Write this repo's testing plan as `testing/TESTING-PLAN.md`, from `testing/assessment.yaml` (its techniques are
already chosen) and `testing/external-systems.calm.json`. It needs the target level, every piece of work in order with a
stable key that an issue tracker loader can match on later runs, the techniques deferred or rejected and why, and
what the Application Owner decides or answers by approving it. The technique rules are in `techniques/`, and the
order of work and the target levels are in `decision-guides/`. Don't change any other file. Then tell me briefly
what is in the plan.
