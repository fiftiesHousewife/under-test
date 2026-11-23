#!/usr/bin/env bash
# Makes the clean copy of the toolkit that the skill evals run on, and prints its folder:
#
#   copy="$(maintainer-tools/skill-evals/copy-toolkit.sh)"
#
# The eval runs the plugin in place and lets its sessions read only the plugin's folder, so the plugin is a copy of the
# whole toolkit (its tracked and new files, without build output or anything git ignores): the skills' links to
# templates, schemas and technique rules then work. The eval takes no symbolic links, and the cases folder only by a
# plain name, so in the copy the cases move to evals/, and the repo's download cache is named in .eval-cache instead of
# linked, so Gradle and the airgap agent are fetched once. Used by run-all.sh and check-cases.sh.
set -euo pipefail

root="$(cd "$(dirname "$0")/../.." && pwd)"
copy="$(mktemp -d "${TMPDIR:-/tmp}/under-test-evals.XXXXXX")"
(cd "$root" && git ls-files -co --exclude-standard | while IFS= read -r f; do [ -f "$f" ] && printf '%s\n' "$f"; done |
  rsync -a --files-from=- . "$copy")
mkdir -p "$root/.github/evals/results/cache"
mv "$copy/.github/evals" "$copy/evals"
printf '%s\n' "$root/.github/evals/results/cache" > "$copy/.eval-cache"
echo "$copy"
