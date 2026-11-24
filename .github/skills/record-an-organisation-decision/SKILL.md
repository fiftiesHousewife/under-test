---
name: record-an-organisation-decision
description: Record an organisation's own fact or choice (its CI platform, issue tracker, container runtime, approved AI assistant, who fills a role, a choice between a guide's options) in that organisation's PRIVATE organisation repo. Use whenever an organisation-specific detail comes up. Never writes into this toolkit repo.
---

# Recording an organisation's decision

**Where the toolkit's files are:** this skill's links work wherever it is: in the toolkit's own repo they are relative to it, and when APM installs the toolkit in a repo it rewrites them to the toolkit's folder under `apm_modules/`. Where a command names `<toolkit>`, that is the toolkit's root: the repo root in the toolkit itself, otherwise `"$(dirname "$(find apm_modules -path '*/.github/skills/record-an-organisation-decision/SKILL.md' | head -1)")/../../.."`.

**Never write organisation details into this toolkit repo.** Ask for the path of the organisation's private organisation
repo if you don't have it. If it doesn't exist yet, offer to create one from [the example organisation repo](../../../examples/organisation-repo/README.md).

## Is it a fact or a choice?
- **A fact with no choice** (for example "CI runs on Kubernetes", "the issue tracker is Jira Cloud", "developer machines have
  no container runtime"): set the matching field in the organisation repo's `organisation-profile.yaml`. Check it against
  [the organisation profile schema](../../../schema/organisation-profile.schema.json). No decision record is needed.
- **A choice** (for example which of a guide's options to use for running container tests in CI): write a decision record
  in the organisation repo's `docs/decisions/`, from its template.

## Writing the organisation's decision record
1. Title: the question in full, in plain English.
2. Under **More Information**, name and link the toolkit decision guide it **adopts**, **narrows** or **replaces**, by title.
3. `decision-makers`: the engagement role, and the named person or team from the organisation profile.
4. If the choice is also a profile value (for example `ci.container_runtime_for_tests`), update the profile in the same pull request.
5. Follow the toolkit's words and rules: plain English, references by name and link, no dates.
