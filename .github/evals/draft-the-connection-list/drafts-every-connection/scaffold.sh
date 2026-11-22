#!/bin/bash
# Sets up the case's workspace: a repo holding only two airgap agent reports (one from its tests, one from starting
# the application) and an assessment file that already has a safety section and a decision, plus the two schemas and
# the two decision guides the task needs. Run by claude plugin eval --scaffold, in the workspace.
set -euo pipefail
here="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
toolkit="$here"
# The toolkit is the nearest folder above with AGENTS.md (the cases sit at .github/evals/ in the repo, evals/ in the
# copy run-all.sh makes).
while [ ! -f "$toolkit/AGENTS.md" ]; do toolkit="$(dirname "$toolkit")"; [ "$toolkit" = "/" ] && exit 1; done
echo "scaffold ran in $PWD" >&2
cp -R "$here/fixture/." .
mkdir -p schema decision-guides
cp "$toolkit/schema/connection-list.schema.json" "$toolkit/schema/assessment.schema.json" schema/
cp "$toolkit/decision-guides/0031-the-connection-list-says-what-tests-use-for-each-connection-and-which-addresses-tests-must-never-reach.md" \
   "$toolkit/decision-guides/0036-order-of-preference-for-test-stand-in-approaches.md" decision-guides/
# The fixture's YAML files name their schemas where they are in the toolkit, so its own checks can validate them;
# here the schemas are in schema/, beside the files' folder.
for f in $(grep -rl 'yaml-language-server: \$schema=\(\.\./\)*schema/' --include='*.yaml' . 2>/dev/null); do
  sed 's#\$schema=\(\.\./\)*schema/#$schema=../schema/#' "$f" > "$f.tmp" && mv "$f.tmp" "$f"
done
git init -q
git add .
git -c user.name=eval -c user.email=eval@example.invalid commit -qm "The repo as it is now"
