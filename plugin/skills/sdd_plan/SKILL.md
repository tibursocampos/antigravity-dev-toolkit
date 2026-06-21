---
name: sdd_plan
description: >
  Create a baby-step PLAN from an existing PRD. Writes an agent PLAN .md in pt-BR by default
  (in PLAN/ or docs/PLAN/ of the target repo). Use when the user says "use skill sdd_plan",
  "create plan", "/sdd_plan". Requires a PRD; output feeds sdd_develop.
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

# Skill: sdd_plan

## Trigger

Invoke when the user asks for: `use skill sdd_plan`, `create plan`, `execution plan`, or `/sdd_plan`.

## Outcome

A **PLAN** in **pt-BR** at a **canonical** path (`PLAN/PLAN_NNN_*.md`). Same `NNN` as PRD. Each step = one `sdd_develop` session. Paths and test names in **English**; no code blocks.

## Lazy-load (only when needed)

| When | Path |
|------|------|
| Pipeline guards, missing PRD dialog | `_shared/sdd_artifacts/PIPELINE.md` |
| Storage schema v2, manifest, `.gitignore` | `_shared/sdd_artifacts/STORAGE.md` |
| SDD language, context, .NET | `dev_persona` § Language, `_shared/dotnet_guidelines/*.md` |
| Caveman Mode (if active) | `_shared/caveman/CAVEMAN.md` - **Lite mode** (only framing and introductions) |

## Process

### -1. Pipeline and mode

Load `STORAGE.md` and `PIPELINE.md`. Use `STORAGE.md` schema v2 and run the dynamic storage resolution algorithm with parameter `$Workflow = classic`. Resolve `storage_mode` and `path` for the active repository. If this is the first run for the repository, execute storage mode selection and persist it in `manifest.json`.
Do not author PRD and do not write production code/tests in this skill.

Check `~/.gemini/antigravity-ide/sdd/preferences.json`:
- If file missing -> create with `{ "caveman_mode": false }`.
- If `caveman_mode: true` -> load `_shared/caveman/CAVEMAN.md` (**Lite mode** rules only) and display:
  > 🪨 Caveman mode is active (compact responses - Lite). Type `caveman off` any time to disable it.
- In Lite mode: compress only framing and introductions. Plan drafts, confirmation gates, and clarifying questions are **never** compressed.
- Honor `caveman on` / `caveman off` at any point during the session.

### 0. Workspace

Target repository. Read `README.md` if present.

### 1. Resolve PRD

Glob canonical PRDs under the resolved destination directory (local or global).

| Situation | Action |
|----------|------|
| User provided canonical PRD path | `Read`; validate status **Pronto para planejamento** |
| No canonical PRD | Use options from `PIPELINE.md` § `sdd_plan` without PRD - create PRD first or collect text/file |
| User chooses "create PRD" | Handoff to `sdd_spec`; do not write PLAN until PRD exists (unless user explicitly chooses option 2) |
| Non-canonical `.md` | Promote per `PIPELINE.md` or ask for the correct file |

Summarize PRD and ask to proceed.

### 2-4. Explore, technical questions (<=10), baby steps

Use Glob/Grep/Read. Keep each step around 20-45 minutes. For documentation steps, `sdd_develop` must ask documentation language first.

### 5. Context checkpoint

See `dev_persona` § Context Management; provide an in-chat PLAN draft if context usage reaches >=40%.

### 5.75. Confirm before write

Show `PLAN_NNN_*`, full path (resolved under the active storage-mode directory), PRD reference path, and step count. **sim** is required before `Write`.

### 6. Write PLAN (after sim)

1. Validate path per `PIPELINE.md` § Path validation helper - abort if invalid.
2. Create `PLAN/` under the resolved destination if missing.
3. Write `PLAN_NNN_*` with `NNN` matching the PRD. PRD header must include the full PRD path; all steps **Pendente**; progress `0/N`.
4. Warn before overwriting an existing PLAN with completed steps.
5. If `storage_mode` is `repository`, enforce `.gitignore` patterns per `STORAGE.md` § Repository mode - `.gitignore`.

### 7. Validate with user

Present steps, dependencies, and risks. Confirm the first `sdd_develop` step.

## Must not

- Write PLAN in English by default; embed implementation code
- Create or overwrite PRD; implement or commit in this skill
- Write PLAN without canonical PRD (except explicit user choice with provided specs)
- Skip confirmation before writing; claim PLAN saved without successful `Write`
- Use an `NNN` different from PRD

## Handoff

```
use skill sdd_develop - <full-plan-path> - Step 1
```

One session = one PLAN step.
