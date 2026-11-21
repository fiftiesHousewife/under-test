---
name: write-a-decision-record
description: Draft or update a decision guide in docs/decisions/ of this toolkit (generic, any organisation). Use for decision items, open questions, or any change that needs a recorded decision. For an organisation's own choices use record-an-organisation-decision instead.
---

# Writing a decision guide

1. Copy [the template](../../../docs/decisions/template.md) to `docs/decisions/NNNN-<the-question-in-kebab-case>.md`.
   The title states the question in full, in plain English. Keep it to **one small decision**.
2. Numbers follow reading order while nothing is accepted. Once accepted, a record is never edited; a change is a new record that replaces it.
3. **Keep it generic.** Write for any organisation: give the options and say which fits which situation. If an option
   depends on a fact (CI platform, issue tracker), name the field in the organisation profile that holds it.
4. Front matter: `status`, `decision-makers` (an engagement role from [GLOSSARY.md](../../../GLOSSARY.md)), `group`.
5. **More Information** links, by title, to the decisions this builds on and to anchors in [REFERENCES.md](../../../docs/REFERENCES.md).
6. Decision Outcome: "Proposed: …" or "Not yet chosen." Never mark it accepted yourself.
7. Update the index in `docs/decisions/README.md`, and link the record from its decision item in the issue tracker.

## Discussing a decision with a person
Use the [grilling](../grilling/SKILL.md) skill. In Claude Code, ask **one question per AskUserQuestion call**, with the
recommended option first. Write answers into the record only after the person confirms you share an understanding.
