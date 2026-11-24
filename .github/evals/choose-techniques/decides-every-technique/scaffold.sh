#!/bin/bash
# Sets up the case's workspace: the example order service (a Spring Boot 2.3 web service on JDK 8 with JUnit 4 and
# Oracle, high business criticality, a decided target of level 4, flaky and weak tests, container tests in CI only)
# with its assessment file, external systems list and source list, plus what the run without the toolkit needs to decide:
# every technique rule as it is in the toolkit now (its needed_when, possible_when and reject_or_defer_when lists), the
# technique and assessment schemas, and the two decision guides on the target level and the order of workstreams. That
# developers' machines can't run containers is stated in the prompt. Run by claude plugin eval --scaffold, in the
# workspace.
set -euo pipefail
here="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
toolkit="$here"
# The toolkit is the nearest folder above with AGENTS.md (the cases sit at .github/evals/ in the repo, evals/ in the
# copy run-all.sh makes).
while [ ! -f "$toolkit/AGENTS.md" ]; do toolkit="$(dirname "$toolkit")"; [ "$toolkit" = "/" ] && exit 1; done
echo "scaffold ran in $PWD" >&2
cp -R "$here/fixture/." .
mkdir -p techniques schema decision-guides
cp "$toolkit/techniques/README.md" techniques/
for rule in "$toolkit"/techniques/*/technique.yaml; do
  mkdir -p "techniques/$(basename "$(dirname "$rule")")"
  cp "$rule" "techniques/$(basename "$(dirname "$rule")")/"
done
cp "$toolkit/schema/assessment.schema.json" "$toolkit/schema/source-list.schema.json" "$toolkit/schema/technique.schema.json" schema/
cp "$toolkit/decision-guides/0015-target-test-maturity-level-for-each-business-criticality.md" \
   "$toolkit/decision-guides/0050-the-order-of-workstreams-for-a-repo.md" decision-guides/
# The fixture's YAML files name their schemas where they are in the toolkit, so its own checks can validate them;
# here the schemas are in schema/, beside the files' folder.
for f in $(grep -rl 'yaml-language-server: \$schema=\(\.\./\)*schema/' --include='*.yaml' testing 2>/dev/null); do
  sed 's#\$schema=\(\.\./\)*schema/#$schema=../schema/#' "$f" > "$f.tmp" && mv "$f.tmp" "$f"
done
git init -q
git add .
git -c user.name=eval -c user.email=eval@example.invalid commit -qm "The repo as it is now"
