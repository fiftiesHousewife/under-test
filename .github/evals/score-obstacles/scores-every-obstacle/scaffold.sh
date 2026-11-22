#!/bin/bash
# Sets up the case's workspace: the example order service's assessment file and connection list (the testing plan
# case's fixture), plus what the run without the toolkit needs: the decision guide with the obstacle table and the
# assessment schema. Run by claude plugin eval --scaffold, in the workspace.
set -euo pipefail
here="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
toolkit="$(cd "$here/../../../.." && pwd)"
cp -R "$toolkit/.github/evals/write-the-testing-plan/plans-every-piece-of-work/fixture/." .
mkdir -p schema decision-guides
cp "$toolkit/schema/assessment.schema.json" "$toolkit/schema/connection-list.schema.json" schema/
cp "$toolkit"/decision-guides/0029-*.md decision-guides/
for f in $(grep -rl 'yaml-language-server: \$schema=\(\.\./\)*schema/' --include='*.yaml' testing 2>/dev/null); do
  sed 's#\$schema=\(\.\./\)*schema/#$schema=../schema/#' "$f" > "$f.tmp" && mv "$f.tmp" "$f"
done
git init -q
git add .
git -c user.name=eval -c user.email=eval@example.invalid commit -qm "The repo as it is now"
