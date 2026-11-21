# Organisation units

One folder per organisation unit that wants its own decisions or stricter settings, nested to match the organisation:
`units/<division>/<department>/...`. Each folder is owned by that unit's leads through code-owner rules.

A unit's folder can hold:

- `docs/decisions/`: decision records that **narrow** a decision from a level above (naming it, by title and link) or
  **add** a decision on something not covered above. A unit can never replace or loosen a decision made above it.
- Settings that tighten thresholds, for example a higher minimum coverage. The format and its schema arrive with the
  tool that combines the levels; until then, record them as decision records.

See [Levels of adoption](../../../ADOPTION.md#levels-of-adoption).
