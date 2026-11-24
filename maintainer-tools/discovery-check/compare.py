"""Compares under-test-external-calls' facts for a repo with what its tests tried to reach under the airgap agent.

    python3 -I compare.py <under-test-external-calls facts file> <airgap calls.jsonl, or a missing file for none>

Prints the calls by kind and target, then recall (tests that called out and have a chain), precision (tests with a
chain that called out) and the grades, with each missed test and each wrong grade named. A test's grade is worked out
as the external systems list skill does it: reaches when a reach not through a mock has a host for tests, may reach
when its address is known only at run time, otherwise cannot reach. File writes and native libraries are left out:
they are not external systems.
"""
import collections
import json
import sys
from pathlib import Path


def grade(test):
    found = "cannot reach"
    for reach in test["reaches"]:
        if reach.get("through_mock") or reach.get("address_for_tests") in ("none", "local"):
            continue
        if reach.get("address_for_tests") == "host":
            return "reaches"
        found = "may reach"
    return found


def read_calls(path):
    if not Path(path).is_file():
        return []
    calls = [json.loads(line) for line in Path(path).read_text().splitlines() if line.strip()]
    return [c for c in calls if c.get("kind") not in ("file-write", "native-library")]


def main(facts_file, calls_file):
    facts = json.loads(Path(facts_file).read_text())
    predicted = {t["test"]: t for t in facts["tests"]}
    calls = read_calls(calls_file)
    seen = collections.defaultdict(set)
    for call in calls:
        seen[call.get("test") or "(no test)"].add((call["kind"], call["target"]))
    print("Calls by kind:", dict(collections.Counter(c["kind"] for c in calls)) or "none")
    targets = collections.defaultdict(set)
    for test, pairs in seen.items():
        for pair in pairs:
            targets[pair].add(test)
    for (kind, target), tests in sorted(targets.items(), key=lambda item: -len(item[1])):
        print(f"  {kind} {target}: {len(tests)} tests")
    grades = collections.Counter(grade(t) for t in facts["tests"])
    print(f"Tests: {facts['summary']['tests']}; with a chain: {len(predicted)}; grades: {dict(grades)}")
    called = {t for t in seen if t != "(no test)"}
    missed = sorted(called - set(predicted))
    print(f"Recall: {len(called) - len(missed)} of {len(called)} tests that called out have a chain; missed: {len(missed)}")
    for test in missed:
        print("  MISSED", test, sorted(seen[test])[:3])
    flagged = {t for t, f in predicted.items() if grade(f) != "cannot reach"}
    print(f"Flagged (graded reaches or may reach): {len(flagged)}; of those, called out: {len(flagged & called)}; "
          f"made no outside call (false alarms): {len(flagged - called)}")
    for test in sorted(t for t in called if t in predicted and grade(predicted[t]) == "cannot reach"):
        print("  GRADED CANNOT REACH BUT CALLED OUT", test, sorted(seen[test])[:3])
    reaches = [t for t, f in predicted.items() if grade(f) == "reaches"]
    print(f"Graded reaches: {len(reaches)}, of which called out: {len(set(reaches) & called)}")
    if "(no test)" in seen:
        print("Calls with no test named (is airgap-junit on the test classpath?):", sorted(seen["(no test)"])[:5])


if __name__ == "__main__":
    main(sys.argv[1], sys.argv[2])
