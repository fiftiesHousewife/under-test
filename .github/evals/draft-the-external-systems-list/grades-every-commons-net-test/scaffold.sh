#!/bin/bash
# Sets up the case's workspace: Apache Commons Net 3.6, a real Maven library of about 250 Java files whose functional
# tests connect to public FTP, telnet and whois servers, with under-test-external-calls' facts for it (made by the tool
# at commit 7e73f41), plus the schemas and the decision guide the task needs. Run by claude plugin eval --scaffold, in
# the workspace.
#
# The right answer comes from the field trial, which ran every test under the airgap agent with every call to another
# machine refused: 18 tests tried to reach another machine, and the tool's facts flag exactly those 18. Field-trial public repos may run that
# way without a safety inventory (decision 0089); this case runs none of Commons Net's code anyway.
#
# Commons Net's source is GitHub's archive of the NET_3_6 tag (commit 163fe46), fetched once into the eval's download
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
archive="$cache/commons-net-3.6.tar.gz"
sha256=318c696120bd48b1aa79c1b9200d203b9b5b4d6912eae432644d9547d962ba5c
if [ ! -f "$archive" ]; then
  mkdir -p "$cache"
  curl -sSfL -o "$archive.part" https://github.com/apache/commons-net/archive/refs/tags/NET_3_6.tar.gz
  mv "$archive.part" "$archive"
fi
[ "$(shasum -a 256 "$archive" | cut -d' ' -f1)" = "$sha256" ] || { echo "$archive isn't Commons Net 3.6" >&2; exit 1; }
tar -xzf "$archive" --strip-components 1
cp -R "$here/fixture/." .
mkdir -p schema decision-guides
cp "$toolkit/schema/external-systems-list.schema.json" "$toolkit/schema/tests.schema.json" \
   "$toolkit/schema/external-calls.schema.json" schema/
cp "$toolkit/decision-guides/0036-order-of-preference-for-test-stand-in-approaches.md" decision-guides/
git init -q
git add .
git -c user.name=eval -c user.email=eval@example.invalid commit -qm "Commons Net 3.6 as it is now"
