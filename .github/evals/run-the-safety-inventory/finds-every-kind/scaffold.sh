#!/bin/bash
# Sets up the case's workspace: the safety inventory's sample repo, with a history in which a binary keystore and a
# key file were added and then deleted, and the three reports made from it in advance by gitleaks 8.28.0 and git log
# (the eval's workspace has no gitleaks). Run by claude plugin eval --scaffold, in the workspace.
set -euo pipefail
here="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
toolkit="$(cd "$here/../../../.." && pwd)"
echo "scaffold ran in $PWD" >&2
cp -R "$toolkit/tools/safety-inventory/sample-repo/." .
cp "$here/fixture/secrets.json" "$here/fixture/safety-inventory.json" "$here/fixture/keystores-ever-added.txt" .
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
