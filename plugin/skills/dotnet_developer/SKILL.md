---
name: dotnet-developer
description: >
  Implement or fix small-to-medium .NET features without full SDD. Uses Clean Architecture,
  xUnit/Moq/FluentAssertions, and Git-only developer flow. Use when the user says
  "use skill dotnet-developer", "dotnet fix", or for isolated C# work. For large cross-cutting
  features, prefer spec → plan → implement.
---

# Skill: dotnet-developer

## Trigger

Invoke when the user asks for: `use skill dotnet-developer`, `dotnet fix`, `implement .NET feature`, or for **small** backend work that does not need a full PRD/PLAN cycle.

## Outcome

Working **.NET** code and tests in the open workspace: build and tests green, on a valid feature branch, with optional commit handoff. Does not replace SDD for multi-step or cross-repo features.

## When to prefer SDD instead

Recommend `use skill spec` → `plan` → `implement` if **two or more** apply:

| Signal | Indicator |
|--------|-----------|
| Layers | 3+ layers (Domain, Application, Infrastructure, API) |
| Database | New or altered schema / migrations |
| Repos | Backend and another repo or service |
| Integrations | New messaging, external APIs, or consumers |
| Size | 10+ files or estimated 4+ hours |
| PLAN exists | User already has an approved PLAN — use `implement` |

## Lazy-load (only when needed)

| When | Path (after sync) |
|------|-------------------|
| Branching | `dev_persona` § Branch validation |
| Commit / PR | `dev_persona` § Conventional Commits; `use skill commit` |
| Architecture | `_shared/dotnet_guidelines/clean-architecture.md` |
| C# / tests | `_shared/dotnet_guidelines/csharp-patterns.md` |
| Final checklist | `_shared/dotnet_guidelines/checklist.md` |
| Contexto | `dev_persona` § Gestão de Contexto |

Do **not** preload `code_guidelines/languages/**`.

## Process

### 0. Workspace

Confirm target repo (`*.sln` / `*.csproj`). Read `README.md`. Summarize the user request and acceptance (from issue text, PRD snippet, or user description).

### 1. Guidelines

Load `_shared/dotnet_guidelines/` files needed for this task only. Confirm test stack: **xUnit**, **Moq**, **FluentAssertions**, `Should_<Result>_When_<Condition>`.

### 2. Branch

Create/checkout `feature/<slug>` or `feat/<id>` — never commit on `main` / `master` / `develop`.

### 3. Plan micro-steps

List 3–7 concrete tasks (files to touch, tests to add). Stay within one session when possible; checkpoint per `dev_persona` § Gestão de Contexto (≥ 40% → pause, offer `use skill commit`).

### 4. Implement

Match existing project patterns (Glob/Read similar types first).

| Layer | Typical work |
|-------|--------------|
| Domain | Entities, value objects, domain services |
| Application | Commands/queries, handlers, validators |
| Infrastructure | EF, repositories, external clients |
| API | Endpoints, DTOs, auth filters |

Apply `clean-architecture.md` and `csharp-patterns.md` while writing — do not paste full bodies into chat.

### 5. Tests

Add or update tests for changed behavior. Prefer integration tests for real flows when the project already uses them; unit tests for isolated logic.

### 6. Build and test

```bash
dotnet build
dotnet test --no-build
```

Fix failures within scope. Ask before running full-solution tests if the repo is very large.

### 7. Pre-commit and handoff

Run `_shared/dotnet_guidelines/checklist.md` when appropriate. Offer `use skill commit` — do not commit automatically.

### 8. SDD escalation

If scope grows during work, stop and recommend:

```
use skill spec — [feature description]
# then
use skill plan — PRD/...
# then
use skill implement — PLAN/... — Step 1
```

## Must not

- Trabalho com work-items corporativos ou APIs de terceiros
- Stacks de teste obsoletos (usar apenas xUnit/Moq/`Should_When_`)
- Branches `feature/base/...` aninhados; commit em branches de integração padrão
- Features especulativas fora do acceptance declarado (YAGNI)
- Auto-commit ou auto-PR sem solicitação do usuário

## Handoff

| Situação | Próximo |
|----------|---------|
| Commit | `use skill commit` |
| Review | `use skill code-review` |
| Escopo grande | `use skill spec` → `plan` → `implement` |
| Próximo passo do PLAN | Nova conversa → `use skill implement — PLAN/... — Step N` |
