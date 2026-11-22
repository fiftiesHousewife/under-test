---
name: write-a-decision-record
description: Draft or update a decision record in this toolkit: one of its own decisions in docs/decisions/, or a decision guide for adopting organisations in decision-guides/. Use for decision items, open questions, or whenever a conversation settles a choice that needs recording. For an organisation's own choices use record-an-organisation-decision instead.
---

# Writing a decision record

Two kinds, same form ([MADR](https://adr.github.io/madr/); the architecture-decision-records skill, installed by APM,
has the mechanics):

| Kind | Folder | Decided by |
|---|---|---|
| The toolkit's own decisions | `docs/decisions/` | Toolkit maintainers |
| Decision guides for adopting organisations | `decision-guides/` | An engagement role from [GLOSSARY.md](../../../GLOSSARY.md) |

A decision about the lessons themselves goes in the lessons repo's own `docs/decisions/`
([under-test-lessons](https://github.com/fiftiesHousewife/under-test-lessons)). A decision that changes both repos gets
a record in each, linking each other.

1. Copy [the template](../../../docs/decisions/template.md) to `<folder>/NNNN-<the-question-in-kebab-case>.md`, numbered
   after the last record. The title states the question or the choice in full, in plain English. Keep it to **one
   small decision**.
2. Once accepted, a record is never edited; a change is a new record that replaces it, and the old one's status says
   which record replaced it.
3. **Keep decision guides generic.** Write for any organisation: give the options and say which fits which situation.
   If an option depends on a fact (CI platform, issue tracker), name the field in the organisation profile that holds it.
4. Front matter: `status`, `decision-makers`, `group` (a group already used in that folder's README).
5. **More Information** links, by title, to the decisions this builds on and to anchors in
   [REFERENCES.md](../../../docs/REFERENCES.md).
6. Decision Outcome: "Proposed: …" or "Not yet chosen." Mark it accepted only when the decision-makers chose it in
   conversation (say so) or approved its pull request.
7. **A decision guide** is linked from its step on the [journey page](../../../docs/JOURNEY.md), in the same pull
   request (`./gradlew check` fails otherwise). When a guide's outcome changes, check that step still says the same
   thing, and the step's one line in the [README](../../../README.md).
8. Rebuild the indexes with `./gradlew buildDecisionIndexes`, and add or update the decision item in
   [plan/toolkit-backlog.yaml](../../../plan/toolkit-backlog.yaml) with `decision_record:` pointing at the file.

## Discussing a decision with a person
Use the grilling skill (installed by APM). In Claude Code, ask **one question per AskUserQuestion call**, with the
recommended option first. Write answers into the record only after the person confirms you share an understanding.
