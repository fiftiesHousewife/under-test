#!/bin/bash
# Sets up the case's workspace: Openfire 4.6.0, a real multi-module Maven repo of about 800 Java files, with
# under-test-external-calls' facts for its xmppserver module (made by the tool at commit 7e73f41), plus the schemas and
# the decision guide the task needs. Run by claude plugin eval --scaffold, in the workspace.
#
# The right answer comes from the field trial, which ran every one of the module's tests under the airgap agent with
# every call to another machine refused: none of them reached another machine. Field-trial public repos may run that
# way without a safety inventory (decision 0089); this case runs none of Openfire's code anyway.
#
# Openfire's source is GitHub's archive of the v4.6.0 tag (commit 13e73ed), fetched once into the eval's download
# cache and checked against its SHA-256, then unpacked into the workspace with a fresh one-commit history like the
# other cases.
set -euo pipefail
here="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
toolkit="$here"
# The toolkit is the nearest folder above with AGENTS.md (the cases sit at .github/evals/ in the repo, evals/ in the
# copy run-all.sh makes).
while [ ! -f "$toolkit/AGENTS.md" ]; do toolkit="$(dirname "$toolkit")"; [ "$toolkit" = "/" ] && exit 1; done
echo "scaffold ran in $PWD" >&2
# run-all.sh names the repo's own cache in .eval-cache, so a copy of the toolkit doesn't download again.
cache="$(cat "$toolkit/.eval-cache" 2>/dev/null || echo "$toolkit/.github/evals/results/cache")"
archive="$cache/openfire-4.6.0.tar.gz"
sha256=b88accbfeeb07e0e99b2055d93d1d4604ba2cf84d40b0536e7444e060b96440d
if [ ! -f "$archive" ]; then
  mkdir -p "$cache"
  curl -sSfL -o "$archive.part" https://github.com/igniterealtime/Openfire/archive/refs/tags/v4.6.0.tar.gz
  mv "$archive.part" "$archive"
fi
[ "$(shasum -a 256 "$archive" | cut -d' ' -f1)" = "$sha256" ] || { echo "$archive isn't Openfire 4.6.0" >&2; exit 1; }
tar -xzf "$archive" --strip-components 1
cp -R "$here/fixture/." .
mkdir -p schema decision-guides
cp "$toolkit/schema/external-systems-list.schema.json" "$toolkit/schema/tests.schema.json" \
   "$toolkit/schema/external-calls.schema.json" schema/
cp "$toolkit/decision-guides/0036-order-of-preference-for-test-stand-in-approaches.md" decision-guides/
git init -q
git add .
git -c user.name=eval -c user.email=eval@example.invalid commit -qm "Openfire 4.6.0 as it is now"
