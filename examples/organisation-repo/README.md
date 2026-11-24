# Example organisation repo

This toolkit is generic. Each organisation keeps its own facts and decisions in a **private organisation repo**, never in
this one. This folder shows the shape of that repo. Copy it, keep it private, and fill it in.

| File or folder | What it holds |
|---|---|
| [`organisation-profile.yaml`](organisation-profile.yaml) | Facts the organisation can't choose: its issue tracker, CI platform, image build tool, developer machines, package repository, approved AI assistants, and who fills each engagement role. Checked against [the organisation profile schema](../../schema/organisation-profile.schema.json). |
| [`docs/decisions/`](docs/decisions/template.md) | The organisation's own decision records, from [the template](docs/decisions/template.md). Each one names the [decision guide](../../decision-guides/README.md) it adopts, narrows or replaces. |
| [`units/`](units/README.md) | One folder per organisation unit that wants its own decisions or stricter settings. |

Two more folders come later, as pilots finish: `testing-guides/`, one testing guide per technology stack and per
application type, from [the toolkit's template](../../templates/testing-guide.md); and `shared-test-kits/`, one folder
per external system that many repos use, from [the toolkit's template](../../templates/shared-test-kit.md).

Use the [record-an-organisation-decision skill](../../.github/skills/record-an-organisation-decision/SKILL.md) to write
these. It writes into the organisation repo only.
