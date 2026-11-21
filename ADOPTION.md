# Adopting the toolkit in your organisation

This guide is for an organisation that wants to use the toolkit on its own repositories. It assumes what is usually
true in a large company:

- **You can't install things from the internet.** Everything arrives through your own package repository (for example
  Artifactory or Nexus) and your own internal copies of source code.
- **Your platforms are fixed.** Your build tools, CI, deployment, issue tracker, code-hosting platform and AI
  assistant are already chosen. The toolkit fits around them; it never asks you to replace one.
- **Your details stay private.** Nothing about your organisation goes into the toolkit. It lives in your own private
  overlay repo.

Words follow [GLOSSARY.md](GLOSSARY.md). The decisions behind each step are linked as you go.

---

## Before you start: what is ready and what isn't

| Part | Ready to use | Still to come |
|---|---|---|
| Decision guides, glossary, technique lessons | Yes | More lessons |
| Gradle conventions and quality checks, with the `underTest` settings | Yes, from this repo's source | Published as a versioned plugin you can mirror |
| Organisation profile schema and example overlay | Yes | A validator |
| Backlog import | GitHub importer (Python and the GitHub CLI) | Jira adapter; a version that needs nothing but Java |
| Skills bundle (`installSkills`) | Designed | Built and published |
| Repo classifier | Designed, output format published | Built |
| Maven and npm set-ups | Designed | Built |

Until a part is published as an artifact, you would build it from your internal copy of this repo.

---

## Step 1: Agree roles and sponsorship

Name the people for each engagement role in [the glossary](GLOSSARY.md#engagement-roles): Programme Sponsor,
Engagement Lead, Technical Architect, Test Quality Lead, Security and Platform Owner, Toolkit Owner, and the
Steering Group. Application Owners join as their applications come into scope.

*Background:* [The programme runs as a forward deployed engagement with named roles](docs/decisions/0001-the-programme-runs-as-a-forward-deployed-engagement-with-named-roles.md).

## Step 2: Bring the toolkit inside your network

Nothing is fetched from the internet at build time. Before anyone uses the toolkit:

1. **Copy the source.** Mirror this repository into your code-hosting platform, and pin a released version (a tag).
   Your Toolkit Owner decides when to take a newer release.
2. **Mirror the dependencies.** Your package repository needs proxies (remote repositories) for Maven Central and the
   Gradle Plugin Portal, which most organisations already have. The full list of what the toolkit uses is in
   [`gradle/libs.versions.toml`](gradle/libs.versions.toml). Your security review approves those, as with any
   library. The toolkit keeps that list short on purpose: it prefers tools you probably already have, and runs PMD's
   copy-paste detector directly instead of adding another plugin.
3. **Provide the Gradle distribution and the JDK.** Point the Gradle wrapper at your internal copy of the Gradle
   distribution (`distributionUrl` in `gradle/wrapper/gradle-wrapper.properties`). Install JDK 25 on build machines
   and developer machines through your usual software channel. Then switch off Gradle's automatic JDK download, as in
   step 4.

## Step 3: Create your private overlay repo

Copy [`examples/organisation-overlay/`](examples/organisation-overlay/README.md) into a new **private** repo. Fill in
`organisation-profile.yaml` with your facts:

| Field | What you record | Example |
|---|---|---|
| `issue_tracker` | Where work is tracked | Jira Cloud, project TEST |
| `code_hosting`, `ci` | Your code-hosting and CI platforms; what builds run on; your image build tool | Kubernetes-based CI with Buildah |
| `developer_machines` | Whether developers can run containers | No container runtime |
| `package_repository` | Your package repository | Artifactory |
| `ai_assistants` | The AI assistants you allow; whether unattended AI agents are allowed | One approved assistant; agents not allowed |
| `commit_messages` | Whether every commit must name a work item, and the key pattern | Required, `[A-Z][A-Z0-9]+-[0-9]+` |
| `feature_flags` | Your flag product, if any | |
| `roles` | Who fills each role | |

The file is checked against [the organisation profile schema](schema/organisation-profile.schema.json). Facts with no
choice go here; choices go in your own decision records (step 6).

*Background:* [Organisation-specific facts and decisions live in a private overlay repo](docs/decisions/0004-organisation-specific-facts-and-decisions-live-in-a-private-overlay-repo.md).

## Step 4: Keep your build environment

Your proxy, package repository, credentials and JDK locations stay where they already are: a Gradle init script (or
`gradle.properties` in the Gradle user home) and Maven's `settings.xml`. These apply before any repo's own settings,
so the toolkit never needs to know them. Keep a copy, or a pointer to it, in your overlay. A typical Gradle init
script does four things:

```kotlin
// ~/.gradle/init.d/organisation.init.gradle.kts (placeholder values)
settingsEvaluated {
    pluginManagement.repositories { clear(); maven("https://packages.example.com/gradle-plugins") }
    dependencyResolutionManagement.repositories { clear(); maven("https://packages.example.com/maven") }
}
```

```properties
# ~/.gradle/gradle.properties (placeholder values)
systemProp.https.proxyHost=proxy.example.com
systemProp.https.proxyPort=8080
org.gradle.java.installations.auto-download=false
org.gradle.java.installations.paths=/opt/jdk-25
underTest.codeStyle=TOOLKIT
```

*Background:* [The build environment (proxy and package repository) comes from the organisation's own build set-up](docs/decisions/0008-the-build-environment-proxy-and-package-repository-comes-from-the-organisations-own-build-set-up.md).

## Step 5: Fit your code-quality standards

Build checks come in three layers:

| Layer | Who owns it | What you can do |
|---|---|---|
| Environment (proxy, package repository) | You | Always yours (step 4) |
| Code-quality standards (style, complexity, copy-paste, bug and security-bug analysis, forbidden APIs) | You choose | `underTest.codeStyle=TOOLKIT` (ours), `ORGANISATION` (our tools with your rule files), or `NONE` (your own plugin or quality gate) |
| Testing evidence (coverage, flaky-test detection, mutation sampling, checks on AI-written tests) | The programme | Always on. You set thresholds such as `underTest.minLineCoverage` through your own decisions |

```properties
underTest.codeStyle=ORGANISATION
underTest.checkstyleConfig=/path/to/your/checkstyle.xml
underTest.pmdRuleset=/path/to/your/pmd-ruleset.xml
underTest.forbiddenApiSignatures=/path/to/your/forbidden-signatures.txt
underTest.minLineCoverage=0.70
```

Testing evidence is defined by standard report files (JaCoCo, PIT, JUnit XML), not by one build plugin, so Maven and
npm repos can take part once their set-ups exist.

*Background:* [Build settings come in three layers](docs/decisions/0007-build-settings-come-in-three-layers-environment-code-quality-standards-and-testing-evidence.md)
and [Code-quality standards can be the toolkit's, the organisation's, or the organisation's own plugin](docs/decisions/0009-code-quality-standards-can-be-the-toolkits-the-organisations-or-the-organisations-own-plugin.md).

## Step 6: Work through the decision guides

The [decision guides](docs/decisions/README.md) cover every choice the programme needs, smallest first. For each one,
the deciding role reads it and either:

- **adopts it as written**: record that in your overlay with a one-line decision record; or
- **chooses between its options, or narrows it**: record the choice and the reason; or
- **replaces it**: record your own decision and why.

Use the [record-an-organisation-decision skill](.github/skills/record-an-organisation-decision/SKILL.md) with your AI
assistant to draft these. It writes into your overlay only. Settle the production-safety decisions and the container
decision first, because most others depend on them.

## Step 7: Make production safe before running anything

Old repos often hold production secrets and can reach production systems once running. Before anyone builds or runs
one, by hand, with an AI assistant, or in CI:

1. **Scan for secrets** with the tool you already use, or your code-hosting platform's own scanning.
2. **Run old code first only on CI runners that can't reach production.** Separate them by network, not by
   configuration.
3. **Switch on the production-address check** in the convention plugin once it exists.

*Background:* the decisions in [Keeping production safe](docs/decisions/README.md#keeping-production-safe).

## Step 8: Connect your issue tracker and commit rules

1. **Import the starting backlog** into your tracker with the importer for it (see
   [tools/backlog-import](tools/backlog-import/README.md)). The Jira adapter is still to be built. In an environment
   without Python or the GitHub CLI, wait for the Java version, or load the seed with your tracker's own bulk import.
2. **If every commit must name a work item**, set `commit_messages` in your profile. AI assistant skills then include
   the key in every commit, and the commit-message checks switch on.

*Background:* [The programme backlog lives in the organisation's issue tracker, not in a file](docs/decisions/0005-the-programme-backlog-lives-in-the-organisations-issue-tracker-not-in-a-file.md)
and [When the organisation requires it, every commit names its work item](docs/decisions/0039-when-the-organisation-requires-it-every-commit-names-its-work-item.md).

## Step 9: Give your AI assistant the skills

Skills arrive the same way as libraries. The skills bundle is a versioned artifact, mirrored through your package
repository, and unpacked by `./gradlew installSkills` into the folders your approved AI assistant reads. No new
installer is needed. APM (Agent Package Manager) is an optional extra, for organisations that allow it. People direct
the AI and review everything it produces; unattended AI agents stay off unless your profile allows them.

*Background:* [How AI assistant skills and instructions reach every repo](docs/decisions/0012-how-ai-assistant-skills-and-instructions-reach-every-repo.md).

## Step 10: Run the programme

1. **Classify your repos.** Run the repo classifier on each repo, or build a survey tool that calls it across your
   code-hosting platform ([design](docs/design/survey-tool.md)).
2. **Pilot.** Treat one application by hand for each common combination of technology stack and application type.
   Turn what you learn into testing guides.
3. **Roll out in batches.** For each repo: measure, generate a testing plan, have the Application Owner approve it,
   load its work into your tracker, and work through the workstreams.
4. **Hand over.** Your own teams run the batches, and the Toolkit Owner role moves inside your organisation.

## Keeping up to date

- Take new toolkit releases deliberately. Update the pinned version in your overlay through a pull request, and read
  the decision guides that changed. Accepted decision records are never edited; a change arrives as a new record.
- Re-run your profile validation and builds after each upgrade.
- Send improvements that would help any organisation back to the toolkit. Never send organisation details.
