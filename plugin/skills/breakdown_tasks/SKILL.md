---
name: breakdown_tasks
description: Break refined backlog steps into a grouped implementation task checklist saved locally (backend, frontend, tests). No tracker API or fixed workflow tasks. Use when the user says "use skill breakdown_tasks", "break down tasks", or "/breakdown_tasks".
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

# Skill: breakdown_tasks

## Trigger

Invoke when the user asks for: `use skill breakdown_tasks`, `break down tasks`, `/breakdown_tasks`, or after `refine_backlog_item`.

**Input (one of):**

| Source | Example |
|--------|---------|
| Path | `docs/backlog/my-feature.md` |
| Chat | User confirms refined markdown from current session |
| Pasted | User pastes the `Steps` section |

Prerequisite: content includes structured **Steps** (or Bug **Suggested fix**). If missing, hand off to `use skill refine_backlog_item`.

## Outcome

In the **target workspace**: `docs/implementation-tasks/<slug>.md` with grouped checklists for implementation and tests.

No external work-item creation and no mandatory organization-specific workflow rows.

## Lazy-load

| When | Path |
|------|------|
| Grouping rules, output template, optional QA/PR hints | `breakdown_tasks/reference.md` |
| Resolve existing SDD artifacts for handoff | `_shared/sdd_artifacts/STORAGE.md` |

## Process

### 0. Workspace and source

1. Confirm target repository.
2. Load refined content from path, chat, or pasted text.
3. Extract steps from `Steps` or Bug `Suggested fix` (see `breakdown_tasks/reference.md` parsing rules).

If no steps are found, stop and suggest `use skill refine_backlog_item`.

### 1. Documentation language (required before Write)

Ask once:

> Ask user (pt-BR): Language for `docs/implementation-tasks/` - **pt-BR** or **English**?

Record language in file metadata. Keep paths and identifiers in English.

### 2. Group steps

Apply heuristics from `breakdown_tasks/reference.md`:

- Prefer `####` sub-headings
- Otherwise group by repository or service name
- Otherwise group by layer (backend, frontend, tests)
- Maximum **5** implementation groups
- Test steps go to dedicated test groups, not mixed with implementation groups

### 3. Build checklist file

Write `docs/implementation-tasks/<slug>.md` using the output template in `breakdown_tasks/reference.md`:

- Implementation groups with `- [ ]` items per original step
- Separate **Tests** section when test steps exist
- Optional **Before PR** section with neutral reminders only

Do not inject fixed organization workflow tasks.

### 4. Summarize in chat

Show group names, step ranges, output path, and suggested next skills.

### 5. Handoff

| Situation | Next |
|-----------|------|
| Full SDD flow needed | `use skill sdd_spec` - `use skill sdd_plan` - `use skill sdd_develop` |
| SDD PLAN already exists | Resolve with `_shared/sdd_artifacts/STORAGE.md`; then `use skill sdd_develop - <full-plan-path> - Step 1` |
| Small isolated code change | `use skill developer` |
| Commit checklist file | `use skill commit` |

## Must not

- Create or update external tracker items
- Add fixed workflow tasks (DeskCheck, log links, mandatory tags) unless the user explicitly asks
- Write the file before language confirmation

## Handoff examples

```
use skill sdd_spec
```

```
use skill sdd_plan
```
