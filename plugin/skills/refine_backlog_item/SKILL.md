---
name: refine_backlog_item
description: Refine an informal backlog item (Bug, User Story, Technical Story) into structured markdown with BDD acceptance criteria and a quality scorecard. Optional save to docs/backlog/ in the target repo. No tracker API. Use when the user says "use skill refine_backlog_item", "refine backlog", or "/refine_backlog_item".
---

## STOP - Read before ANY tool call

1. Read `{pluginRoot}/GUARDRAILS.md`
2. Read `_shared/sdd_artifacts/SESSION.md`; load session-state for `$Cwd`
3. If the relevant gate is not approved: **STOP** - ask user **(pt-BR)** - do **NOT** Write/Shell
4. SDD/develop skills: after **ONE** step/task, **STOP** session - handoff only
5. This skill body is **English**; user-facing prompts may be **(pt-BR)**

### Step -1 - Gate check (report in chat before continuing)

```
Gate check:
[ ] GUARDRAILS.md read
[ ] SESSION.md read; session-state loaded
[ ] PIPELINE.md read (SDD/speckit skills only)
[ ] User confirmed current action (sim)
- If any unchecked: STOP
```

---

# Skill: refine_backlog_item

## Trigger

Invoke when the user asks for: `use skill refine_backlog_item`, `refine backlog item`, `/refine_backlog_item`, or quick intake before SDD.

Optional input: path to notes, pasted description, or repository context.

## Outcome

Structured **markdown** in chat (BDD acceptance criteria + implementation steps) and a **quality scorecard**. Optionally persisted as `docs/backlog/<slug>.md` in the **target workspace**.

Does **not** create or update cards in external trackers.

## Lazy-load

| When | Path |
|------|------|
| Type templates | `_shared/backlog_item_types/{bug,user-story,technical-story}.md` |
| Scorecard rubric, boundaries, guardrails | `refine_backlog_item/reference.md` |
| Existing SDD artifacts before handoff | `_shared/sdd_artifacts/STORAGE.md` |

## Process

### 0. Workspace

Confirm the **target repository** (the product being described). Summarize detected stack if useful for steps and repositories sections.

Do **not** assume there is no PRD because `PRD/` is missing in the workspace. Check storage guidance in `_shared/sdd_artifacts/STORAGE.md` before SDD handoff.

### 1. Select item type

```
Refine backlog item

Which type?

1) Bug
2) User Story
3) Technical Story
```

Load the matching file from `_shared/backlog_item_types/`.

### 2. Collect description

Ask for a free-form description (problem, goal, context, constraints). If details are thin, use collection questions from the type file. Do not publish placeholder sections.

### 3. Generate documentation

Follow the selected type file **Output template** and **Writing guidelines**.

- Steps: one responsibility per step, infinitive verbs, explicit dependencies, and parallel notes when independent.
- BDD: use **Given / When / Then / And** with verifiable outcomes.

### 4. Quality scorecard

Immediately after the markdown, score per `refine_backlog_item/reference.md` scorecard. Show total `/100`, strengths, and concrete improvements.

### 5. Validation

Before final output, apply guardrails in `refine_backlog_item/reference.md` (no vague phrases, complete sections, no unit-test-only acceptance criteria).

### 6. Optional persistence

Ask whether to save under `docs/backlog/<slug>.md`.

If yes, ask once:

> Ask user (pt-BR): Language for `docs/backlog/` - **pt-BR** or **English**?

Write prose in that language. Paths and identifiers stay in English. Build slug from title using kebab-case.

### 7. Handoff

| Situation | Next |
|-----------|------|
| Break into implementation checklist | `use skill breakdown_tasks` (same content or saved path) |
| Medium/high complexity feature | `use skill sdd_spec` - `use skill sdd_plan` - `use skill sdd_develop` |
| Small isolated code change | `use skill developer` |
| Commit saved file | `use skill commit` |

## Must not

- Call tracker APIs or external work-item integrations
- Add organization-specific mandatory tags or custom fields
- Write `docs/backlog/` before language confirmation when saving
- Treat `docs/backlog/` as SDD PRD replacement

## Handoff examples

```
use skill breakdown_tasks - docs/backlog/export-archived-records.md
```

```
use skill sdd_spec
```
