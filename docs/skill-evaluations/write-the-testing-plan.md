# Evaluation: write-the-testing-plan

Does the [write-the-testing-plan](../../.github/skills/write-the-testing-plan/SKILL.md) skill, with
[its template](../../templates/testing-plan.md), give the same plan every time from the same files? A plan is loaded
into the issue tracker by key, so two runs that key or split the work differently would duplicate or lose tracker
items.

## How it was tried

The example order service after the choose-techniques skill had run: 23 techniques decided (9 adopted, 10 deferred,
4 rejected), a connection list with three connections, flaky and weak tests, and a decided target of level 4. Two
agents followed the skill on separate copies; a third was given the same files and a plain request for a plan with
stable keys. The skill was then tightened where the runs read it differently, and run again.

## Results

| Run | Tool calls | Tokens | Time | Result |
|---|---|---|---|---|
| With the skill, first version, two runs | 4, 5 | 58,000, 61,500 | 25 s, 28 s | Both stopped, as the skill says, because a keystore finding that blocks had no decision. Seven loose rules reported |
| With the skill, third version, two runs | 16, 7 | 85,400, 78,600 | 106 s, 98 s | The same 15 pieces of work, with the same keys, order, Done when and labels. They differed only in two formatting details, both since fixed |
| Without the skill | 7 | 75,400 | 107 s | 30 pieces of work, keyed in its own form, with a "make it safe to run" group of its own ahead of the workstreams. It noticed that the target can't be reached: the only technique giving level 4 evidence, mutation testing, is deferred |

## What it shows

* **The skill makes the plan repeatable:** two runs gave the same pieces of work and the same keys, which is what
  loading the work into a tracker by key needs. Without it, the split into pieces of work and their keys depend on
  the run.
* **It doesn't save effort:** runs cost about the same either way. Its value is the same result each time.
* **The stop rule works:** both first runs refused to write a plan while a blocking safety finding had no decision.
* **The run without the skill found something the skill lacked:** a target level that no adopted technique can
  reach. The plan now has a "Reaching the target" section that shows it.
* **The faults the runs found, all fixed:**
  * no words for each stand-in approach;
  * how the never-reach sentence joins "Done when";
  * whether proposed choices are marked in the decisions list;
  * the template's own note being copied into the plan;
  * no order or separator for lists inside a cell;
  * rules for a finding that isn't there.

## Limits

One fixture, three connections. Regenerating a plan that already has tracker items was described but not tried.
