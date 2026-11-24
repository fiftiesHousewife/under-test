# Evaluation: render-the-assessment-report

These runs come from before the skills' renames (find-test-anti-patterns, now find-meaningless-and-unreliable-tests;
draft-the-connection-list, now draft-the-external-systems-list), so they use the earlier names and words.

Does the [render-the-assessment-report](../../.github/skills/render-the-assessment-report/SKILL.md) skill, with
[its template](../../templates/repo-assessment-report.html), save an AI assistant effort and give the same result each
time? It was tried against the same task done without them.

## How it was tried

A repo with an assessment file (a safety section, the offline findings and decisions), a connection list of six
connections and a source list. Each agent was asked for a self-contained page the Application Owner can review, with
the decisions they can change. The agent without the skill was told not to read the skills or the templates folder.

## Results

| Run | Tool calls | Tokens | Time | Result |
|---|---|---|---|---|
| Without the skill | 18 | 104,800 | 333 s | A working page of its own design, checked with a stub browser; its own choice of what to show and edit, two questions added to the data, and edits kept in the browser |
| With the skill | 9 | 48,500 | 50 s | The template with the data block filled, checked to parse; nothing else changed |

## What it shows

* **The template does most of the work.** With it the assistant used half the tool calls, less than half the tokens
  and a sixth of the time, and the page is the same for every repo, so people learn it once.
* **Without it, every report is a new design,** and the assistant also wrote things into the report that weren't in
  the files: new questions, and choices about what may be changed.
* **The trial found a fault in the template:** with no safety findings blocking, it answered "safe to run" although
  two tests reach a production database. It now counts production addresses in the connection list as well. The
  assistant without the skill noticed the files were found at different commits; the template now says so.
