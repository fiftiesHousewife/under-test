#!/bin/bash
# Sets up the case's workspace: the measurement sample repo (Java 8 source, JUnit 4) with a Gradle 6.9.4 wrapper, an
# assessment file whose safety section is decided, the airgap agent's init script, and a copy of the
# toolkit's measurement tools in .toolkit/ (where an organisation installs the toolkit next to a repo). Run by claude
# plugin eval --scaffold, in the workspace.
#
# The airgap agent's init script comes from its v0.1.0 release, and its jar from Maven Central; to use a
# local build of the agent instead, set EVAL_AIRGAP_AGENT to its jar. It needs a JDK 11 on the machine running the
# evals, found by /usr/libexec/java_home -v 11 or named by EVAL_JDK11_HOME: Gradle 6.9 doesn't run on newer JDKs.
# The Gradle distribution is downloaded once, checked against its published checksum, and kept in
# .github/evals/results/cache/, which isn't committed.
set -euo pipefail
here="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
toolkit="$here"
# The toolkit is the nearest folder above with AGENTS.md (the cases sit at .github/evals/ in the repo, evals/ in the
# copy run-all.sh makes).
while [ ! -f "$toolkit/AGENTS.md" ]; do toolkit="$(dirname "$toolkit")"; [ "$toolkit" = "/" ] && exit 1; done
airgap_init="https://raw.githubusercontent.com/fiftiesHousewife/under-test-airgap/v0.1.0/tools/try-it/airgap.init.gradle"
jdk11="${EVAL_JDK11_HOME:-$(/usr/libexec/java_home -v 11 2>/dev/null || true)}"
if [ -z "$jdk11" ] || [ ! -x "$jdk11/bin/java" ]; then
  echo "No JDK 11 found: set EVAL_JDK11_HOME" >&2
  exit 1
fi

# run-all.sh names the repo's own cache in .eval-cache, so a copy of the toolkit doesn't download again.
cache="$(cat "$toolkit/.eval-cache" 2>/dev/null || echo "$toolkit/.github/evals/results/cache")"
dist="$cache/gradle-6.9.4-bin.zip"
if [ ! -f "$dist" ]; then
  mkdir -p "$cache"
  curl -sSfL -o "$dist.part" https://services.gradle.org/distributions/gradle-6.9.4-bin.zip
  expected="$(curl -sSfL https://services.gradle.org/distributions/gradle-6.9.4-bin.zip.sha256)"
  actual="$(shasum -a 256 "$dist.part" | cut -d' ' -f1)"
  if [ "$expected" != "$actual" ]; then
    echo "Gradle download doesn't match its checksum" >&2
    exit 1
  fi
  mv "$dist.part" "$dist"
fi

cp -R "$toolkit/tools/measurement/sample-repo/." .
# The eval's sessions can read only their workspace, so the Gradle distribution goes inside it: a hard link where the
# cache is on the same disk, a copy otherwise.
mkdir -p .gradle-dist
ln "$dist" .gradle-dist/gradle-6.9.4-bin.zip 2>/dev/null || cp "$dist" .gradle-dist/gradle-6.9.4-bin.zip
cp "$toolkit/gradlew" .
mkdir -p gradle/wrapper
cp "$toolkit/gradle/wrapper/gradle-wrapper.jar" gradle/wrapper/
cat > gradle/wrapper/gradle-wrapper.properties <<EOF
distributionBase=GRADLE_USER_HOME
distributionPath=wrapper/dists
distributionUrl=file\\://$PWD/.gradle-dist/gradle-6.9.4-bin.zip
zipStoreBase=GRADLE_USER_HOME
zipStorePath=wrapper/dists
EOF
cat > gradle.properties <<EOF
org.gradle.java.home=$jdk11
EOF
# The agent's jar is passed by path: on the init script's classpath, Gradle 6.9 can't read its newer class files.
mkdir -p .airgap
if [ -n "${EVAL_AIRGAP_AGENT:-}" ]; then
  cp "$EVAL_AIRGAP_AGENT" .airgap/airgap-agent.jar
else
  agent="$cache/airgap-agent-0.1.0.jar"
  if [ ! -f "$agent" ]; then
    mkdir -p "$cache"
    central="https://repo1.maven.org/maven2/io/github/fiftieshousewife/airgap/airgap-agent/0.1.0/airgap-agent-0.1.0.jar"
    curl -sSfL -o "$agent.part" "$central"
    expected="$(curl -sSfL "$central.sha512")"
    actual="$(shasum -a 512 "$agent.part" | cut -d' ' -f1)"
    if [ "$expected" != "$actual" ]; then
      echo "airgap agent download doesn't match its checksum" >&2
      exit 1
    fi
    mv "$agent.part" "$agent"
  fi
  cp "$agent" .airgap/airgap-agent.jar
fi
echo "systemProp.airgap.agent=$PWD/.airgap/airgap-agent.jar" >> gradle.properties

mkdir -p .toolkit/tools/measurement .toolkit/schema .airgap
cp "$toolkit/tools/measurement/measure.init.gradle" "$toolkit/tools/measurement/README.md" .toolkit/tools/measurement/
cp "$toolkit/schema/assessment.schema.json" "$toolkit/schema/tests.schema.json" .toolkit/schema/
curl -sSfL -o .airgap/airgap.init.gradle "$airgap_init"

mkdir -p testing
cat > testing/assessment.yaml <<'YAML'
# yaml-language-server: $schema=../.toolkit/schema/assessment.schema.json
schema: assessment/1
repo:
  name: orders-sample
  summary: Prices orders, numbers them and sends confirmations.
safety:
  found_by: {tool: run-the-safety-inventory, version: unreleased, commit: "a7f3c21"}
  findings:
    - id: fixed-file-path-remindermarkertest
      kind: fixed-path-or-file-share
      effect: neutralise
      what: A fixed file path
      where: ["src/test/java/com/example/orders/ReminderMarkerTest.java:14"]
decisions:
  safety/fixed-file-path-remindermarkertest:
    state: decided
    by: Forward Deployed Engineer
    choice: accept
    reason: "It is under build/, inside the repo."
YAML
# Discovery has run and found no test that reaches an external system, so nothing is left out: the mail test's call is
# one discovery missed, for measurement to find.
cat > testing/tests.yaml <<'YAML'
# yaml-language-server: $schema=../.toolkit/schema/tests.schema.json
schema: tests/1
found_by:
  draft-the-external-systems-list: {version: unreleased, commit: "a7f3c21"}
tests: []
YAML
printf 'build/\n.gradle/\n.gradle-dist/\n' > .gitignore

git init -q
git add .
git -c user.name=eval -c user.email=eval@example.invalid commit -qm "The repo as it is now"
