#!/bin/bash
# Sets up the case's workspace: the example order service after its techniques were chosen (9 adopted, 10
# deferred, 4 rejected), with its assessment file, connection list and source list, plus what the run without the
# toolkit needs: every technique rule, the assessment and connection-list schemas, and the decision guides on the
# target level and the order of workstreams. The plan template is part of the skill, so it is not copied. Run by
# claude plugin eval --scaffold, in the workspace.
set -euo pipefail
here="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
toolkit="$(cd "$here/../../../.." && pwd)"
echo "scaffold ran in $PWD" >&2
cp -R "$here/fixture/." .
mkdir -p techniques schema decision-guides
cp "$toolkit/techniques/README.md" techniques/
for rule in "$toolkit"/techniques/*/technique.yaml; do
  mkdir -p "techniques/$(basename "$(dirname "$rule")")"
  cp "$rule" "techniques/$(basename "$(dirname "$rule")")/"
done
cp "$toolkit/schema/assessment.schema.json" "$toolkit/schema/connection-list.schema.json" "$toolkit/schema/source-list.schema.json" \
  "$toolkit/schema/technique.schema.json" schema/
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
