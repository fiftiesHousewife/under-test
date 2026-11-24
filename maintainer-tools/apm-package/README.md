# APM package (for toolkit maintainers)

The toolkit is one APM (Agent Package Manager) package
([why](../../docs/decisions/0051-the-toolkit-reaches-each-repo-through-apm-pinned-to-a-release-tag-and-nothing-in-it-is-copied.md)).
A repo that names it at a release tag gets the skills linked from [`.apm/skills/`](../../.apm/skills) copied where its
AI assistant finds them, and the whole toolkit in `apm_modules/`. APM rewrites the skills' links to point there. The
skills for maintaining the toolkit itself, and the skills they depend on (`devDependencies` in
[`apm.yml`](../../apm.yml)), are not part of the package. The adoption guide's step 10 gives an adopting repo's
`apm.yml`.

| Script | What it does |
|---|---|
| `check-install.sh [commit]` | Installs a commit into an empty project, as an adopting repo gets it, and checks that exactly the skills in `.apm/skills/` arrive, that every link in them resolves, and that `<toolkit>` is found as each skill says. Needs git, python3 and apm; no network |
| `release-notes.sh <previous tag \| none> [commit]` | Lists the decision guides added or changed, and the journey skills changed, for the release tag's notes |

A journey skill added to `.github/skills/` reaches adopters only once it is linked from `.apm/skills/`.

## Releasing

1. `./gradlew check`, then `maintainer-tools/apm-package/check-install.sh`.
2. Bump `version` in `apm.yml`.
3. `maintainer-tools/apm-package/release-notes.sh <previous tag>` for the notes.
4. Push, then tag `v<version>` with those notes and push the tag.
