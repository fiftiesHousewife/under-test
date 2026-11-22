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
# gitleaks skips empty files, so an empty sample file would hide a rule that matches by file name.
empty="$(find "$tools/sample-repo" -type f -empty)"
if [ -n "$empty" ]; then
  echo "sample-repo files must not be empty, or gitleaks skips them: $empty"
  status=1
fi

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
# gitleaks skips binary files in the history, so the skill lists keystores ever added with git log. Check that list
# finds a binary keystore committed and then deleted.
history="$work/history"
mkdir -p "$history/certs"
git -C "$history" init -q
cp "$tools/sample-repo/src/main/resources/certs/payments-client.jks" "$history/certs/old-client.jks"
git -C "$history" add .
git -C "$history" -c user.name=check -c user.email=check@example.invalid commit -qm "Add a keystore"
git -C "$history" rm -q certs/old-client.jks
git -C "$history" -c user.name=check -c user.email=check@example.invalid commit -qm "Delete it"
listed="$(git -C "$history" log --all --diff-filter=A --name-only --format='commit %h' \
  | awk '/^commit /{c=$2; next} tolower($0) ~ /\.(jks|jceks|keystore|truststore|p12|pfx|bks|pkcs12)$/ {print $0}')"
if [ "$listed" = "certs/old-client.jks" ]; then
  echo "keystore list: finds a deleted binary keystore"
else
  echo "keystore list: did not find a deleted binary keystore (got: $listed)"
  status=1
fi
exit "$status"
