---
status: accepted
decision-makers: Toolkit maintainers
group: Using the toolkit in an organisation
---

# Keystores and private key files are found over the whole history, by rules added to the secrets scan

## Context and Problem Statement

[The safety inventory is a gitleaks rule file run over a repo's current files, with a small converter into the assessment file](0039-the-safety-inventory-is-a-gitleaks-rule-file-run-over-a-repos-current-files-with-a-small-converter-into-the-assessment-file.md)
said that gitleaks' own rules already find keys and keystores committed in the past. They find private keys by their
text, and PKCS#12 files by name, but not Java keystores (`.jks`, `.jceks`, `.bks`) or key files found only by name. A
trial of the safety inventory skill showed it: once a keystore was deleted from the current files, the inventory no
longer found it, though it was still in the history, and still a leaked key.

## Considered Options

* **A secrets rule file that extends gitleaks' own rules with the keystore and key-file rules, run over the whole
  history; the inventory's rule file drops those two rules**  
  A keystore is found in the commit that added it, so it blocks until the history is rewritten. Each finding comes
  from one scan only, so nothing is reported twice
* **Run the whole inventory over the history too**  
  Finds the keystore, but also every scheduled job and file path that ever existed, which says nothing about the
  code today
* **Keep the rules over current files, and ask people to check the history by hand**  
  The gap the trial found

## Decision Outcome

Accepted: the first option, chosen in discussion by the toolkit maintainers. The rules are in
[`tools/safety-inventory/secrets.gitleaks.toml`](../../tools/safety-inventory/secrets.gitleaks.toml). This corrects
that one statement in the record above; the rest of it stands.

### Consequences

* The secrets scan runs `gitleaks git --config secrets.gitleaks.toml` instead of gitleaks' rules alone.
* The run-the-safety-inventory skill takes `kind:` and `tier:` from any finding's tags, from either report.
* A keystore deleted from the current files keeps blocking, and its decision stays as it is, until it has gone from
  the history.

## More Information

* Builds on: [The safety inventory is a gitleaks rule file run over a repo's current files, with a small converter into the assessment file](0039-the-safety-inventory-is-a-gitleaks-rule-file-run-over-a-repos-current-files-with-a-small-converter-into-the-assessment-file.md)
* Later decisions that build on this: none yet
* Background: [production-safety](../REFERENCES.md#production-safety)
