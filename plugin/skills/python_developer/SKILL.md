---
name: python_developer
description: Implement or fix small-to-medium Python features without full SDD (FastAPI/Flask, pytest). Use for isolated Python work or when invoking /python_developer.
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
[ ] User confirmed current action (sim)
-> If any unchecked: STOP
```

---

## Trigger

Use when user asks for `use skill python_developer`, `python fix`, or a small isolated Python implementation.

## Outcome

Working Python code and tests in the target workspace, validated with pytest/build, with optional handoff to `use skill commit`.

## When to escalate to SDD

Recommend `sdd_spec` -> `sdd_plan` -> `sdd_develop` for schema changes, new services, or 10+ file changes.

## Lazy-load references

| When | Path |
|------|------|
| Branch / commit | `~/.cursor/rules/branch-validation.mdc`, `{pluginRoot}/skills/_shared/developer_common/step-3-branching.md` |
| Python guidelines | `{pluginRoot}/skills/_shared/python-guidelines/` |
| Principles | `{pluginRoot}/skills/_shared/code_guidelines/principles/` |
| Context | `{pluginRoot}/GUARDRAILS.md` |
| Caveman (if active) | `{pluginRoot}/skills/_shared/caveman/CAVEMAN.md` |

Do not preload unrelated guideline trees.

## Process

### 0. Workspace

Confirm Python project (`pyproject.toml`, `requirements.txt`, or `.py` layout). Summarize acceptance.

### 1. Guidelines

Load only required Python guidelines (PEP-8, project style).

### 2. Branch

Use `feature/<slug>` or `feat/<id>`.

### 3. Micro-plan

Define 3-7 concrete tasks; checkpoint context at >= 40%.

### 4. Implement

Use virtual environment (`venv` or `uv`). Match existing package layout.

### 5. Tests

pytest for changed behavior.

### 6. Validate

```bash
pytest
```

Add build/lint steps if configured (`ruff`, `mypy`, etc.).

### 7. Handoff

Offer `use skill commit`. Do not commit automatically.

## Must not

- Auto-commit or auto-PR
- Leave AI traces in code or identifiers

## Handoff

| Situation | Next |
|-----------|------|
| Commit | `use skill commit` |
| Review | `use skill code_review` |
| Scope grew | `sdd_spec` -> `sdd_plan` -> `sdd_develop` |
