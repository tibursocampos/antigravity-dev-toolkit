---
name: dotnet_developer
description: Implement or fix small-to-medium .NET features without full SDD (Clean Architecture, xUnit). Use for isolated C# work or when invoking /dotnet_developer.
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
[ ] PIPELINE.md read (SDD skills only)
[ ] User confirmed current action (sim)
-> If any unchecked: STOP
```

---

## Trigger

Invoke when the user asks for: `use skill dotnet_developer`, `dotnet fix`, `implement .NET feature`, or for **small** backend work that does not need a full PRD/PLAN cycle.

## Outcome

Working **.NET** code and tests in the open workspace: build and tests green, on a valid feature branch, with optional commit handoff. Does not replace SDD for multi-step or cross-repo features.

## When to prefer SDD instead

Recommend `use skill sdd_spec` -> `sdd_plan` -> `sdd_develop` if **two or more** apply:

| Signal | Indicator |
|--------|-----------|
| Layers | 3+ layers (Domain, Application, Infrastructure, API) |
| Database | New or altered schema / migrations |
| Repos | Backend and another repo or service |
| Integrations | New messaging, external APIs, or consumers |
| Size | 10+ files or estimated 4+ hours |
| PLAN exists | User already has an approved PLAN - use `sdd_develop` |

## Lazy-load (only when needed)

| When | Path (after `scripts/sync-cursor.ps1`) |
|------|----------------------------------------|
| Repo context | `{pluginRoot}/skills/_shared/developer_common/step-0-context.md` |
| Before coding | `{pluginRoot}/skills/_shared/developer_common/step-0.5-review-guidelines.md` |
| Branching | `~/.cursor/rules/branch-validation.mdc`, `{pluginRoot}/skills/_shared/developer_common/step-3-branching.md` |
| Pre-commit | `{pluginRoot}/skills/_shared/developer_common/step-3.5-precommit-validation.md` |
| Commit / PR | `{pluginRoot}/skills/_shared/developer_common/step-4-commits-pr.md`, `~/.cursor/rules/conventional-commits.mdc` |
| Pre-PR gate | `{pluginRoot}/skills/_shared/developer_common/step-7-checklist.md` |
| Architecture | `{pluginRoot}/skills/_shared/dotnet_guidelines/clean-architecture.md` |
| C# / tests | `{pluginRoot}/skills/_shared/dotnet_guidelines/csharp-patterns.md` |
| Caveman Mode (if active) | `{pluginRoot}/skills/_shared/caveman/CAVEMAN.md` - **Full cap** |
| Final checklist | `{pluginRoot}/skills/_shared/dotnet_guidelines/checklist.md` |
| Context pressure | `{pluginRoot}/GUARDRAILS.md` |

Do **not** preload `code_guidelines/languages/**` or corporate pipeline docs.

## Process

### Step -1b - Caveman Mode (Full cap)
1. Read `~/.gemini/antigravity-ide/sdd/preferences.json` (create `{ "caveman_mode": false, "caveman_level": "full" }` if missing).
2. If `caveman_mode` is false: continue without compression.
3. If true: load `{pluginRoot}/skills/_shared/caveman/CAVEMAN.md`; apply **Full** participation cap + prefs `caveman_level` (Lite skills never escalate); show once: `[Caveman] Modo ativo (respostas compactas, level={effective}). Digite caveman off para desativar.`
4. Honor `caveman on|off|status|lite|full|ultra` (and `stop caveman` / `normal mode`) during the session.
5. Auto-Clarity + never-compress gates/drafts/paths per `CAVEMAN.md`.

### 0. Workspace

Confirm target repo (`*.sln` / `*.csproj`). Read `AGENTS.md` / `README.md`. Summarize the user request and acceptance (from issue text, PRD snippet, or user description).

### 1. Guidelines (step 0.5)

Follow `{pluginRoot}/skills/_shared/developer_common/step-0.5-review-guidelines.md`: load `dotnet_guidelines` files needed for this task only. Confirm test stack: **xUnit**, **Moq**, **FluentAssertions**, `Should_<Result>_When_<Condition>`.

### 2. Branch (step 3)

Baseline branch from user or repo default. Create/checkout `feature/<slug>` or `feat/<id>` - never commit on `main` / `master` / `develop`.

### 3. Plan micro-steps

List 3-7 concrete tasks (files to touch, tests to add). Stay within one session when possible; checkpoint per `context-management.mdc` (>= 40% -> pause, offer `use skill commit`).

### 4. Implement

Match existing project patterns (Glob/Read similar types first).

| Layer | Typical work |
|-------|----------------|
| Domain | Entities, value objects, domain services |
| Application | Commands/queries, handlers, validators |
| Infrastructure | EF, repositories, external clients |
| API | Endpoints, DTOs, auth filters |

Apply `clean-architecture.md` and `csharp-patterns.md` from `{pluginRoot}/skills/_shared/dotnet_guidelines/` while writing - do not paste full bodies into chat.

### 5. Tests

Add or update tests for changed behavior. Prefer integration tests for real flows when the project already uses them; unit tests for isolated logic.

### 6. Build and test

```bash
dotnet build
dotnet test --no-build
```

Fix failures within scope. Ask before running full-solution tests if the repo is very large.

### 7. Pre-commit (step 3.5) and handoff

Run `{pluginRoot}/skills/_shared/developer_common/step-3.5-precommit-validation.md` when appropriate. Offer `use skill commit` - do not commit automatically.

Before push/PR, run `{pluginRoot}/skills/_shared/developer_common/step-7-checklist.md` and `{pluginRoot}/skills/_shared/dotnet_guidelines/checklist.md`.

### 8. SDD escalation

If scope grows during work, stop and recommend:

```
use skill sdd_spec - [feature description]
# then
use skill sdd_plan - PRD/...
# then
use skill sdd_develop - PLAN/... - Step 1
```

## Must not

- ADO/MCP work items, `repo-mappings.json`, corporate pipeline or Key Vault mapping guides
- Obsolete test stacks or naming conventions (use xUnit/Moq/`Should_When_` only)
- Obsolete guideline paths (use `dotnet_guidelines/` only)
- Nested `feature/base/...` branches; commit on default integration branches
- Speculative features outside stated acceptance (YAGNI)
- Auto-commit or auto-PR without user request
- Deprecated SDD skill aliases in handoff text - use `sdd_spec`, `sdd_plan`, `sdd_develop`, `commit` only

## Handoff

| Situation | Next |
|-----------|------|
| Commit | `use skill commit` |
| Review | `use skill code_review` |
| Large scope | `use skill sdd_spec` -> `sdd_plan` -> `sdd_develop` |
| Next PLAN step | New chat -> `use skill sdd_develop - PLAN/... - Step N` |
