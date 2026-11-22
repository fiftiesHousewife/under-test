#!/bin/bash
# Sets up the case's workspace: a repo's three testing files, taken from the toolkit's examples, with two values that
# hold "</" (a question quoting "</script>", and notes with HTML markup) so the report must escape them. No template:
# the run with the skill gets the template through the plugin, and the run without it has only the request. Run by
# claude plugin eval --scaffold, in the workspace.
set -euo pipefail
here="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
toolkit="$(cd "$here/../../../.." && pwd)"
echo "scaffold ran in $PWD" >&2
mkdir -p schema testing
cp "$here/fixture/assessment.yaml" "$here/fixture/connections.calm.json" "$here/fixture/sources.yaml" testing/
cp "$toolkit/schema/assessment.schema.json" "$toolkit/schema/connection-list.schema.json" \
  "$toolkit/schema/source-list.schema.json" schema/
# The fixture's YAML files name their schemas where they are in the toolkit, so its own checks can validate them;
# here the schemas are in schema/, beside the files' folder.
for f in $(grep -rl 'yaml-language-server: \$schema=\(\.\./\)*schema/' --include='*.yaml' . 2>/dev/null); do
  sed 's#\$schema=\(\.\./\)*schema/#$schema=../schema/#' "$f" > "$f.tmp" && mv "$f.tmp" "$f"
done
git init -q
git add .
git -c user.name=eval -c user.email=eval@example.invalid commit -qm "The repo's testing files as they are now"
