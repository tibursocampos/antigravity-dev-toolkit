---
name: code-review
description: >
  Review a branch or diff against PRD/PLAN acceptance, project standards, and shared guidelines.
  Produces a structured report (critical, important, nice-to-have). Use when the user says
  "use skill code-review", "review this PR", or "/code-review". Git-only — optional GitHub PR via gh CLI.
---

# Skill: code-review

## Trigger

Invoke when the user asks for: `use skill code-review`, `review this PR`, `code review`, or `/code-review`.

## Outcome

A structured **review report** with severity tiers (critical / important / nice-to-have) and a clear decision: **Aprovado**, **Aprovado com ressalvas**, ou **Mudanças necessárias**. Write the report in **pt-BR** (technical terms may stay in English). Does not modify code unless the user asks for fixes in a follow-up.

## Required input

| Input | Regra |
|-------|-------|
| Base branch | `main`, `develop` — ask once if missing |
| Feature branch | Current branch or named branch |
| PRD / PLAN (SDD) | Optional in invocation; **resolve in step 0.5** if omitted |

Ask the user **only after** step 0.5 if zero or multiple PRD/PLAN pairs remain ambiguous.

## Lazy-load (only when needed)

| When | Path (after sync) |
|------|-------------------|
| SDD artifact discovery (step 0.5) | `_shared/sdd_artifacts/STORAGE.md` |
| Before code analysis (.NET) | `_shared/dotnet_guidelines/clean-architecture.md`, `csharp-patterns.md` |
| Pre-PR gate (.NET) | `_shared/dotnet_guidelines/checklist.md` |
| .NET coverage report | `test-coverage` skill (quando PRD/usuário/PLAN requer cobertura) |
| Principles | `_shared/code_guidelines/principles/principles-cheatsheet.md` |

Prefer project `docs/standards/` or repo `README.md` over generic guidelines when both exist.

Do **not** preload `code_guidelines/languages/**`.

## Process

### 0. Workspace

Confirm target repo (not `antigravity-dev-toolkit` unless that is the subject). Detect stack (`*.sln` → .NET). Read `README.md`. Load dotnet-guidelines only for .NET reviews.

### 0.5 Resolve SDD artifacts

Load `STORAGE.md`. Glob workspace for `PRD/*.md`, `docs/PRD/*.md`, `PLAN/PLAN_*.md`. Pair by `NNN`. If one PRD/PLAN pair → read both before the diff review. If none → note **SDD limitation** in the report (technical review only). If ambiguous → ask once in pt-BR with numbered options.

### 1. Scope the diff

```bash
git fetch origin  # quando comparação remota for necessária
git diff <base>...<head> --stat
git diff <base>...<head>
git log <base>..<head> --oneline
```

Default `<head>` to current branch. List files; confirm with user before deep review if the set is large.

### 2. SDD traceability (when artifacts found or user provided)

- Progress bar do PLAN e status dos passos correspondem ao trabalho concluído
- Cada passo **Concluído** tem entregáveis marcados
- Critérios de aceitação do PRD mapeados para implementação e testes

Flag PLAN/PRD drift as **important** (not necessarily blocking if scope is otherwise correct).

### 3. Standards and guidelines

1. Project `docs/standards/` or equivalent
2. `_shared/dotnet_guidelines/` para .NET (camadas, testes: xUnit/NUnit, Moq/NSubstitute, Shouldly, `Should_<Result>_When_<Condition>`)
3. Principles cheatsheet quando instalado

### 4. Code analysis

| Área | Foco |
|------|------|
| Corretude | Lógica, edge cases, tratamento de erros |
| Arquitetura | Fronteiras de camadas, DI, sem vazamentos Domain → Infrastructure |
| Testes | Comportamento coberto; assertions significativas; sem testes triviais |
| Segurança | Secrets, injection, authz, logs sensíveis |
| Performance | N+1, trabalho não delimitado, async ausente onde I/O |
| Manutenibilidade | Naming, tamanho de método, duplicação; valores mágicos |

### 5. Run verification (when feasible)

| Stack | Commands |
|-------|----------|
| .NET | `dotnet build`, `dotnet test` (scoped if large) |
| .NET coverage | `use skill test-coverage` quando PRD, PLAN, ou usuário define alvo de cobertura (padrão **80%** em arquivos de produção alterados) |
| Node | `npm run build`, `npm test` per project scripts |

Record pass/fail in the report. Missing local run → note as limitation.

### 6. Decision

| Decisão | Quando |
|---------|--------|
| **Aprovado** | PRD/PLAN atendidos; sem issues críticos; testes/build green; cobertura ≥ threshold quando aplicável |
| **Aprovado com ressalvas** | Lacunas menores; sem bloqueadores de segurança/corretude; cobertura no threshold com gaps documentados |
| **Mudanças necessárias** | Bugs críticos/segurança; gaps de PRD; falhas de build/teste; cobertura < threshold quando aplicável |

### 7. Write report

Be specific: `path:line`, explain **why**, suggest **how** to fix. Include positives.

### 8. Optional PR (user-driven)

Create a PR only when the user asks and review is not **Mudanças necessárias**:

```bash
gh pr create --base <base> --head "$(git rev-parse --abbrev-ref HEAD)" \
  --title "feat: summary" --body "## Summary\n...\n\n## Test plan\n- [ ] ..."
```

## Must not

- Write or update PRD/PLAN files (hand off to `use skill spec` / `use skill plan`)
- Auto-merge, auto-approve, or rewrite code without user request
- Work-item tracker APIs, external PR platform APIs, or corporate templates
- Block on coverage only when no target applies
- Paste entire guideline files into the review output
- **AI co-author trailers** — in any form. Under NO circumstances should you include `Co-authored-by: Cursor <cursoragent@cursor.com>`, `Co-authored-by: Antigravity`, or any other AI agent attribution in commit messages or PR descriptions.

## Handoff

| Situação | Próximo |
|----------|---------|
| Nova feature / PRD de achados de review | `use skill spec` |
| Cobertura abaixo do threshold | `use skill test-coverage` → `use skill dotnet-developer` ou `implement` |
| Fixes necessários | `use skill implement` / `use skill dotnet-developer` |
| Commit de fixes | `use skill commit` |
| Todos os passos SDD concluídos + aprovado | Usuário cria PR ou merge per repo policy |
