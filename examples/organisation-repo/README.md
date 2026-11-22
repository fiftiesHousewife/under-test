# Example organisation repo

This toolkit is generic. Each organisation keeps its own facts and decisions in a **private organisation repo**, never in
this one. This folder shows the shape of that repo. Copy it, keep it private, and fill it in.

| File | What it holds |
|---|---|
| [`organisation-profile.yaml`](organisation-profile.yaml) | Facts the organisation can't choose: its issue tracker, CI platform, image build tool, developer machines, package repository, approved AI assistants, and who fills each engagement role. Checked against [the organisation profile schema](../../schema/organisation-profile.schema.json). |
| `testing-guides/` | One testing guide per technology stack and per application type, written after a pilot application of that kind, from [the toolkit's template](../../templates/testing-guide.md). |
| `shared-test-kits/` | One folder per widely shared system, from [the toolkit's template](../../templates/shared-test-kit.md). |
| `docs/decisions/` | The organisation's own decision records, in the same format as [this toolkit's decision guides](../../docs/decisions/README.md). Each one names the generic decision it adopts, narrows or replaces. |

Use the [record-an-organisation-decision skill](../../.github/skills/record-an-organisation-decision/SKILL.md) to write
these. It writes into the organisation repo only.
