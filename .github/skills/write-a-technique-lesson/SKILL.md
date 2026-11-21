---
name: write-a-technique-lesson
description: Create or improve a lesson for a testing technique under techniques/<id>/ (a README plus a runnable before-and-after Gradle example). Use for lesson items in the backlog, or when asked for an example of a technique.
---

# Writing a technique lesson

The reader is an engineer who has never used the technique. The lesson must teach, not just pass.
Use `techniques/mutation-testing/` as the model. Words follow `GLOSSARY.md`; explain each industry term the first time it appears.

## Layout
```
techniques/<id>/
  technique.yaml        # already exists: rules for tools. Set example.java to "ready" when done.
  README.md             # the lesson
  example/
    build.gradle.kts    # plugins { id("io.github.fiftieshousewife.java-conventions") }
    src/main/java/io/github/fiftieshousewife/undertest/techniques/<package>/...
    src/test/java/...              # local tests: no container runtime, no network
    src/integrationTest/java/...   # only if the technique needs containers; skips itself where there is no runtime
```

## The example
- **Subject matter:** small and realistic for our organisation (payments, ledgers, batch files, MQ messages). Never foo/bar.
- **Before and after:** show the problem and the technique applied, and keep both runnable. Prefer two test classes (`Weak`/`Strong` or `Before`/`After`) with a `-Psuite=` switch, as the mutation testing lesson does.
- **Comments explain why:** each test comment says what would go wrong without it.
- **Repeatable:** no real clock, random values, network or sleeps. Must pass 5 runs in a row.
- **Safe:** no real host names, no secrets, nothing that looks like production configuration.
- **Size:** one production class or a small package.

## The README, in this order
1. Title line: workstream, test maturity level it provides evidence for, tools.
2. **What it catches:** one paragraph in plain language.
3. **Run the example:** exact commands and the result each gives. Run them; don't predict.
4. **Walk-through:** a table of weakness → what goes wrong → fix, linking to files.
5. **When to use it, and when not:** summarise `technique.yaml` and link to it. Never contradict it.
6. **How it fits the programme:** the assessment file, the acceptance check, the workstream, and the AI assistant's part.

Follow the code standards in [AGENTS.md](../../../AGENTS.md): at most three parameters, `assertAll` around several assertions, Lombok `@Slf4j` for logging.
7. **Common mistakes.**
8. **Further reading:** primary sources only.

## Checklist (the automated check for this item)
- [ ] `./gradlew :techniques:<id>:build` passes, and passes again with `--rerun-tasks`.
- [ ] Every command in the README was run, and its stated result matches.
- [ ] `technique.yaml` `example:` updated; `techniques/README.md` table updated.
- [ ] Nothing needs a container outside `integrationTest`.
- [ ] Checked against `GLOSSARY.md`.
