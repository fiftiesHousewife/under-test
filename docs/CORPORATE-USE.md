# Using the toolkit inside a corporate network

This document describes the environment the toolkit is designed for: a large company with locked-down networks, fixed
platforms and formal approval for anything new. It lists the assumptions, then shows how each part of the toolkit
reaches people and is used day to day. For the adoption steps themselves, see [ADOPTION.md](../ADOPTION.md).

The assumptions are deliberately strict. If your organisation is more open, everything here still works; you just have
more options.

---

## Representative assumptions

### Network
- **No direct internet access** from workstations, build agents or servers. All outbound traffic goes through an
  authenticated proxy, and only to an allowlist.
- **No access to public code-hosting sites** (github.com, gitlab.com). Public source code can't be cloned, and links to
  it in documentation don't open.
- **Package downloads go only through the organisation's package repository** (for example Artifactory or Nexus),
  which keeps approved remote copies of Maven Central, the Gradle Plugin Portal, npm and sometimes PyPI. Builds never
  talk to those public sites directly.

### Software
- **Nothing is installed from the internet.** No `curl | sh`, no Homebrew, no `npx` of unapproved packages, no
  installers from vendor websites. Developer tools come from an approved software catalogue, installed by a central
  team.
- **New libraries and tools need approval:** a security review (known vulnerabilities, licence, maintainer), then
  publication in the package repository. This takes weeks, not minutes, so every new dependency is a cost.
- **Developers can't install system software** and usually don't have administrator rights.

### Workstations
- **Windows laptops**, often without WSL2 or any container runtime.
- An approved JDK, an approved IDE, the company's Git client, and one approved AI assistant.

### Platforms (all fixed; the toolkit fits around them)
| Concern | Typical situation |
|---|---|
| Code hosting | An internal instance (for example GitHub Enterprise Server, Bitbucket Data Center, GitLab self-managed) |
| CI | An internal platform, often on Kubernetes, with no Docker daemon in build pods |
| Image builds | A daemon-less builder (for example Buildah or Kaniko) |
| Deployment | An internal release tool with its own records of what is deployed where |
| Deployment files | Teams can deploy services, but only through the platform's control layers: they describe the service, and the platform builds its images and generates its Helm charts and Kubernetes manifests. Teams don't push images or apply Helm charts directly |
| Issue tracking | An enterprise tracker (for example Jira, cloud or self-hosted), often with a rule that every commit names a work item |
| Knowledge | An internal wiki (for example Confluence), test-management tools and regression packs |
| Secrets | A vault; production secrets should never be in repos, but sometimes are |
| AI assistant | One approved assistant (for example GitHub Copilot), with organisation policies; no unattended agents |
| AI models and tools | Only approved models, through the approved assistant. No AI tools, agents, plugins or models brought in from outside, and no calls to AI services the organisation hasn't approved |
| Container images | Only images from the organisation's own registry. An outside image gets in only by passing the organisation's security scan (most likely for a small, minimal image) or by being rebuilt on the organisation's own base image; nothing is pulled straight from a public registry (for example Docker Hub) |

### Governance
- **Change control** for production systems, and separation between production and non-production networks, which is
  sometimes imperfect.
- **Named owners** at every level of the organisation chart, with their own standards and approval rights.
- **Audit:** decisions and approvals must be traceable.

---

## How the toolkit fits

### What crosses the boundary, and how

Only versioned artifacts cross into the network, through routes that already exist. Nothing at build time or run time
reaches the internet.

```mermaid
flowchart LR
    subgraph Public["Public internet"]
        MC["Maven Central<br/>(toolkit artifacts and their dependencies)"]
        GP["Gradle Plugin Portal"]
        NPM["npm registry"]
        GH["Toolkit source on GitHub"]
    end
    subgraph Corp["Corporate network"]
        PR["Package repository<br/>(approved remote copies)"]
        MIR["Optional internal mirror<br/>of the toolkit source"]
        ORG["Organisation repo<br/>(profile, decisions, units)"]
        REPO["Each target repo"]
        CI["CI runners<br/>(no route to production)"]
        DEV["Developer workstation<br/>+ approved AI assistant"]
    end
    MC -->|approved remote| PR
    GP -->|approved remote| PR
    NPM -->|approved remote| PR
    GH -.->|optional, approved mirroring| MIR
    PR --> REPO
    PR --> CI
    PR --> DEV
    ORG -->|names toolkit version and settings| REPO
```

| Toolkit part | Reaches people as | Through |
|---|---|---|
| Convention plugin (quality checks, testing evidence, `underTest` settings) | Versioned Gradle plugin artifact | Package repository |
| Skills for the AI assistant | Versioned skills bundle, unpacked by `./gradlew installSkills` | Package repository |
| Decision guides, schemas, technique rules | Versioned content bundle | Package repository |
| Lessons with runnable examples | The lessons repo ([under-test-lessons](https://github.com/fiftiesHousewife/under-test-lessons)), through the internal source mirror | Code hosting |
| Organisation profile and decisions | Files in the organisation repo | Internal code hosting |
| Third-party tools the checks use (Checkstyle, PMD, SpotBugs, FindSecBugs, JaCoCo, PIT, forbidden APIs) | Ordinary Maven artifacts | Package repository |
| connection-paths, which the connection-list skill runs | One runnable jar, beside each version tag (and its library on Maven Central) | Package repository |

### Keeping the approval cost low

Because each new dependency needs a security review, the toolkit:

- **reuses tools organisations usually already approve** (the standard Gradle quality plugins, JUnit, AssertJ,
  SpotBugs) rather than introducing new ones;
- **avoids extra plugins where a tool can be run directly** (for example, PMD's own copy-paste detector instead of a
  separate plugin);
- **will publish a list of every external artifact it uses**, with versions and licences, with each release, so a
  security team can approve them in one pass;
- **doesn't need Docker, Python, Node or any command-line tool beyond Java and Git** for its core use. Where a tool
  currently needs more (see the gaps below), a Java-only version is planned.

### Build environment

Proxy, package repository, credentials and JDK locations stay in the organisation's existing build set-up: a Gradle
init script and `gradle.properties` in the Gradle user home, or Maven's `settings.xml`. The toolkit never sets them. In
practice:

- the Gradle wrapper points at an internal copy of the Gradle distribution;
- automatic JDK download is switched off (`org.gradle.java.installations.auto-download=false`) and Gradle uses the
  approved, installed JDK;
- the init script replaces public repositories with the package repository, and can set `underTest.*` settings for
  every build.

### Issue tracker and knowledge tools

- The programme backlog and each repo's work live in the organisation's tracker, whichever it is. The toolkit provides
  importers with an adapter per tracker. Credentials come from the person's environment, never from files.
- If every commit must name a work item, the organisation profile says so. The AI assistant then includes the key, and
  the build checks commit messages.
- Knowledge sources (wiki pages, regression packs, test-management exports, tracker history) stay inside the
  organisation. People choose which ones to feed into specification work; the toolkit never fetches them on its own.

### AI assistant

- Only the organisation's approved assistant is used, with the skills bundle installed into the folders it reads.
- A person directs it and reviews everything it produces. Unattended agents stay off unless the organisation profile
  allows them.
- AI-written tests must pass the acceptance check before they are kept.
- Only models the organisation has approved are used, through its approved assistant. No AI tools, agents, plugins or
  models are brought in from outside, and nothing calls an AI service the organisation hasn't approved. The toolkit's
  skills are instructions for the approved assistant, delivered through the package repository like the rest of the
  toolkit; they bring no model or AI tool of their own.

### Containers and production safety

- Developer machines may have no container runtime, so container tests skip themselves locally and run in CI.
- Container images come only from the organisation's own registry. An image a technique or shared test kit needs (a
  database for Testcontainers, a stand-in service) gets there in one of two ways: it passes the organisation's
  security scan, which a small, minimal image (an Alpine or distroless build) is most likely to; or it is rebuilt on
  the organisation's own base image. Nothing is pulled straight from a public registry. Testcontainers is pointed at
  the organisation's registry (its image name substitution setting), so tests name the usual images and get the
  approved copies.
- CI on Kubernetes has no Docker daemon. The organisation chooses how container tests run there (for example kubedock
  or rootless Podman) and records it in its organisation repo.
- Old repos are scanned for secrets before anything builds or runs them, and their first runs happen only on runners
  that can't reach production.

### Generated deployment files

- A repo's Helm and Kubernetes files are the platform's output, not something its team maintains. They show the
  platform's template more than the application, so discovery reads the application's own settings and the inputs the
  platform generates from, not the generated files, when drafting the connection list.
- The toolkit never asks a team to write Helm charts or push images. A shared service the toolkit suggests, such as a
  contract broker, is deployed through the control layers like any other service, and someone has to own and run it
  from then on.

---

## Lessons and videos

Lessons and their narrated videos are in their own repo,
[under-test-lessons](https://github.com/fiftiesHousewife/under-test-lessons), built to run inside a locked-down
network too. Its guide to
[using the lessons inside a company](https://github.com/fiftiesHousewife/under-test-lessons/blob/main/docs/using-inside-a-company.md)
lists everything they fetch and how to route it, and explains how to rebrand, trim or revoice the videos and how to
record videos yourself if you need to.

*Background:* [Lesson work and lesson decisions are planned and recorded in the lessons repo](decisions/0032-lesson-work-and-lesson-decisions-are-planned-and-recorded-in-the-lessons-repo.md).

---

## A day in the life

See also the [repo journey diagrams](design/repo-journey.md).


| Who | What they do | Tools they touch |
|---|---|---|
| **Toolkit Owner** | Approves a new toolkit release, raises the version in the organisation repo by pull request, passes the external artifact list to security | Package repository, organisation repo |
| **Technical Architect** | Sets `underTest` settings in the init script; records how container tests run on the CI platform | Init script, organisation repo |
| **Test Quality Lead** | Agrees thresholds, approves exceptions, reviews AI-written test checks | Organisation repo, tracker |
| **Forward Deployed Engineer** | Measures a repo, drafts its testing plan with the AI assistant, writes tests, raises pull requests that each name a work item | Workstation, AI assistant, tracker |
| **Application Owner** | Approves the repo's testing plan and signs off the batch | Code hosting, tracker |
| **Subject-matter expert** | Answers questions about business rules; confirms expected results | Tracker or wiki, review sessions |

---

## Gaps today

These are being worked on; each has an item in the backlog.

| Gap | Effect in a corporate network | Plan |
|---|---|---|
| The backlog importer needs Python (no longer the GitHub CLI; it calls the REST API) | Python may be unavailable | A Java-only loader with GitHub and Jira adapters |
| No Jira adapter yet | Jira organisations must use the tracker's own bulk import | Jira Cloud adapter |
| Convention plugin, skills bundle and content bundle not yet published | Organisations would build them from an internal copy of the source | Publish to Maven Central with each release |
| APM (Agent Package Manager) is used for this repo's own external skills | APM usually isn't allowed | Skills bundle through the package repository; APM optional |
| External artifact list not yet generated | Security review has to compile it by hand | Generated with each release |

---

## Checklist for a security review

- [ ] The list of external artifacts and licences for the toolkit version (from the release).
- [ ] Confirmation that builds resolve only from the package repository (no direct internet access).
- [ ] Confirmation that no unattended AI agents are enabled.
- [ ] Confirmation that old repos are secret-scanned and run first only on runners with no route to production.
- [ ] The organisation profile, reviewed by the Security and Platform Owner.
