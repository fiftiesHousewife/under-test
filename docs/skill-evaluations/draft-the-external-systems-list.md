# Evaluation: draft-the-external-systems-list

These runs come from before the skills' renames (find-test-anti-patterns, now find-meaningless-and-unreliable-tests;
draft-the-connection-list, now draft-the-external-systems-list), so they use the earlier names and words.

Does the [draft-the-external-systems-list](../../.github/skills/draft-the-external-systems-list/SKILL.md) skill (then named draft-the-connection-list) save an AI
assistant effort and give the same result each time? It was tried against the same task done without it.

## How it was tried

A repo with two airgap agent reports, one from its tests and one from starting the application. Between them they
reach a production database (by host lookup and by JDBC, from two tests and at start-up), another team's HTTPS
service, a mail server, a directory through JNDI, a configuration server and a metrics collector over UDP. They also
start `sendmail`, load a native library, and make one allowed call to the machine itself. The repo's assessment file
already had a safety section and a decision. Each result was compared with the connection list the skill's rules
give, and both files were checked against their schemas.

## Results

| Run | Tool calls | Tokens | Time | Result |
|---|---|---|---|---|
| Without the skill | 14 | 74,700 | 129 s | Valid. Six connections, but no stand-in proposed for any, the production database not marked as never to be reached, ids of its own, and the program and the native library recorded as connections |
| With the skill | 9 | 63,700 | 84 s | Valid and as the rules give: six connections with stand-ins proposed in the guide's order, the production database marked, `sendmail` on the application's node, the native library passed to the safety inventory, the earlier sections untouched |

## What it shows

* **The skill turns a list of addresses into a plan:** with it, each connection comes with a proposed stand-in and
  the production address is marked, which is what the Architecture Owner has to confirm. Without it, the assistant
  left every stand-in unchosen.
* It took a third fewer tool calls and a third less time, and its ids follow one rule, so a later run merges with
  this one instead of duplicating it.
* The assistant without the skill noticed that an allowed call to `localhost:8089` meant a local stand-in for the
  payments service already existed. The skill now asks for that.
