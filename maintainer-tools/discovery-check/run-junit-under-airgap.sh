#!/bin/bash
# Runs a module's compiled tests on the JUnit Platform (Vintage for JUnit 4) under the airgap agent, refusing every call
# to another machine, without the repo's build: for Maven repos, until measurement has a Maven route.
#
#   run-junit-under-airgap.sh <module folder> <classpath file> <package prefix> <out folder>
#
# Needs JAVA (the JDK to run the tests on), AIRGAP_AGENT, AIRGAP_JUNIT and JUNIT_CONSOLE (junit-platform-console-standalone,
# 1.10 or later) in the environment. Set ENABLE_DISABLED=1 to run tests marked @Disabled too (JUnit 5 and later).
# Everything goes on the JVM's own classpath, since some tests find their files with ClassLoader.getSystemResource.
set -u
module=$(cd "$1" && pwd); classpath_file=$2; packages=$3; out=$4
rm -rf "$out"; mkdir -p "$out"; out=$(cd "$out" && pwd)
cp="$JUNIT_CONSOLE:$module/target/test-classes:$module/target/classes:$(cat "$classpath_file"):$AIRGAP_JUNIT"
extra=()
if [ "${ENABLE_DISABLED:-0}" = 1 ]; then
    extra=(--config=junit.jupiter.conditions.deactivate='org.junit.*DisabledCondition')
fi
cd "$module"
"$JAVA" -Xbootclasspath/a:"$AIRGAP_AGENT" \
    -javaagent:"$AIRGAP_AGENT"="mode=refuse;report=$out/calls.jsonl;project=$packages;root=$module" \
    -Djdk.attach.allowAttachSelf=true -Djava.awt.headless=true \
    -cp "$cp" org.junit.platform.console.ConsoleLauncher --scan-classpath "$module/target/test-classes" \
    --include-classname '^(.*\.)?(Test[^.]*|[^.]*Tests?|[^.]*TestCase|[^.]*IT)$' "${extra[@]}" \
    --details=summary --disable-banner --reports-dir "$out/junit" > "$out/console.txt" 2>&1
status=$?
grep -E 'tests (found|successful|failed|skipped)|containers failed' "$out/console.txt"
echo "exit $status; report: $out/calls.jsonl"
