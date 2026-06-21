---
name: fix-build
description: >
  Diagnose and fix failing dotnet build or test runs in the target workspace. Local-first,
  optional GitHub Actions evidence via gh. Use when the user says "use skill fix-build",
  "fix build", or "/fix-build". Git-only handoff.
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

# Skill: fix-build

## Trigger

Use for `use skill fix-build`, `/fix-build`, build/test failures, or CI failures requiring local reproduction.

## Outcome

Clear diagnosis, approved fix plan, applied minimal changes, and local re-validation.

## Process

### -1. Re-check guardrails and session

If not confirmed, ask user (pt-BR):

```text
Antes de continuar, confirme:
- GUARDRAILS.md lido
- SESSION.md carregado

Posso seguir? (sim / ajustar / cancelar)
```

### -2. Caveman mode

Load Caveman rules only if enabled in preferences.

### 0. Gather evidence

Default:

```bash
dotnet build
dotnet test --no-build
```

Also accept pasted logs and optional `gh run view` output.

### 1. Diagnose

Classify each failure: compile, NuGet/restore, test assertion, config, CI YAML.

### 2. Propose fixes

List file + cause + change and wait for explicit confirmation before editing.

### 3. Apply and validate

Re-run build/tests. Use scoped tests for very large solutions.

### 4. Handoff

Offer `use skill commit`. Do not auto-commit or auto-push.

## Must not

- Depend on Azure DevOps APIs or PAT
- Skip local reproduction when possible
- Auto-commit or auto-push
