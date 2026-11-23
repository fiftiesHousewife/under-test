#!/bin/bash
# Sets up the case's workspace: the sample of JUnit 4 tests and Cucumber scenarios, with a known number of
# each anti-pattern, an assessment file holding only its repo name, and the assessment schema (the run without the
# toolkit has no other copy). Run by claude plugin eval --scaffold, in the workspace.
set -euo pipefail
here="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
toolkit="$here"
# The toolkit is the nearest folder above with AGENTS.md (the cases sit at .github/evals/ in the repo, evals/ in the
# copy run-all.sh makes).
while [ ! -f "$toolkit/AGENTS.md" ]; do toolkit="$(dirname "$toolkit")"; [ "$toolkit" = "/" ] && exit 1; done
echo "scaffold ran in $PWD" >&2
cp -R "$toolkit/docs/skill-evaluations/find-test-anti-patterns/sample-repo/." .
mkdir -p schema testing
cp "$toolkit/schema/assessment.schema.json" schema/
cat > testing/assessment.yaml <<'YAML'
# yaml-language-server: $schema=../schema/assessment.schema.json
schema: assessment/1
repo:
  name: orders-sample
YAML
# PMD, as an adopter would have it: installed from the package repository by the toolkit's pmd-install, with a JDK named
# by its full path, since the run's own session can't look one up. It goes in .pmd/, which git ignores.
jdk="${EVAL_JDK_HOME:-$(/usr/libexec/java_home -v 17+ 2>/dev/null || /usr/libexec/java_home 2>/dev/null || true)}"
if [ -z "$jdk" ] || [ ! -x "$jdk/bin/java" ]; then echo "No JDK found for PMD: set EVAL_JDK_HOME" >&2; exit 1; fi
install=("$toolkit/gradlew" -q --no-daemon -p "$toolkit/tools/test-anti-patterns/pmd-install" installPmd -Pinto="$PWD/.pmd" -Pjava="$jdk/bin/java")
"${install[@]}" --offline 2>/dev/null || "${install[@]}"
if ! .pmd/pmd --version 2>/dev/null | grep -q '^PMD '; then echo "PMD didn't install: .pmd/pmd doesn't answer" >&2; exit 1; fi
printf '.pmd/\n' > .gitignore
git init -q
git add .
git -c user.name=eval -c user.email=eval@example.invalid commit -qm "The repo as it is now"
