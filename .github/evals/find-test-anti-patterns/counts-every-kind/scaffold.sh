#!/bin/bash
# Sets up the case's workspace: the sample of 24 JUnit 4 tests and 5 Cucumber scenarios, with a known number of
# each anti-pattern, an assessment file holding only its repo name, and the assessment schema (the run without the
# toolkit has no other copy). Run by claude plugin eval --scaffold, in the workspace.
set -euo pipefail
here="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
toolkit="$here"
# The toolkit is the nearest folder above with AGENTS.md (the cases sit at .github/evals/ in the repo, evals/ in the
# copy run-all.sh makes).
while [ ! -f "$toolkit/AGENTS.md" ]; do toolkit="$(dirname "$toolkit")"; [ "$toolkit" = "/" ] && exit 1; done
echo "scaffold ran in $PWD" >&2
cp -R "$toolkit/docs/skill-evaluations/find-test-anti-patterns/sample-repo/." .
mkdir -p schema testing
cp "$toolkit/schema/assessment.schema.json" schema/
cat > testing/assessment.yaml <<'YAML'
# yaml-language-server: $schema=../schema/assessment.schema.json
schema: assessment/1
repo:
  name: orders-sample
YAML
git init -q
git add .
git -c user.name=eval -c user.email=eval@example.invalid commit -qm "The repo as it is now"
