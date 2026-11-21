---
status: proposed
decision-makers: Engagement Lead
group: How we work
---

# Decision records follow MADR and are approved by pull request review

**Decided by:** Engagement Lead · **Status:** proposed

## Context and Problem Statement

Decisions need a standard, short format and a visible approval by the right role.

## Considered Options

* **MADR 4 (Markdown Architectural Decision Records), minimal form, in `docs/decisions/NNNN-<question>.md`, one decision each. Each open question is a decision item in the organisation's issue tracker, assigned to the deciding role; the pull request adding or changing the record resolves it, and approval of that pull request by the deciding role is the acceptance. Accepted records are never edited: a change of mind is a new record that replaces the old one**  
  Widely used format; approval visible in history
* **Nygard's original format**  
  Simpler, but no field for who decides
* **Decisions recorded only in issues**  
  Hard to read as a set; scattered

## Decision Outcome

Proposed: the first option. A code-owners rule on `docs/decisions/` (supported by GitHub, GitLab and Bitbucket) requires review from whoever the organisation profile names for each role. The index in `docs/decisions/README.md` is generated.

### Consequences

* Decision records in `docs/decisions/` in MADR form.
* A code-owners file generated from the organisation profile's roles.

## More Information

* Builds on: [The programme runs as a forward deployed engagement with named roles](0001-the-programme-runs-as-a-forward-deployed-engagement-with-named-roles.md), [The programme backlog lives in the organisation's issue tracker, not in a file](0005-the-programme-backlog-lives-in-the-organisations-issue-tracker-not-in-a-file.md)
* Later decisions that build on this: none yet
* Background: none
