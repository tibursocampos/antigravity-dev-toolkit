---
name: sdd_spec
description: >
  Create a PRD for a new feature or change. Writes an agent PRD .md in pt-BR by default
  (in PRD/ or docs/PRD/ of the target repo). Use when the user says "use skill sdd_spec",
  "create spec", "new feature", or "/sdd_spec". Output feeds the sdd_plan skill.
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

# Skill: sdd_spec

## Trigger

Invoke when the user asks for: `use skill sdd_spec`, `create spec`, `new feature`, or `/sdd_spec`.

## Outcome

A complete **PRD** (agent `.md` artifact) in **Brazilian Portuguese (pt-BR)** at a **canonical** path (`PRD/`, `docs/PRD/`). English only if the user overrides in this invocation. Mandatory input for **sdd_plan**.

## PRD boundaries

The PRD answers **what**, not **how**. No implementation code. Identifiers (types, APIs, paths) in **English**.

## Lazy-load (only when needed)

| When | Path (after sync) |
|------|-------------------|
| Pipeline guards, modes, confirm, paths | `_shared/sdd_artifacts/PIPELINE.md` |
| Storage schema v2, manifest, `.gitignore` | `_shared/sdd_artifacts/STORAGE.md` |
| .NET / C# context | `_shared/dotnet_guidelines/clean-architecture.md`, `csharp-patterns.md` |
| Caveman Mode (if active) | `_shared/caveman/CAVEMAN.md` - **Lite mode** (only framing and introductions) |

## Process

### -1. Pipeline and mode

Load `STORAGE.md` and `PIPELINE.md`. Use `STORAGE.md` schema v2 and run the dynamic storage resolution algorithm with parameter `$Workflow = classic`. Resolve `storage_mode` and `path` for the active repository. If this is the first run for the repository, execute the storage mode selection flow and persist it in `manifest.json`.
Confirm before writing - no `Write` without explicit **sim** from the user. Guardrail: without PLAN, do not `Write` to `*.cs`, `*.csproj`, or migrations.

Check `~/.gemini/antigravity-ide/sdd/preferences.json`:
- If file missing -> create with `{ "caveman_mode": false }`.
- If `caveman_mode: true` -> load `_shared/caveman/CAVEMAN.md` (**Lite mode** rules only) and display:
  > 🪨 Caveman mode is active (compact responses - Lite). Type `caveman off` any time to disable it.
- In Lite mode: compress only framing and introductions. Spec drafts, confirmation gates, and clarifying questions are **never** compressed.
- Honor `caveman on` / `caveman off` at any point during the session.

### 0. Workspace

Target repository (not `antigravity-dev-toolkit`, unless that is the explicit scope). Read `README.md`. Detect stack. Glob existing PRDs to determine `NNN`.

### 1. Requirements

**Prior context** (chat, code review, backlog): provide a structured summary plus at most **3** gap questions - skip the full questionnaire.

**Otherwise**, Ask user (pt-BR):

```
Vou criar o PRD. Informe:
1) Feature - o que construir ou alterar?
2) Comportamento atual
3) Comportamento esperado
4) Contexto adicional (opcional)
5) ID de rastreamento (opcional)
```

Wait for answers.

### 2-5. Confirm repo, explore code, clarify (<=5), technical analysis

Confirm branch, use Glob/Grep/Read, and capture concise impact and risk notes for the PRD.

### 6. Context checkpoint

At >=40% context usage, draft in chat or a partial file and notify before continuing. See `dev_persona` § Context Management.

### 6.75. Confirm before write

Show title, `NNN`, **full canonical path** (resolved under the active storage-mode directory), storage mode, bullets, and status **Pronto para planejamento**. Wait for **sim** / **ajustar** / **cancelar**.

### 7. Write PRD (after sim)

1. Validate path per `PIPELINE.md` § Path validation helper - abort if invalid.
2. Create `PRD/` or `docs/PRD/` in the resolved destination if missing.
3. Write `NNN_short_feature_slug.md`; body in pt-BR.
4. If `storage_mode` is `repository`, enforce `.gitignore` patterns per `STORAGE.md` § Repository mode - `.gitignore`.

Report written path, language, and storage mode. Handoff: `use skill sdd_plan - <full-prd-path>`.

## Must not

- Write PRD in English by default; include implementation code in PRD
- Write outside canonical PRD folders; skip confirmation before writing
- Write in production code or tests; create PLAN in this session
- Claim "PRD saved" without a successful `Write`
- Use external trackers; paste full guideline bodies into PRD

## Handoff

```
use skill sdd_plan - <full-prd-path>
```
