---
status: proposed
decision-makers: Toolkit maintainers
group: How we work
---

# Decision records follow MADR and are approved by pull request review

**Decided by:** Toolkit maintainers · **Status:** proposed

*This is a decision about the toolkit itself, made by its maintainers.*

## Context and Problem Statement

Decisions need a standard, short format and a visible approval by the right role.

## Considered Options

* **MADR 4 (Markdown Architectural Decision Records), minimal form, one decision each: the toolkit's own decisions in `docs/decisions/`, guides for adopting organisations in `decision-guides/`, and each organisation's decisions in its organisation repo. Each open question is a decision item in the organisation's issue tracker, assigned to the deciding role; the pull request adding or changing the record resolves it, and approval of that pull request by the deciding role is the acceptance. Accepted records are never edited: a change of mind is a new record that replaces the old one**  
  Widely used format; approval visible in history
* **Nygard's original format**  
  Simpler, but no field for who decides
* **Decisions recorded only in issues**  
  Hard to read as a set; scattered

## Decision Outcome

Proposed: the first option. A code-owners rule on the decision folders (supported by GitHub, GitLab and Bitbucket) requires review from whoever the organisation profile names for each role. Each folder's index is generated.

### Consequences

* Toolkit decisions in `docs/decisions/` and guides in `decision-guides/`, in MADR form.
* A code-owners file generated from the organisation profile's roles.

## More Information

* Builds on: [The programme runs as a forward deployed engagement with named roles](../../decision-guides/0001-the-programme-runs-as-a-forward-deployed-engagement-with-named-roles.md), [The programme backlog lives in the organisation's issue tracker, not in a file](0009-the-programme-backlog-lives-in-the-organisations-issue-tracker-not-in-a-file.md)
* Later decisions that build on this: none yet
* Background: none
