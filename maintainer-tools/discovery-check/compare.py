"""Compares under-test-external-calls' facts for a repo with what its tests tried to reach under the airgap agent.

    python3 -I compare.py <under-test-external-calls facts file> <airgap calls.jsonl, or a missing file for none>

Prints the calls by kind and target, then recall (tests that called out and have a chain), precision (tests with a
chain that called out) and the grades, with each missed test and each wrong grade named. Only calls the agent refused
count, of the kinds that go to another machine: calls to the machine itself are allowed and are not external systems.
A test's grade is worked out as the external systems list skill's grade table does it: cannot reach through a mock or
an embedded server the test starts for the kind, or with no address or a local one for tests; reaches when the
address for tests is a host; otherwise may reach.
"""
import collections
import json
import re
import sys
from pathlib import Path

OUTSIDE_KINDS = {"tcp", "udp", "database", "http", "jndi", "mail", "host-lookup"}

# The words in an embedded server's simple name, ignoring case, that make it a stand-in for each kind of reach.
STAND_INS = {
    "directory": ("ldap",),
    "mail": ("greenmail", "mail"),
    "http": ("wiremock", "mockwebserver"),
    "url": ("wiremock", "mockwebserver"),
    "database": ("postgres", "mysql", "mongo", "h2", "database"),
    "queue": ("kafka", "activemq", "artemis", "rabbit"),
}


def test_name(name):
    """A test's name as both files can agree on: Class.method, without a parameter list or an [n] invocation."""
    return re.sub(r"(\([^)]*\))?(\[\d+\])?$", "", name.replace("#", "."))


def has_stand_in(test, kind):
    names = [stand_in.rsplit(".", 1)[-1].lower() for stand_in in test.get("stand_ins", [])]
    return any(word in name for name in names for word in STAND_INS.get(kind, ()))


def grade(test):
    found = "cannot reach"
    for reach in test["reaches"]:
        address = reach.get("address_for_tests")
        if reach.get("through_mock") or has_stand_in(test, reach.get("kind")) or address in ("none", "local"):
            continue
        if address == "host":
            return "reaches"
        found = "may reach"
    return found


def read_calls(path):
    if not Path(path).is_file():
        return []
    calls = [json.loads(line) for line in Path(path).read_text().splitlines() if line.strip()]
    return [c for c in calls if c.get("outcome") == "refused" and c.get("kind") in OUTSIDE_KINDS]


def main(facts_file, calls_file):
    facts = json.loads(Path(facts_file).read_text())
    predicted = {test_name(t["test"]): t for t in facts["tests"]}
    calls = read_calls(calls_file)
    seen = collections.defaultdict(set)
    for call in calls:
        test = test_name(call["test"]) if call.get("test") else "(no test)"
        seen[test].add((call["kind"], call.get("target", "")))
    print("Calls by kind:", dict(collections.Counter(c["kind"] for c in calls)) or "none")
    targets = collections.defaultdict(set)
    for test, pairs in seen.items():
        for pair in pairs:
            targets[pair].add(test)
    for (kind, target), tests in sorted(targets.items(), key=lambda item: (-len(item[1]), item[0][1], item[0][0])):
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
