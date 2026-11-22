#!/usr/bin/env bash
# Runs gitleaks with the safety inventory's two rule files over the sample repo, and fails if the findings differ from
# the expected lists. Only the toolkit's own rules (tagged safety-inventory) are compared, so changes to gitleaks' own
# rules can't make it fail. Needs curl, jq, sha256sum and tar; runs on Linux x64 (as in CI).
set -euo pipefail

version="8.28.0"
root="$(cd "$(dirname "$0")/../.." && pwd)"
tools="$root/tools/safety-inventory"
work="$(mktemp -d)"
trap 'rm -rf "$work"' EXIT

base="https://github.com/gitleaks/gitleaks/releases/download/v$version"
archive="gitleaks_${version}_linux_x64.tar.gz"
curl -sSfL -o "$work/$archive" "$base/$archive"
curl -sSfL -o "$work/checksums.txt" "$base/gitleaks_${version}_checksums.txt"
(cd "$work" && grep " $archive\$" checksums.txt | sha256sum -c -)
tar -xzf "$work/$archive" -C "$work" gitleaks

findings() {
  "$work/gitleaks" dir --no-banner --exit-code 0 --config "$1" --report-format json --report-path "$work/report.json" \
    "$tools/sample-repo" >/dev/null
  jq -r '.[] | select(.Tags | index("safety-inventory")) | "\(.RuleID)  \(.File | sub("^.*sample-repo/"; ""))"' \
    "$work/report.json" | sort -u
}

status=0
for pair in "safety-inventory.gitleaks.toml:sample-repo-expected-findings.txt" \
            "secrets.gitleaks.toml:sample-repo-expected-secrets-findings.txt"; do
  rules="${pair%%:*}"; expected="${pair##*:}"
  if findings "$tools/$rules" | diff -u "$tools/$expected" -; then
    echo "$rules: findings match $expected"
  else
    echo "$rules: findings differ from $expected (lines marked + were found but not expected)"
    status=1
  fi
done
exit "$status"
