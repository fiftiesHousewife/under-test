#!/bin/bash
# Sets up the case's workspace: the example order service's assessment file and external systems list (the testing plan
# case's fixture), plus what the run without the toolkit needs: the decision guide with the obstacle table and the
# assessment schema. Run by claude plugin eval --scaffold, in the workspace.
set -euo pipefail
here="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
toolkit="$here"
# The toolkit is the nearest folder above with AGENTS.md (the cases sit at .github/evals/ in the repo, evals/ in the
# copy run-all.sh makes).
while [ ! -f "$toolkit/AGENTS.md" ]; do toolkit="$(dirname "$toolkit")"; [ "$toolkit" = "/" ] && exit 1; done
cp -R "$here/../../write-the-testing-plan/plans-every-piece-of-work/fixture/." .
# Its own list of tests: six graded as reaching the orders database, for tests-reach-external-systems.
cp -R "$here/fixture/." .
mkdir -p schema decision-guides
cp "$toolkit/schema/assessment.schema.json" "$toolkit/schema/external-systems-list.schema.json" \
   "$toolkit/schema/tests.schema.json" schema/
cp "$toolkit"/decision-guides/0029-*.md decision-guides/
for f in $(grep -rl 'yaml-language-server: \$schema=\(\.\./\)*schema/' --include='*.yaml' testing 2>/dev/null); do
  sed 's#\$schema=\(\.\./\)*schema/#$schema=../schema/#' "$f" > "$f.tmp" && mv "$f.tmp" "$f"
done
git init -q
git add .
git -c user.name=eval -c user.email=eval@example.invalid commit -qm "The repo as it is now"
