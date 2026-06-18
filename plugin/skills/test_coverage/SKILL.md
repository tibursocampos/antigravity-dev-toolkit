---
name: test-coverage
description: >
  Run .NET test coverage (Coverlet), report metrics aligned with SonarQube (new code, branch,
  per-file), and evaluate against a threshold (default 80%). Use when the user says
  "use skill test-coverage", "coverage report", or "/coverage". Git-only — no Sonar server required.
---

# Skill: test-coverage

## Trigger

Invoke when the user asks for: `use skill test-coverage`, `coverage report`, `/coverage`, or when a PLAN step / `code-review` requires coverage evidence.

**Arguments (optional):**

| Input | Meaning |
|-------|---------|
| Base branch | `main`, `develop` — ask once if missing |
| Test project path | `path/to/Tests.csproj` — auto-detect `*Tests.csproj` / `*.Tests.csproj` if omitted |
| Threshold | Minimum line coverage on **changed production `.cs` files** (default: **80**) |
| Target | **100** — aspirational; document gaps when below 100 but ≥ threshold |

## Outcome

A structured **coverage report** in **pt-BR** with:

- **Coverage on new code** — line coverage on changed production files vs base branch
- **Overall branch coverage** — solution-wide line coverage after tests
- **Per-file breakdown** — each changed production file with line %
- **Decision:** Pass (≥ threshold) or Fail (< threshold) with gap list

Does not modify code unless the user asks for test additions in a follow-up.

## Lazy-load

| When | Path |
|------|------|
| Add tests for gaps | `_shared/dotnet_guidelines/csharp-patterns.md` |
| Commit | `use skill commit` |
| Caveman Mode (if active) | `_shared/caveman/CAVEMAN.md` — Full mode |

## Process

### -1. Caveman Mode + Modo

Check `~/.gemini/antigravity-ide/sdd/preferences.json`:
- If file missing → create with `{ "caveman_mode": false }`.
- If `caveman_mode: true` → load `_shared/caveman/CAVEMAN.md` (Full mode rules) and display:
  > 🪨 Modo Caveman ativo (respostas compactas). Digite `caveman off` a qualquer momento para desativar.
- Honor `caveman on` / `caveman off` commands from the user at any point during the session.

**Agent** necessário para `dotnet test` e ReportGenerator. Em outros contextos, explicar limitação e listar paths esperados em `TestResults/` após o usuário trocar para o modo adequado.

### 0. Workspace

Confirm **target .NET repository** (`.sln` or `*Tests.csproj`). If the workspace has no test projects, stop and ask which consumer repo to open.

Detect stack; read `README.md` when present.

### 1. Resolve scope

**Base branch:** user argument, or `main` / `develop` (ask once if ambiguous).

```bash
git fetch origin   # when remote comparison is needed
git rev-parse --abbrev-ref HEAD
git diff <base>...HEAD --name-only -- "*.cs"
```

Filter to **production** changed files (exclude `*.Tests.csproj`, `*Tests*.cs`, migrations, `*.g.cs`, `*.Designer.cs`). Record the list for per-file metrics.

### 2. Prerequisites check

Before running tests, verify:

- `coverlet.collector` on test project(s)
- `dotnet test` succeeds
- `reportgenerator` global tool (install once if missing: `dotnet tool install -g dotnet-reportgenerator-globaltool`)

If `coverlet.collector` is missing, stop with install instructions — do not fail silently.

### 3. Collect coverage (mandatory ReportGenerator)

1. Run `dotnet test` with Coverlet → `TestResults/**/coverage.cobertura.xml`:

```bash
dotnet test --collect:"XPlat Code Coverage" --results-directory TestResults/
```

2. **Always** run ReportGenerator → `TestResults/CoverageReport/`:

```bash
reportgenerator -reports:"TestResults/**/coverage.cobertura.xml" -targetdir:"TestResults/CoverageReport" -reporttypes:"Html;TextSummary;Cobertura"
```

Do not finish with XML only.

### 4. Compute metrics

Parse Cobertura / ReportGenerator output:

| Metric | Definition |
|--------|------------|
| **New code** | Weighted line coverage on changed production `.cs` files |
| **Overall branch** | Line coverage across included assemblies |
| **Per-file** | Line % per changed production file |

Exclude migrations, generated code, and test projects from **new code** denominator.

### 5. Evaluate threshold

| Result | When |
|--------|------|
| **Pass** | New code coverage ≥ threshold (default 80%) |
| **Fail** | New code coverage < threshold |

Always note distance to **target 100%** for files below 100% even when Pass.

### 6. Report (chat + on-disk artifacts)

**Required in chat:**

- Workspace-relative paths to `TestResults/CoverageReport/Summary.txt`, `index.html`, and at least one `coverage.cobertura.xml`
- Key table from `Summary.txt` (paste **Resumo** section)
- Commands run, limitations, approval block (Pass) or gaps (Fail)

Do not claim Pass if ReportGenerator output or Cobertura files are missing.

### 7. Handoff

| Situação | Próximo |
|----------|---------|
| Pass | `use skill code-review` — colar bloco de aprovação do report |
| Fail — adicionar testes | `use skill dotnet-developer` ou `use skill implement` |
| Build/test quebrado | `use skill fix-build` |
| Commit tooling de cobertura no consumer repo | `use skill commit` |

## Must not

- Exigir SonarLint, Visual Studio, SonarQube login, ou APIs corporativas de pipeline
- Auto-commit, auto-push, ou adicionar testes sem solicitação do usuário
- Afirmar Pass quando testes não rodaram, coverlet output está faltando, ou ReportGenerator foi pulado
- Entregar cobertura **somente** em chat sem citar paths em `TestResults/`
- Contar migrações EF, `*.g.cs`, ou `*.Designer.cs` no denominador de new-code
- Bloquear merge por si só — o gate é informacional exceto quando PRD/PLAN/`code-review` aplica threshold
