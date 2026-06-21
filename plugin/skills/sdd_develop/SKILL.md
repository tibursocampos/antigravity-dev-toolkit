---
name: sdd_develop
description: >
  Execute one PLAN baby step. Code always in English; updates PLAN .md in the file's
  language (pt-BR default). Use when the user says "use skill sdd_develop", "implement step",
  "/sdd_develop". One session = one PLAN step.
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

# Skill: sdd_develop

## Trigger

Invoke when the user asks for: `use skill sdd_develop`, `implement step`, `execute step`, or `/sdd_develop`.

## Outcome

One **PLAN step** completed: **code and tests in English**; PLAN updated in place. Do not start the next step in the same session.

## Language

| Deliverable | Language |
|-------------|----------|
| Code, tests, comments, XML docs | **English** |
| PLAN progress/notes | **Same language as the PLAN file** |
| Product `docs/` / README | Ask first whether pt-BR or English |

Do not re-ask SDD storage and do not change artifact language mid-PLAN unless the user requests it.

## Required input

| Input | Rule |
|-------|-------|
| PLAN path | Canonical: `PLAN/PLAN_NNN_*.md` |
| Step | `Step 1`, `PASSO 1`, etc. |

## Lazy-load (only when needed)

| When | Path |
|------|------|
| Pipeline and missing PLAN dialog | `_shared/sdd_artifacts/PIPELINE.md` |
| Storage schema v2 | `_shared/sdd_artifacts/STORAGE.md` |
| .NET, Git, context | `_shared/dotnet_guidelines/*.md`, `dev_persona` § Git, § Context Management |
| Caveman Mode (if active) | `_shared/caveman/CAVEMAN.md` - Full mode |

## Process

### -1. Pipeline, mode, and Caveman

Load `STORAGE.md` and `PIPELINE.md`. Use `STORAGE.md` schema v2 and run the dynamic storage resolution algorithm with parameter `$Workflow = classic`. Resolve `storage_mode` and `path` for the active repository. If this is the first run for the repository, execute storage mode selection and persist it in `manifest.json`.
**Agent mode** is required for code changes and PLAN updates. If the user asks for PRD (`sdd_spec`) or PLAN (`sdd_plan`), route using the missing-artifacts flow and do not create PRD/PLAN in this skill.

Check `~/.gemini/antigravity-ide/sdd/preferences.json`:
- If file missing -> create with `{ "caveman_mode": false }`.
- If `caveman_mode: true` -> load `_shared/caveman/CAVEMAN.md` (Full mode rules) and display:
  > 🪨 Caveman mode is active (compact responses). Type `caveman off` any time to disable it.
- Honor `caveman on` / `caveman off` commands at any point in the session.

### 0. Workspace

Target repository. Resolve PLAN:

| Situation | Action |
|----------|------|
| Canonical PLAN path provided | `Read` the exact path (absolute or relative to active storage destination) |
| No canonical PLAN path | Glob under active storage destination; if not found, use `PIPELINE.md` § `sdd_develop` without PLAN (options 1-3) |
| User asks to create PRD/PLAN | Redirect to `sdd_spec` / `sdd_plan`; stop |

Detect stack from the selected PLAN step.

### 1. Validate step

Ensure step exists and dependencies are **Concluidas**. Summarize objective, files, and tests; then ask to proceed.

### 2. Git

Validate feature branch per `dev_persona` § Branch validation.

### 3-4. Analyze and implement

Use Glob/Grep/Read for scope. Write code/tests in English. Run targeted build/test commands.

### 5. Commit (optional)

Offer `use skill commit`; do not auto-commit.

### 6. Update PLAN + checkpoint

Mark step as completed, update progress, and note next step. Save before any context pause (>=40%).

### 7. Report

Report changed files, test results, and progress `N/M` (pt-BR). Handoff: new conversation -> `use skill sdd_develop - <full-plan-path> - Step N+1`.

-------|------|
| Commit | `use skill commit` |
| Next step | New session -> `sdd_develop - <plan> - Step N+1` |
| All steps completed | `use skill code_review` (optional) |
