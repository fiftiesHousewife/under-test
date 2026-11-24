#!/bin/bash
# For toolkit maintainers: lists what a release changes for adopters, to paste into the release tag's notes.
#
#   maintainer-tools/apm-package/release-notes.sh <previous tag> [new commit, default HEAD]
#
# Each decision guide added or changed, by title, since the previous tag (an organisation reviews these against its
# own decision records), then each journey skill changed. With no previous tag, say "none" to list everything.
set -euo pipefail
cd "$(git rev-parse --show-toplevel)"
previous="${1:?usage: release-notes.sh <previous tag | none> [new commit]}"
new="${2:-HEAD}"
empty_tree=4b825dc642cb6eb9a060e54bf8d69288fbee4904
if [ "$previous" = none ]; then diff_args=("$empty_tree" "$new"); else diff_args=("$previous" "$new"); fi
title() { git show "$new:$1" 2>/dev/null | sed -n 's/^# //p' | head -1; }
echo "## Decision guides added or changed"
git diff --name-status "${diff_args[@]}" -- 'decision-guides/0*.md' | while read -r status file rest; do
  case "$status" in
    A) echo "* Added: [$(title "$file")]($file)" ;;
    M) echo "* Changed: [$(title "$file")]($file)" ;;
    R*) echo "* Renamed: [$(title "$rest")]($rest)" ;;
    D) echo "* Removed: $file" ;;
  esac
done
echo
echo "## Journey skills changed"
for skill in $(ls .apm/skills); do
  if ! git diff --quiet "${diff_args[@]}" -- ".github/skills/$skill" 2>/dev/null; then echo "* $skill"; fi
done
