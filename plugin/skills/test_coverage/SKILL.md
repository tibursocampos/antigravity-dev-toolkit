---
name: test-coverage
description: >
  Run .NET test coverage (Coverlet), report new-code/branch/per-file metrics, and evaluate
  against a threshold (default 80%). Use when the user says "use skill test-coverage",
  "coverage report", or "/coverage".
---

## STOP - Read before ANY tool call

1. Read `{pluginRoot}/GUARDRAILS.md`
2. Read `_shared/sdd_artifacts/SESSION.md`; load session-state for `$Cwd`
3. If the relevant gate is not approved: **STOP** - ask user **(pt-BR)** â€” do **NOT** Write/Shell
4. SDD/develop skills: after **ONE** step/task, **STOP** session - handoff only
5. This skill body is **English**; user-facing prompts may be **(pt-BR)**

### Step -1 - Gate check (report in chat before continuing)

```
Gate check:
[ ] GUARDRAILS.md read
[ ] SESSION.md read; session-state loaded
[ ] PIPELINE.md read (SDD/speckit skills only)
[ ] User confirmed current action (sim)
â†’ If any unchecked: STOP
```

---

# Skill: test-coverage

## Trigger

Use for `use skill test-coverage`, `/coverage`, or when review/PLAN requires coverage evidence.

## Outcome

Coverage report in pt-BR including:
- New-code coverage on changed production files
- Overall branch coverage
- Per-file coverage
- Pass/Fail against threshold

## Process

### -1. Re-check guardrails and session

If missing, ask user (pt-BR):

```text
Antes da cobertura, confirme:
- GUARDRAILS.md lido
- SESSION.md carregado

Posso seguir? (sim / ajustar / cancelar)
```

### -2. Resolve scope

Set base branch and changed production `.cs` files.

### 0. Collect coverage

```bash
dotnet test --collect:"XPlat Code Coverage" --results-directory TestResults/
reportgenerator -reports:"TestResults/**/coverage.cobertura.xml" -targetdir:"TestResults/CoverageReport" -reporttypes:"Html;TextSummary;Cobertura"
```

### 1. Compute metrics

Calculate new-code/overall/per-file percentages and compare with threshold (default 80).

### 2. Report artifacts

Always return paths for:
- `TestResults/CoverageReport/Summary.txt`
- `TestResults/CoverageReport/index.html`
- at least one `coverage.cobertura.xml`

### 3. Handoff

If gaps remain, suggest tests or `fix_build`. If acceptable, hand off to `code_review` or `commit`.

## Must not

- Claim pass without ReportGenerator output
- Include generated/migration files in new-code denominator
- Auto-commit or auto-push
