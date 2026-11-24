#!/bin/bash
# Sets up the case's workspace: a small Gradle repo whose six tests each reach a system in a different way (through a
# mock, with an embedded server, with no address in their settings, to a host, to an address known only at run time,
# and to a host named in the test itself), and one that uses an in-memory database, which is no system, with under-test-external-calls' facts for it, plus the schemas and the
# decision guide the task needs. Run by claude plugin eval --scaffold, in the workspace.
set -euo pipefail
here="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
toolkit="$here"
# The toolkit is the nearest folder above with AGENTS.md (the cases sit at .github/evals/ in the repo, evals/ in the
# copy run-all.sh makes).
while [ ! -f "$toolkit/AGENTS.md" ]; do toolkit="$(dirname "$toolkit")"; [ "$toolkit" = "/" ] && exit 1; done
echo "scaffold ran in $PWD" >&2
cp -R "$here/fixture/." .
mkdir -p schema decision-guides
cp "$toolkit/schema/external-systems-list.schema.json" "$toolkit/schema/tests.schema.json" \
   "$toolkit/schema/external-calls.schema.json" schema/
cp "$toolkit/decision-guides/0036-order-of-preference-for-test-stand-in-approaches.md" decision-guides/
git init -q
git add .
git -c user.name=eval -c user.email=eval@example.invalid commit -qm "The repo as it is now"
