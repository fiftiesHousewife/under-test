# Design: a survey tool for a GitHub organisation

**Status:** proposed design. The survey tool is **not part of this toolkit**. This document describes how a separate
tool can survey every repo in a GitHub organisation by calling this toolkit's repo classifier. It uses a public
organisation as the worked example, so it can be tried without access to any private code.

See [The estate survey sits outside the toolkit, which provides a repo classifier a survey tool can call](../decisions/0024-the-estate-survey-sits-outside-the-toolkit-which-provides-a-repo-classifier-a-survey-tool-can-call.md)
for the decision, and [the repo classification schema](../../schema/repo-classification.schema.json) for the contract
between the two.

## What it answers

1. Which repos does the organisation have, and which are still in use?
2. For each repo in use: its technology stacks and application types, and what it depends on.
3. Across the organisation: how many repos of each kind; which shared systems and libraries are used most widely;
   which repos no rule could classify.

These answers feed decisions about pilot applications, batches and shared test kits.

## Shape

```
 GitHub organisation
        │  1. list repos and metadata (GitHub REST or GraphQL API)
        ▼
  ┌───────────────┐   2. filter: archived, forks, last push, size
  │  repo list     │
  └───────┬───────┘
          │  3. shallow clone at the default branch's latest commit (skip if this commit was surveyed before)
          ▼
  ┌───────────────┐   4. run the repo classifier (static mode), one repo at a time, with a time limit
  │  classifier    │──────────────▶  classification.json per repo + commit
  └───────┬───────┘
          │  5. load all results into one local database
          ▼
  ┌───────────────┐   6. reports: counts by kind, most-used libraries and services, review list
  │  results store │
  └───────────────┘
```

## Steps in detail

| Step | How | Reuse |
|---|---|---|
| 1. List repos | `GET /orgs/{org}/repos` (paginated), or one GraphQL query for name, default branch, latest commit, archived, fork, pushed date, size, languages | GitHub CLI (`gh api --paginate`) |
| 2. Filter | Drop archived repos and forks; mark repos with no push in a set period (for example 24 months) as "unused" and skip them; record why each repo was skipped | – |
| 3. Clone | `git clone --depth 1 --single-branch` at the default branch. Skip any repo whose latest commit already has a stored result | `ghorg` can clone a whole organisation, if its licence and maintenance suit |
| 4. Classify | Run the toolkit's repo classifier in **static mode** (files only; nothing is built or run). One process per repo, a time limit per repo, and a "timed out" result rather than a crash | The repo classifier, packaged as a container image or a runnable jar |
| 5. Store | Validate each `classification.json` against the schema, then load into DuckDB or SQLite, keyed by repo and commit | DuckDB reads JSON directly |
| 6. Report | Queries for: repos per technology stack and application type; libraries and services ranked by how many repos use them; repos needing review; repos skipped and why | DuckDB SQL; output as Markdown or CSV |

## Running it

- **Where:** a scheduled CI job (for example GitHub Actions) or a laptop. For large organisations, split the repo list
  across parallel jobs (a CI matrix) and merge the results.
- **Repeat runs:** results are keyed by repo and commit, so a nightly run only clones and classifies repos with new commits.
- **Rate limits:** unauthenticated GitHub API calls are limited to a small number per hour, so use a token even for a
  public organisation. Cloning doesn't count against the API limit.
- **Resuming:** each repo's result is written as soon as it finishes; a stopped run picks up where it left off.

## Safety

- **Static mode only by default.** The survey never builds or runs a repo's code, so it can't reach production or use
  secrets found in a repo.
- **Deep mode** (build-model tools such as OpenRewrite recipes) needs a build. It is only allowed for repos that passed a
  secrets scan, on runners that can't reach production, as the toolkit's production-safety decisions require.
- **Clones are deleted** after classification. Only the classification result is kept.

## Worked example: a public organisation

Pick a public organisation with a mix of Java and TypeScript repos (for example a large open-source foundation's
GitHub organisation), then run:

```bash
survey --org <organisation> --since 24months --out results/
survey report --db results/survey.duckdb
```

Expected outputs:
- `results/<repo>/<commit>/classification.json` for each repo;
- `results/survey.duckdb`, the combined results;
- `results/report.md`: repos by technology stack and application type, the top shared libraries, and the review list.

## The repo classifier's interface (in this toolkit)

```bash
repo-classifier --repo-dir path/to/clone --commit <sha> --mode static --output classification.json
```

- Exit code 0 means classified (even with `needs_review: true`); a non-zero code means the classifier itself failed.
- Output follows [the repo classification schema](../../schema/repo-classification.schema.json).
- The classifier combines existing tools, as decided in
  [Which existing tools the repo classifier combines](../decisions/0026-which-existing-tools-the-repo-classifier-combines.md).

## Open questions for whoever builds the survey tool

- Where results should live long term (a file in a repo, a database, or the organisation's own reporting tool).
- How to map repos to applications and owners, if the organisation has a registry of them.
- Whether to add deep mode for a selected batch of repos.
